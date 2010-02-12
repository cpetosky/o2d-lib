/*
 * o2d -- a 2D game engine -- Database iterator implementation
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

#include "Database.h"
#include <iostream>

namespace o2d {
	Database::ConstListIterator::ConstListIterator(ConstDbIterator b, ConstDbIterator e) : b(b), e(e) { }
	Database::ConstListIterator::~ConstListIterator() { }
	
	Database::ConstListIterator& Database::ConstListIterator::operator =(const Database::ConstListIterator& other) {
		b = other.b;
		e = other.e;
		return *this;
	}
	
	bool Database::ConstListIterator::operator ==(const Database::ConstListIterator& other) {
		return (b == other.b);
	}
	
	bool Database::ConstListIterator::operator !=(const Database::ConstListIterator& other) {
		return (b != other.b);
	}
	
	Database::ConstListIterator& Database::ConstListIterator::operator ++() {
		if (b != e) {
			++b;
		}
		return *this;
	}
	
	Database::ConstListIterator Database::ConstListIterator::operator ++(int) {
		ConstListIterator temp(*this);
		++(*this);
		return temp;
	}
	
	const Database::Element Database::ConstListIterator::operator *() {
		return b->second;
	}
	
	const Database::Element* Database::ConstListIterator::operator ->() {
		return &(b->second);
	}
}
