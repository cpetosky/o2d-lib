/*
 * o2d -- a 2D game engine -- GTK image implementation
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

#include "GTKImage.h"

namespace o2d {
	GTKImage::GTKImage(Glib::RefPtr<Gdk::Pixbuf> data) : Image("GTK"), data(data) {
	}
	
	void* GTKImage::getData() {
		void* x = &data;
		return x;
	}
	
	int GTKImage::getWidth() {
		return data->get_width();
	}
	
	int GTKImage::getHeight() {
		return data->get_height();
	}
}
