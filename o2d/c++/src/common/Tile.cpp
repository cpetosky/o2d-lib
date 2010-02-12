/*
 * o2d -- a 2D game engine -- Tile implementation
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

#include "Tile.h"
#include <iostream>

namespace o2d {
	Tile& Tile::blank() {
		static Tile blank(NULL, Tile::NONE, 0);
		return blank;	
	}
	
	Tile::Tile(Texture* texture, int passage, int priority) :
			texture(texture), passage(passage), priority(priority) {
	}
	
	Tile::~Tile()
	{
	}
	
	void Tile::setTexture(Texture* t) {
		texture = t;
	}
	
	Texture* Tile::getTexture() const {
		return texture;
	}
	
	bool Tile::isBlank() const {
		return texture == NULL;
	}	
	
	int Tile::getPassage() const {
		return passage;
	}
	
	void Tile::setPassage(int passage) {
		this->passage = passage;
	}
	
	int Tile::getPriority() const {
		return priority;
	}
	
	bool Tile::operator ==(const Tile& other) {
		return texture == other.texture;	
	}
	
	bool Tile::operator !=(const Tile& other) {
		return !(*this == other);
	}
}
