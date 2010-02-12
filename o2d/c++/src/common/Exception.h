/*
 * o2d -- a 2D game engine -- Exception definition
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

#ifndef EXCEPTION_H_
#define EXCEPTION_H_

#include <exception>

namespace o2d {
	/**
	 * This merely provides a custom exception type for o2d exceptions.
	 */
	class Exception : public std::exception {
	public:
		Exception(const char* message);
		virtual ~Exception() throw();
		
		const char* what() const throw();
	private:
		const char* message;
	};
}
#endif /*EXCEPTION_H_*/
