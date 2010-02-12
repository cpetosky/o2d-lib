/*
 * o2d -- a 2D game engine -- Image definition
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

#ifndef IMAGE_H_
#define IMAGE_H_
#include <string>

namespace o2d {
	/**
	 * Images represent any sort of image data. Since o2d uses various
	 * renderers, this class is abstract, and most actual functionality
	 * comes from subclasses.
	 */
	class Image {
	public:
		virtual ~Image();
		
		virtual void* getData() = 0;
		
		virtual int getWidth() = 0;
		virtual int getHeight() = 0;
		
	protected:
		Image(std::string type);
		std::string type;
	};
}
#endif /*IMAGE_H_*/
