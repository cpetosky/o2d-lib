/*
 * o2d -- a 2D game engine -- SDL tile blitter definition
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

#ifndef SDLTEXTUREBLITTER_H_
#define SDLTEXTUREBLITTER_H_

#include <SDL/SDL.h>
#include "TileBlitter.h"

namespace o2d {
	/**
	 * This is the SDL version of TileBlitter.
	 */
	class SDLTileBlitter : public TileBlitter {
	public:
		SDLTileBlitter(SDL_Surface* dest);
		
		// From TextureBlitter
		void blit(Tile& tile, int dx, int dy);
		void blit(Tile& tile, const std::vector<Tile*>& nearby, int frame, int dx, int dy);
		void blitGrid(Tile& tile, const std::vector<Tile*>& nearby, int frame, int dx, int dy);
		
	private:
		SDL_Surface* dest;
	
		void addCorner(SDL_Surface* src, SDL_Rect dstRect, int dx, int dy, int sx, int sy);
		void addSide(SDL_Surface* src, SDL_Rect dstRect, int dx, int dy, int sx, int sy, SliceType st);
		void addBase(SDL_Surface* src, SDL_Rect dstRect, int sx, int sy);
		void addBend(SDL_Surface* src, SDL_Rect dstRect, int sx, int sy);
	};
}
#endif /*SDLTEXTUREBLITTER_H_*/
