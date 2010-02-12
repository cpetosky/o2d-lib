/*
 * o2d -- a 2D game engine -- Texture definition
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

#ifndef TEXTURE_H_
#define TEXTURE_H_

#include <string>
#include <map>
#include <vector>
#include "Image.h"
#include "ImageLoader.h"

namespace o2d {
	/**
	 * A texture is the image used to render a tile. Different tiles
	 * can share textures.
	 * 
	 * The texture class also contains static methods to ease the creation
	 * of textures. These should be removed and put into a separate TextureLoader
	 * class.
	 */
	class Texture {
	public:
		static const int FRAMES;
		static const int TILESIZE;
	
		static Texture* create(ImageLoader& loader, std::string texName);
		static std::map<std::string, Texture*> textures;
	
		
		std::string getName() const;
		Image* getImage() const;
		int getFrames() const;
		bool isAnimated() const;
	
		virtual ~Texture();
		
	protected:
		Texture(std::string name, Image* image);
		std::string name;
		int frames;
		Image* image;
	};
}
#endif /*TEXTURE_H_*/
