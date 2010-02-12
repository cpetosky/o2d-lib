/*
 * o2d -- a 2D game engine -- Game definition
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

#ifndef GAME_H_
#define GAME_H_

#include <SDL/SDL.h>
#include <SDL/SDL_image.h>
#include <SDL/SDL_ttf.h>
#include "Map.h"
#include "SDLTileBlitter.h"
#include "Entity.h"
#include "SDLEntityBlitter.h"
#include "SDLImageLoader.h"
#include "Database.h"
#include "ScriptEngine.h"

#include <iostream>
#include <string>
#include <sstream>
#include <fstream>
#include <list>

namespace o2d {
	/**
	 * The game class represents an instance of an actual game being run.
	 */
	class Game {
	public:
		// Screen information 
		static const int SCREEN_WIDTH;
		static const int SCREEN_HEIGHT;
		static const int SCREEN_BPP;
		
		// Movement constants
		static const int MOVE_RATE; // pixels per second
		static const int ANIMATE_RATE; // milliseconds per frame
		
		// Scrolling constants
		static const int VERTICAL_THRESHOLD;
		static const int HORIZONTAL_THRESHOLD;
	
		// Colors
		static const SDL_Color BLACK;
		static const SDL_Color WHITE;
		
		// Constructor
		Game(std::string path);
		
		// Destructor
		~Game();
		
		// Main loop
		void run();
		void renderFrame();
		void handleEvent();
		
		// Entity list
		std::vector<Entity*>::iterator entitiesBegin();
		std::vector<Entity*>::iterator entitiesEnd();
		
		// Data
		Entity& getPlayer() const;
		
		bool isRunning() const;
	
	private:
		Uint32 screenMode;
		SDL_Surface* screen;
		SDL_Rect view;
		
		// Game states
		bool running;
		bool moveLeft, moveRight, moveUp, moveDown;
		
		// Render counts
		int lastTick;
		int dist;
		int oldCount;
		int count;
		int animCount;
		int moveSum;
		
		// Text stuff
		bool showFPS;
		SDL_Surface* fpsText;
		TTF_Font* font;
		bool pause;
		bool grid;
		
		// Game resources
		std::vector<Entity*> entities;
		Map* map;
		int entityFrame;
		SDLImageLoader imageLoader;
		Database db;
		ScriptEngine scriptEngine;
		Entity* player;
		
		// Rendering tools
		SDLTileBlitter* blitter;
		SDLEntityBlitter eBlitter;
	};
}
#endif /*GAME_H_*/
