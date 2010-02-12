/*
 * o2d -- a 2D game engine -- SDL image loader implementation
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

#include "SDLImageLoader.h"
#include "Image.h"
#include "SDLImage.h"
#include <iostream>

namespace o2d {
	SDLImageLoader::SDLImageLoader(boost::filesystem::path baseDir) : ImageLoader(baseDir) {
	}
	
	Image* SDLImageLoader::loadFromFile(std::string filename) {
		if (images.find(filename) != images.end())
			return images[filename];
	
		SDL_Surface* loadedImage = NULL;
		SDL_Surface* optimizedImage = NULL;
		loadedImage = IMG_Load((baseDir / filename).string().c_str());
		if (loadedImage == NULL) {
			throw IMG_GetError();
		} else {
			optimizedImage = SDL_DisplayFormatAlpha(loadedImage);
			if (optimizedImage == NULL)
				throw IMG_GetError();
			SDL_FreeSurface(loadedImage);
		}
		Image* image = new SDLImage(optimizedImage);
	
		images[filename] = image;
		return image;	
	}	
}
