/*
 * o2d -- a 2D game engine -- Texture implementation
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

#include "Texture.h"
#include <iostream>

namespace o2d {
	std::map<std::string, Texture*> Texture::textures;
	const int Texture::FRAMES = 4;
	const int Texture::TILESIZE = 32;
	Texture::Texture(std::string name, Image* image) : name(name), image(image) {
		if (image->getHeight() > TILESIZE) { // Auto Texture
			frames = image->getWidth() / (TILESIZE * 3);
		} else { // Simple Texture
			frames = image->getWidth() / TILESIZE;
		}
	}
	
	Texture::~Texture() {
	}
	
	std::string Texture::getName() const {
		return name;	
	}
	
	Image* Texture::getImage() const {
		return image;
	}
	
	int Texture::getFrames() const {
		return frames;
	}
	
	bool Texture::isAnimated() const {
		return frames > 1;
	}
	
	Texture* Texture::create(ImageLoader& loader, std::string texName) {
		if (textures.find(texName) != textures.end())
			return textures[texName];
		Image* image = loader.loadFromFile("gfx/textures/" + texName);
		if (image == NULL) {
			std::cerr << "\tRETURNING NULL FOR A TEXTURE!\n";
			return NULL;
		}
		Texture* tex = new Texture(texName, image);
		
		textures[texName] = tex;
		return tex;
			
	}
}
