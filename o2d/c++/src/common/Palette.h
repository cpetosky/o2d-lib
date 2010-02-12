/*
 * o2d -- a 2D game engine -- Palette definition
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

#ifndef PALETTE_H_
#define PALETTE_H_

//#include <map>
#include <vector>
#include <libxml++/libxml++.h>
#include "Tile.h"
#include "ImageLoader.h"

namespace o2d {
	class Database;
	
	/**
	 * Palettes are an organization of tiles. Maps use palettes to determine
	 * which tiles to display where.
	 */
	class Palette {
	public:
		Palette(std::string name, ImageLoader& loader);
		Palette(xmlpp::Document* doc, ImageLoader& loader, Database* db);
		virtual ~Palette();
		
		int getWidth() const;
		int getHeight() const;
		std::string getName() const;
		
		Tile& operator [](int pos) const;
		
		void setTile(Tile* t, int pos);
		
		friend std::ostream& operator << (std::ostream& out, const Palette& p);  
		
	
	private:
		static const int WIDTH;
	
		std::vector<std::vector<Tile*> > tiles;
		int height;
		std::string name;
		
		void addRow();
		void setHeight(int height);
	};
}
#endif /*PALETTE_H_*/
