/*
 * o2d -- a 2D game engine -- Image loader definition
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

#ifndef IMAGELOADER_H_
#define IMAGELOADER_H_
#include <string>
#include <map>
#include <boost/filesystem/path.hpp>
#include "Image.h"

namespace o2d {
	/**
	 * An image loader is used whenever images need to be read from disk.
	 * Because o2d uses various renderers, this class is abstract and most
	 * real functionality comes from its subclasses.
	 */
	class ImageLoader {
	public:
		virtual ~ImageLoader();
		
		virtual Image* loadFromFile(std::string filename) = 0;
		
		void setBaseDirectory(std::string baseDir);
		
	protected:
		ImageLoader(boost::filesystem::path baseDir);
		std::map<std::string, Image*> images;
		boost::filesystem::path baseDir;
	};
}
#endif /*IMAGELOADER_H_*/
