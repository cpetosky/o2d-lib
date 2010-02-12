/*
 * o2d -- a 2D game engine -- Game engine implementation
 * Copyright (C) 2007 Cory Petosky
 * 
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 */

#include "Game.h"
#include "Exception.h"
#include <iostream>
#include <sstream>
#include <cstdlib>

namespace o2d {
	const int Game::SCREEN_WIDTH = 640;
	const int Game::SCREEN_HEIGHT = 480;
	const int Game::SCREEN_BPP = 32;
	const int Game::MOVE_RATE = 120;
	const int Game::ANIMATE_RATE = 175;
	const int Game::VERTICAL_THRESHOLD = 160;
	const int Game::HORIZONTAL_THRESHOLD = 200;
	
	const SDL_Color Game::BLACK = {0, 0, 0};
	const SDL_Color Game::WHITE = {0xFF, 0xFF, 0xFF};
	
	
	Game::Game(std::string path) :
				screenMode(SDL_DOUBLEBUF | SDL_SWSURFACE),
				screen(SDL_SetVideoMode(SCREEN_WIDTH, SCREEN_HEIGHT, SCREEN_BPP, screenMode)),
				running(false),
				moveLeft(false), moveRight(false), moveUp(false), moveDown(false),
				showFPS(false), pause(false), grid(false), entityFrame(0), 
				imageLoader(path), db(path, imageLoader), 
				scriptEngine(*this, db), eBlitter(screen, view) {
		// Make sure screen is initialized		
		if (screen == NULL) {
			std::ostringstream s;
			s << "Could not initialize screen: " << SDL_GetError();
			throw Exception(s.str().c_str());
		}

		if (db.getMapCount() < 1)
			throw Exception("No map files found in database.");
		
		SDL_WM_SetCaption(db.getTitle().c_str(), NULL);
		SDL_ShowCursor(0);

		// Set up view rectangle
		view.x = view.y = 0;
		view.w = SCREEN_WIDTH;
		view.h = SCREEN_HEIGHT;
		
		// Initialize map and entities
		blitter = new SDLTileBlitter(screen);
		map = &db.getInitialMap();
		entities = map->getEntities();
		player = db.getInitialAvatar();
		entities.push_back(player);
		
		// Initialize scripts
		for (int i = 0; i < entities.size(); ++i)
			scriptEngine.track(entities[i]);
		
		lastTick = SDL_GetTicks();
		dist = 0;
		oldCount = 0;
		count = 0;
		animCount = 0;
		running = true;
		moveSum = 0;
	
		SDL_EnableKeyRepeat(0, 0);
		
		font = TTF_OpenFont((db.getPath() / "fonts" / "freemono.ttf").string().c_str(), 16);
	}
	
	Game::~Game() {
		// Quit SDL
		SDL_Quit();
	}
	
	void Game::run() {
		// Process scripts

		player->setSpeed(120);

		while (running) {
			renderFrame();
			handleEvent();
			
			scriptEngine.run();
		}		
	}
	
	void Game::renderFrame() {
		int delta = SDL_GetTicks() - lastTick;
		lastTick = SDL_GetTicks();
		
		// FPS calculation
		dist += delta;
		count++;
		if (dist >= 1000) {
			dist -= 1000;
			oldCount = count;
			count = 0;
		}
		
		if (!pause) {
			// Animation calculation
			animCount += delta;
			if (animCount >= 400) {
				animCount -= 400;
				map->nextFrame();
			}
			
			int xPos = player->getX();
			int yPos = player->getY();
			
			// Move
			for (std::vector<Entity*>::iterator it = entities.begin(); it != entities.end(); ++it) {
				Entity* e = *it;
				e->passTime(delta);
				e->move(delta);
				
				// Animation
				if (!e->isAnimating() && e->isMoving())
					e->startAnimation(175);
				else if (e->isAnimating() && !e->isMoving())
					e->stopAnimation();
			}
			
			int move;
		
			move = player->getY() - yPos;
			
			// Scroll up, if necessary	
			if ((move < 0) && (player->getY() - view.y < VERTICAL_THRESHOLD) && (view.y + move >= 0))
				view.y += move;
				
			// Scroll down, if necessary
			if ((move > 0) && ((view.y + view.h) - (player->getY() + player->getHeight()) < VERTICAL_THRESHOLD) &&
					(view.y + move < map->getPixelHeight() - view.h))
				view.y += move;
			
			move = player->getX() - xPos;
		
			// Scroll left, if necessary
			if ((move < 0) && (player->getX() - view.x < HORIZONTAL_THRESHOLD) && (view.x + move >= 0))
				view.x += move;
			
			// Scroll right, if necessary
			if ((move > 0) && ((view.x + view.w) - (player->getX() + player->getWidth()) < HORIZONTAL_THRESHOLD) &&
				(view.x + move < map->getPixelWidth() - view.w))
				view.x += move;
		}
				
		std::sort(entities.begin(), entities.end());
		// Render
		for (int i = 0; i < Map::PRIORITIES; ++i) {		
			map->renderPriority(blitter, view.x, view.y, view.w, view.h, i, grid);
			for (std::vector<Entity*>::iterator it = entities.begin(); it != entities.end(); it++) {
				eBlitter.blitPart(**it, i);
			}
		}
		
		// FPS Rendering
		if (showFPS) {
			std::stringstream s;
			s << "FPS: " << oldCount;
			fpsText = TTF_RenderText_Shaded(font, s.str().c_str(), BLACK, WHITE);
			SDL_Surface* temp = SDL_DisplayFormatAlpha(fpsText);
			SDL_BlitSurface(temp, NULL, screen, NULL);
			SDL_FreeSurface(temp);
			SDL_FreeSurface(fpsText);
		}
		
		if (SDL_Flip(screen) == -1)
			throw Exception("Failed to flip screen buffer.");
		
	}
	
