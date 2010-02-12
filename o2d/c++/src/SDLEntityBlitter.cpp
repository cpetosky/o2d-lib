/*
 * o2d -- a 2D game engine -- SDL entity blitter implementation
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

#include "SDLEntityBlitter.h"
#include <iostream>

namespace o2d {
	SDLEntityBlitter::SDLEntityBlitter(SDL_Surface* dest, SDL_Rect& view) :
			dest(dest), view(view) {
			
	}
	
	SDLEntityBlitter::~SDLEntityBlitter() { }

	void SDLEntityBlitter::blitPart(const Entity& e, int part) {
//		std::cerr << "Blitting entity!\n"
//			<< "\tName: " << e.getName()
//			<< "\n\tPart: " << part
//			<< std::endl;
		int offset1 = e.getY() % PART_SIZE;
		int offset2 = PART_SIZE - offset1;
		
		int maxParts = 0;
	
		int h = e.getHeight();
		
		if (offset1 > 0) {
			maxParts++;
			h -= offset2;
		}
		maxParts += h / PART_SIZE;
		if (h % PART_SIZE > 0)
			maxParts++;
		
		// See if part exists
		if (part >= maxParts)
			return;
			
		SDL_Rect srcRect;
		srcRect.x = e.getFrame() * e.getWidth();
		srcRect.w = e.getWidth();
		srcRect.y = (e.getFacing() * e.getHeight());
	
		int yPart = (PART_SIZE * (maxParts - part - 1)) - offset1;
		
		if (yPart < 0)
			yPart = 0;
		
		srcRect.y += yPart;
		
		if (part == maxParts - 1) {
			srcRect.h = offset2;
		} else if (part == 0) {
			srcRect.h = (e.getHeight() - offset2) % PART_SIZE;
			if (srcRect.h == 0)
				srcRect.h = PART_SIZE;	
		} else {
			srcRect.h = PART_SIZE;
		}
		
		SDL_Rect dstRect;
		dstRect.x = e.getX() - view.x;
		dstRect.y = e.getY() - view.y + yPart;
		SDL_BlitSurface(static_cast<SDL_Surface*>(e.getImage()->getData()), &srcRect, dest, &dstRect);
	}
	
	void SDLEntityBlitter::blitAll(const Entity& e) {
		SDL_Rect srcRect;
		srcRect.x = e.getFrame() * e.getWidth();
		srcRect.y = e.getFacing() * e.getHeight();
		srcRect.w = e.getWidth();
		srcRect.h = e.getHeight();
		
		SDL_Rect dstRect;
		dstRect.x = e.getX() - view.x;
		dstRect.y = e.getY() - view.y;
		SDL_BlitSurface(static_cast<SDL_Surface*>(e.getImage()->getData()), &srcRect, dest, &dstRect);
	}
}
