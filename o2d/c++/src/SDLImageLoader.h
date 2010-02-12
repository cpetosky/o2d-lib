/*
 * o2d -- a 2D game engine -- SDL image loader definition
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

#ifndef SDLIMAGELOADER_H_
#define SDLIMAGELOADER_H_
#include <SDL/SDL.h>
#include <SDL/SDL_image.h>
#include <boost/filesystem/path.hpp>
#include "ImageLoader.h"

namespace o2d {
	/**
	 * This is the SDL version of ImageLoader.
	 */
	class SDLImageLoader : public ImageLoader {
	public:
		SDLImageLoader(boost::filesystem::path baseDir);
		
		// Overrides pure virtual method from ImageLoader
		virtual Image* loadFromFile(std::string filename);	
	};
}
#endif /*SDLIMAGELOADER_H_*/
