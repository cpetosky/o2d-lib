/*
 * o2d -- a 2D game engine -- Tile definition
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

#ifndef TILE_H_
#define TILE_H_

#include <vector>
#include "Texture.h"

namespace o2d {
	/**
	 * A tile is a region of a map. Tile keep track of whether entities
	 * are allowed to traverse their borders as well as which order they
	 * should be rendered in.
	 */
	class Tile {
	public:
		Tile(Texture* texture, int passage = ALL, int priority = 0);
		virtual ~Tile();
		
		static const int ENTER_LEFT = 0x01;
		static const int ENTER_UP = 0x02;
		static const int ENTER_RIGHT = 0x04;
		static const int ENTER_DOWN = 0x08;
		static const int LEAVE_LEFT = 0x10;
		static const int LEAVE_UP = 0x20;
		static const int LEAVE_RIGHT = 0x40;
		static const int LEAVE_DOWN = 0x80;
		
		static const int LEFT = 0x11;
		static const int UP = 0x22;
		static const int RIGHT = 0x44;
		static const int DOWN = 0x88;
		
		static const int NONE = 0x00;
		static const int ALL = 0xFF;
		
		static Tile& blank();
		
		void setTexture(Texture* t);
		Texture* getTexture() const;
		bool isBlank() const;
		int getPassage() const;
		void setPassage(int passage);
		int getPriority() const;
		
		bool operator ==(const Tile& other);
		bool operator !=(const Tile& other);
		
	private:
		Texture* texture;
		int passage;
		int priority;
	};
}
#endif /*TILE_H_*/
