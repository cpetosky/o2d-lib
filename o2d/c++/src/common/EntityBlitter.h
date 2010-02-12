/*
 * o2d -- a 2D game engine -- Entity blitter definition
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

#ifndef ENTITYBLITTER_H_
#define ENTITYBLITTER_H_

#include "Entity.h"

namespace o2d {
	/**
	 * An entity blitter blits entities to the screen. Because of the multiple
	 * renderers used in o2d, this is an abstract class. Each renderer makes
	 * use of its own subclass.
	 */
	class EntityBlitter {
	public:
		virtual ~EntityBlitter();
		
		virtual void blitPart(const Entity& e, int part) = 0;
		virtual void blitAll(const Entity& e) = 0; 
		
	protected:
		EntityBlitter();
		
		static const int PART_SIZE;
	};
}
#endif /*ENTITYBLITTER_H_*/
