/*
 * o2d -- a 2D game engine -- SDL image definition
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

#ifndef SDLIMAGE_H_
#define SDLIMAGE_H_

#include <SDL/SDL.h>
#include "Image.h"

namespace o2d {
	/**
	 * This is the SDL version of Image.
	 */
	class SDLImage : public Image {
	public:
		SDLImage(SDL_Surface* data);
		virtual ~SDLImage();
		
		// From Image
		void* getData();
		int getWidth();
		int getHeight();
	
	private:
		SDL_Surface* data;
	};
}
#endif /*SDLIMAGE_H_*/
