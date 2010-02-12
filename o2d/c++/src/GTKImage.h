/*
 * o2d -- a 2D game engine -- GTK image definition
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

#ifndef GTKIMAGE_H_
#define GTKIMAGE_H_

#include <glibmm/refptr.h>
#include <gdkmm/pixbuf.h>
#include "Image.h"

namespace o2d {
	/**
	 * This is the GTK version of Image.
	 */
	class GTKImage : public Image {
	public:
		GTKImage(Glib::RefPtr<Gdk::Pixbuf> data);
		
		// From Image
		void* getData();
		int getWidth();
		int getHeight();
	
	private:
		Glib::RefPtr<Gdk::Pixbuf> data;
	};
}
#endif /*GTKIMAGE_H_*/
