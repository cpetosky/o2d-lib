/*
 * o2d -- a 2D game engine -- SDL tile blitter implementation
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

#include "SDLTileBlitter.h"

namespace o2d {
	SDLTileBlitter::SDLTileBlitter(SDL_Surface* dest) : TileBlitter(), dest(dest) { 
	}
	
	void SDLTileBlitter::blit(Tile& tile, int dx, int dy) {
		SDL_Surface* src = reinterpret_cast<SDL_Surface*>(tile.getTexture()->getImage()->getData());
		SDL_Rect dstRect;
		dstRect.x = dx;
		dstRect.y = dy;
		dstRect.w = Texture::TILESIZE;
		dstRect.h = Texture::TILESIZE;
		SDL_Rect srcRect;
		srcRect.x = 0;
		srcRect.y = 0;
		srcRect.w = srcRect.h = Texture::TILESIZE;
		SDL_BlitSurface(src, &srcRect, dest, &dstRect);
	}
	
	void SDLTileBlitter::blitGrid(Tile& tile, const std::vector<Tile*>& nearby, int frame,
			int dx, int dy) {
		blit(tile, nearby, frame, dx, dy);
		SDL_Rect dstRect;
		dstRect.x = dx;
		dstRect.y = dy;
		dstRect.w = Texture::TILESIZE;
		dstRect.h = 1;
		Uint32 black = SDL_MapRGBA(dest->format, 0x00, 0x00, 0x00, 0xff);
		SDL_FillRect(dest, &dstRect, black);
		dstRect.x = dx;
		dstRect.y = dy;
		dstRect.w = 1;
		dstRect.h = Texture::TILESIZE;
		SDL_FillRect(dest, &dstRect, black);
		dstRect.x = dx + Texture::TILESIZE - 1;
		dstRect.y = dy;
		dstRect.w = 1;
		dstRect.h = Texture::TILESIZE;
		SDL_FillRect(dest, &dstRect, black);
		dstRect.x = dx;
		dstRect.y = dy + Texture::TILESIZE - 1;
		dstRect.w = Texture::TILESIZE;
		dstRect.h = 1;
		SDL_FillRect(dest, &dstRect, black);

	}
	
	void SDLTileBlitter::blit(Tile& tile, const std::vector<Tile*>& nearby, int frame,
			int dx, int dy) {
		Texture* tex = tile.getTexture();
		if (tex == NULL)
			return;
		SDL_Surface* src = reinterpret_cast<SDL_Surface*>(tex->getImage()->getData());
		SDL_Rect dstRect;
		dstRect.x = dx;
		dstRect.y = dy;
		dstRect.w = Texture::TILESIZE;
		dstRect.h = Texture::TILESIZE;
		if (src->h > Texture::TILESIZE) { // Blit as AutoTexture
			if (frame >= tex->getFrames())
				frame = 0;
			int offset = frame * Texture::TILESIZE * 3;
			
			// Check borders, set border flags
			std::bitset<20> actions = getAutoTextureActions(tile, nearby);
			
			// Check cases
			if (actions[BASE_EMPTY]) {
				addBase(src, dstRect, offset, 0);
			}
	
			if (actions[BASE_CENTER]) {
				addBase(src, dstRect, offset + Texture::TILESIZE, 2 * Texture::TILESIZE);
			}
			
			if (actions[BASE_NW]) {
				addBase(src, dstRect, offset, Texture::TILESIZE);
			}
			
			if (actions[BASE_N]) {
				addBase(src, dstRect, offset + Texture::TILESIZE, Texture::TILESIZE);		
			}
			
			if (actions[BASE_NE]) {
				addBase(src, dstRect, offset + Texture::TILESIZE + Texture::TILESIZE, Texture::TILESIZE);
			}
			
			if (actions[BASE_W]) {
				addBase(src, dstRect, offset, 2 * Texture::TILESIZE);			
			}
			
			if (actions[BASE_E]) {
				addBase(src, dstRect, offset + Texture::TILESIZE + Texture::TILESIZE, Texture::TILESIZE + Texture::TILESIZE);
			}
			
			if (actions[BASE_SW]) {
				addBase(src, dstRect, offset, Texture::TILESIZE + Texture::TILESIZE + Texture::TILESIZE);
			}
			
			if (actions[BASE_S]) {
				addBase(src, dstRect, offset + Texture::TILESIZE, Texture::TILESIZE + Texture::TILESIZE + Texture::TILESIZE);			
			}
			
			if (actions[BASE_SE]) {
				addBase(src, dstRect, offset + Texture::TILESIZE + Texture::TILESIZE, Texture::TILESIZE + Texture::TILESIZE + Texture::TILESIZE);
			}
			
			if (actions[SIDE_W]) {
				addSide(src, dstRect, 0, 0, offset, Texture::TILESIZE * 2, VERTICAL);
			}
			
			if (actions[SIDE_N]) {
				addSide(src, dstRect, 0, 0, offset + Texture::TILESIZE, Texture::TILESIZE, HORIZONTAL);
			}
			
			if (actions[SIDE_E]) {
				addSide(src, dstRect, Texture::TILESIZE / 2, 0,
					offset + 2 * Texture::TILESIZE + Texture::TILESIZE / 2, 2 * Texture::TILESIZE, VERTICAL);
			}
			
			if (actions[SIDE_S]) {
				addSide(src, dstRect, 0, Texture::TILESIZE / 2,
						offset + Texture::TILESIZE, 3 * Texture::TILESIZE + Texture::TILESIZE / 2, HORIZONTAL);
			}
			
			if (actions[BEND_NW]) {
				addBend(src, dstRect, offset, Texture::TILESIZE);
			}
			
			if (actions[BEND_SE]) {
				dstRect.x += Texture::TILESIZE / 2;
				dstRect.y += Texture::TILESIZE / 2;
				addBend(src, dstRect, offset + Texture::TILESIZE * 2 + Texture::TILESIZE / 2, Texture::TILESIZE * 3 + Texture::TILESIZE / 2);
			}
					
			if (actions[CORNER_NW]) {
				addCorner(src, dstRect, 0, 0, offset + Texture::TILESIZE * 2, 0);
			}
			
			if (actions[CORNER_NE]) {
				addCorner(src, dstRect, Texture::TILESIZE / 2, 0, offset + Texture::TILESIZE * 2 + Texture::TILESIZE / 2, 0);			
			}
			
			if (actions[CORNER_SW]) {
				addCorner(src, dstRect, 0, Texture::TILESIZE / 2, offset + Texture::TILESIZE * 2, Texture::TILESIZE / 2);	
			}
			
			if (actions[CORNER_SE]) {
				addCorner(src, dstRect, Texture::TILESIZE / 2, Texture::TILESIZE / 2, offset + Texture::TILESIZE * 2 + Texture::TILESIZE / 2, Texture::TILESIZE / 2);			
			}
			
		} else { // Blit as PlainTexture
			SDL_Rect srcRect;
			srcRect.x = (frame < tex->getFrames()) ? (frame * Texture::TILESIZE) : 0;
			srcRect.y = 0;
			srcRect.w = srcRect.h = Texture::TILESIZE;
			
			SDL_BlitSurface(src, &srcRect, dest, &dstRect);		
		}
	}	
		
	void SDLTileBlitter::addSide(SDL_Surface* src, SDL_Rect dstRect,	int dx, int dy, int sx, int sy, SliceType st) {
		SDL_Rect srcRect;
		srcRect.x = sx;
		srcRect.y = sy;
		dstRect.x += dx;
		dstRect.y += dy;
	
		switch (st) {
		case HORIZONTAL:
			srcRect.w = Texture::TILESIZE;
			srcRect.h = Texture::TILESIZE / 2;
			SDL_BlitSurface(src, &srcRect, dest, &dstRect);
			break;
		case VERTICAL:
			srcRect.w = Texture::TILESIZE / 2;
			srcRect.h = Texture::TILESIZE;
			SDL_BlitSurface(src, &srcRect, dest, &dstRect);
			break;
		}
	}
	
	void SDLTileBlitter::addCorner(SDL_Surface* src, SDL_Rect dstRect, int dx, int dy, int sx, int sy) {
		SDL_Rect srcRect;
		srcRect.x = sx;
		srcRect.y = sy;
		srcRect.w = srcRect.h = Texture::TILESIZE / 2;
		dstRect.x += dx;
		dstRect.y += dy;
		SDL_BlitSurface(src, &srcRect, dest, &dstRect);
	}
	
	void SDLTileBlitter::addBase(SDL_Surface* src, SDL_Rect dstRect, int sx, int sy) {
		SDL_Rect srcRect;
		srcRect.x = sx;
		srcRect.y = sy;
		srcRect.w = srcRect.h = Texture::TILESIZE;
		SDL_BlitSurface(src, &srcRect, dest, &dstRect);
	}
	
	void SDLTileBlitter::addBend(SDL_Surface* src, SDL_Rect dstRect, int sx, int sy) {
		SDL_Rect srcRect;
		srcRect.x = sx;
		srcRect.y = sy;
		srcRect.w = srcRect.h = Texture::TILESIZE / 2;
		SDL_BlitSurface(src, &srcRect, dest, &dstRect);	
	}
}
