/*
 * o2d -- a 2D game engine -- SDL entity blitter definition
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

#ifndef SDLENTITYBLITTER_H_
#define SDLENTITYBLITTER_H_

#include "EntityBlitter.h"
#include <SDL/SDL.h>

namespace o2d {
	/**
	 * This is the SDL version of the entity blitter.
	 */
	class SDLEntityBlitter : public EntityBlitter {
	public:
		SDLEntityBlitter(SDL_Surface* dest, SDL_Rect& view);
		virtual ~SDLEntityBlitter();
		
		virtual void blitPart(const Entity& e, int part);
		virtual void blitAll(const Entity& e); 
		
	private:
		SDL_Surface* dest;
		SDL_Rect& view;
	};
}
#endif /*SDLENTITYBLITTER_H_*/