	void Game::handleEvent() {
		// Handle one event, if one exists.
		SDL_Event event;
		if (SDL_PollEvent(&event)) {
			switch (event.type) {
				case SDL_QUIT:
					running = false;
					break;
				case SDL_KEYDOWN:
					switch (event.key.keysym.sym) {
						case SDLK_ESCAPE: running = false; break;
						case SDLK_LEFT: moveLeft = true; break;
						case SDLK_RIGHT: moveRight = true; break;
						case SDLK_UP: moveUp = true; break;
						case SDLK_DOWN: moveDown = true; break;
						case SDLK_F9:
							// Toggle showing grid
							grid = !grid;
							break;
							
						case SDLK_F10:
							// Toggle showing FPS
							showFPS = !showFPS;
							break;
							
						case SDLK_F11:
							// Switch between hwsurface and swsurface
							if (screenMode & SDL_SWSURFACE) {
								screenMode &= !SDL_SWSURFACE;
								screenMode |= SDL_HWSURFACE;
								screenMode |= SDL_DOUBLEBUF;
							} else {
								screenMode &= !SDL_HWSURFACE;
								screenMode |= SDL_SWSURFACE;								
							}
							SDL_SetVideoMode(SCREEN_WIDTH, SCREEN_HEIGHT, SCREEN_BPP, screenMode);
							break;
							
						case SDLK_F12:
							// Toggle fullscreen mode
							if (screenMode & SDL_FULLSCREEN)
								screenMode &= !SDL_FULLSCREEN;
							else
								screenMode |= SDL_FULLSCREEN;
							SDL_SetVideoMode(SCREEN_WIDTH, SCREEN_HEIGHT, SCREEN_BPP, screenMode);
							break;
							
						case SDLK_PAUSE:
							// Toggle pause
							pause = !pause;
							break;
							
						default: break;
					}
					break;
					
				case SDL_KEYUP:
					switch (event.key.keysym.sym) {
						case SDLK_LEFT: moveLeft = false; break;
						case SDLK_RIGHT: moveRight = false; break;
						case SDLK_UP: moveUp = false; break;
						case SDLK_DOWN: moveDown = false; break;
						default: break;
					}
					break;
				
				default: break;
			}
		}
		if (!pause) {
			if (moveUp) {
				player->setFacing(Entity::NORTH); player->setMoving();
			} else if (moveDown) {
				player->setFacing(Entity::SOUTH); player->setMoving();
			} else if (moveLeft) {
				player->setFacing(Entity::WEST); player->setMoving();
			} else if (moveRight) {
				player->setFacing(Entity::EAST); player->setMoving();
			} else {
				player->setMoving(false);
			}
		}
	}
	
	Entity& Game::getPlayer() const {
		return *player;
	}
	
	std::vector<Entity*>::iterator Game::entitiesBegin() {
		return entities.begin();
	}
	
	std::vector<Entity*>::iterator Game::entitiesEnd() {
		return entities.end();	
	}
	
	bool Game::isRunning() const {
		return running;
	}
}

#include "ScriptField.h"
using namespace std;
using namespace o2d;
int main(int argc, const char* argv[]) {
	if (argc != 2) {
		std::cout << "Usage: o2d [path to project]\n";
		return -1;
	}
	
	atexit(SDL_Quit);
	
	//Start SDL
	if (SDL_Init(SDL_INIT_TIMER | SDL_INIT_VIDEO) == -1) {
		std::ostringstream s;
		s << "Could not initialize SDL: " << SDL_GetError();
		throw o2d::Exception(s.str().c_str());
	}
		
	// Start font engine
	if (TTF_Init() == -1) {
		std::ostringstream s;
		s << "Could not initialize font engine: " << TTF_GetError();
		throw o2d::Exception(s.str().c_str());
	}
	
	o2d::Game g(argv[1]);
	
	g.run();
	
	return 0;
}
