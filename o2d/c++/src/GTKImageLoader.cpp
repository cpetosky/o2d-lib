/*
 * o2d -- a 2D game engine -- GTK image loader implementation
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

#include "GTKImageLoader.h"
#include "GTKImage.h"

namespace o2d {
	GTKImageLoader::GTKImageLoader(boost::filesystem::path baseDir) : ImageLoader(baseDir) {
		
	}
	
	Image* GTKImageLoader::loadFromFile(std::string filename) {
		if (images.find(filename) != images.end())
			return images[filename];
			
		Glib::RefPtr<Gdk::Pixbuf> pixbuf;
		pixbuf = Gdk::Pixbuf::create_from_file((baseDir / filename).string());
		
		if (!pixbuf)
			return NULL;
	
		Image* image = new GTKImage(pixbuf);
	
		images[filename] = image;
		return image;	
	}	
}
