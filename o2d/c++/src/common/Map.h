/*
 * o2d -- a 2D game engine -- Map definition
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

#ifndef O2D_MAP_H_
#define O2D_MAP_H_

#include <string>
#include <vector>
#include <iostream>
#include <libxml++/libxml++.h>
#include "Tile.h"
#include "Texture.h"
#include "TileBlitter.h"
#include "Palette.h"
#include "Entity.h"

namespace o2d {
	// Forward declaration
	class Database;
	
	/**
	 * The map represents any environment in which an entity can interact.
	 * Maps keep track of their tiles. They also manage scripting hooks for
	 * environmental scripts.
	 */
	class Map {
	public:
		Map(Palette& palette, int width = 0, int height = 0, std::string name = "");
		Map(xmlpp::Document* doc, ImageLoader& loader, Database* db);
		
		virtual ~Map();
		static const int LAYERS;
		static const int PRIORITIES;
		
		int getWidth() const;
		int getHeight() const;
		int getPixelWidth() const;
		int getPixelHeight() const;
		
		std::string getName() const;
		void setName(std::string name);
		double getZoom() const;
		void setZoom(double zoom);
		void setTile(int i, int j, int layer, int palRef);
		Tile& getTile(int i, int j, int layer) const;
		
		void addEntity(Entity* e);
		std::vector<Entity*> getEntities();
		
		int getPassage(int i, int j) const;
		
		void nextFrame();
		
		void renderPriority(TileBlitter* blitter, int vx, int vy, int vw, int vh, int priority, bool grid = false);
		
		void renderLayer(TileBlitter* blitter, int vx, int vy, int vw, int vh, int layer);
		void renderLayers(TileBlitter* blitter, int vx, int vy, int vw, int vh);
		
		friend std::ostream& operator << (std::ostream& out, const Map& map);  
		static Map* load(const std::string& filename, ImageLoader& loader, Database* db);
	 
	private:
		// Map data
		Palette* palette;
		int width;
		int height;
		double zoom;
		std::string name;
		
		std::vector<Entity*> entities;
	
		std::vector<std::vector<std::vector<int> > > palRefs;
		
		void initPalRefs();
		
		std::vector<Tile*> getNearbyTiles(int i, int j, int layer);
		
		int frame;
		
	};
}
#endif /*O2D_MAP_H_*/
