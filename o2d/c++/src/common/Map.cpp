/*
 * o2d -- a 2D game engine -- Map implementation
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

#include "Map.h"
#include <iostream>
#include "Database.h"

namespace o2d {
	const int Map::LAYERS = 3;
	const int Map::PRIORITIES = 6;
	
	/**
	 * Create a new map based on given parameters.
	 */
	Map::Map(Palette& palette, int width, int height, std::string name) :
				palette(&palette), width(width), height(height), name(name) {
		zoom = 1.0;
		frame = 0;
		initPalRefs();
	}

	Map::Map(xmlpp::Document* doc, ImageLoader& loader, Database* db) : zoom(1.0), frame(0) {
		const xmlpp::Element* root = dynamic_cast<const xmlpp::Element*>(doc->get_root_node());
		
		name = dynamic_cast<const xmlpp::Element*>(root->find("name")[0])->get_child_text()->get_content();
		width = atoi(dynamic_cast<const xmlpp::Element*>(root->find("width")[0])->get_child_text()->get_content().c_str());
		height = atoi(dynamic_cast<const xmlpp::Element*>(root->find("height")[0])->get_child_text()->get_content().c_str());
		std::string palName = dynamic_cast<const xmlpp::Element*>(root->find("palette")[0])->get_child_text()->get_content();
		palette = &db->getPalette(palName);
		
		initPalRefs();

		std::vector<xmlpp::Node*> tiles = root->find("tile");
		
		for (unsigned int i = 0; i < tiles.size(); ++i) {
			int x = atoi(dynamic_cast<const xmlpp::Element*>(tiles[i]->find("x")[0])->get_child_text()->get_content().c_str());
			int y = atoi(dynamic_cast<const xmlpp::Element*>(tiles[i]->find("y")[0])->get_child_text()->get_content().c_str());
			
			std::vector<xmlpp::Node*> layers = tiles[i]->find("layer");
			for (unsigned int j = 0; j < layers.size(); ++j) {
				int layer = atoi(dynamic_cast<const xmlpp::Element*>(layers[j])->get_attribute("num")->get_value().c_str());
				int palRef = atoi(dynamic_cast<const xmlpp::Element*>(layers[j])->get_child_text()->get_content().c_str());
	
				palRefs[layer][x][y] = palRef;
			}
			
			std::vector<xmlpp::Node*> entities = tiles[i]->find("entity");
			for (unsigned int j = 0; j < entities.size(); ++j) {
				std::string entityName =
					dynamic_cast<const xmlpp::Element*>(entities[j])->get_child_text()->get_content();
				addEntity(db->getEntityInstance(entityName, *this, x, y));
			}
		}
	}

	Map::~Map() { }

	void Map::initPalRefs() {
		palRefs.resize(LAYERS);
		for (int layer = 0; layer < LAYERS; ++layer) {
			palRefs[layer].resize(width);
			for (int i = 0; i < width; ++i) {
				palRefs[layer][i].resize(height);
				for (int j = 0; j < height; ++j) {
					if (layer == 0) { // Start bottom layer full of default tile on palette
						palRefs[layer][i][j] = 0;
					} else { // Fill middle and top layers with empty space
						palRefs[layer][i][j] = -1;
					}					
				}
			}
		}		
	}
		
	/**
	 * Returns the map's width (in tiles).
	 */
	int Map::getWidth() const {
		return width;
	}
	
	/**
	 * Returns the map's height (in tiles).
	 */
	int Map::getHeight() const {
		return height;	
	}
	
	/**
	 * Returns the map's width (in pixels at the default zoom).
	 */
	int Map::getPixelWidth() const {
		return Texture::TILESIZE * width;	
	}
	
	/**
	 * Returns the map's height (in pixels at the default zoom).
	 */
	int Map::getPixelHeight() const {
		return Texture::TILESIZE * height;
	}
	
	/**
	 * Returns the map's name.
	 */
	std::string Map::getName() const {
		return name;
	}
	
	/**
	 * Changes the map's name.
	 */
	void Map::setName(std::string name) {
		this->name = name;
	}
	
	/**
	 * Returns the map's zoom. Because zoom is currently unimplemented, this always returns 1.
	 */
	double Map::getZoom() const {
		return zoom;
	}
	
	/**
	 * Sets the map zoom. This field is currently ignored.
	 */
	void Map::setZoom(double zoom) {
		this->zoom = zoom;
	}
	
	/**
	 * Alters a palette reference at the given location and layer.
	 */
	void Map::setTile(int i, int j, int layer, int palRef) {
		palRefs[layer][i][j] = palRef;
	}
	
	/**
	 * Returns a reference to the tile defined by the palette reference at
	 * the given location and layer. Altering this reference will change not
	 * only the given location, but all other locations that reference the
	 * same tile (even across maps!). Thus, this method is dangerous.
	 * 
	 * TODO: Remove or fix this method to remove widespread side effects.
	 */
	Tile& Map::getTile(int i, int j, int layer) const {
		return (*palette)[palRefs[layer][i][j]];
	}
	
	/**
	 * Return the passage value of the logical tile at this position.
	 */
	int Map::getPassage(int i, int j) const {
		// Prevent passage if tile doesn't exist.
		if (i < 0 || j < 0 || i >= width || j >= height)
			return Tile::NONE;
		
		// Look for tile and return passage of highest tile on lowest priority.
		bool first = true;
		int passage;
		int ref = -1;
		for (int layer = 0; layer < LAYERS; ++layer) {
			if (palRefs[layer][i][j] != -1) {
				if (first) {
					passage = (*palette)[palRefs[layer][i][j]].getPassage();
					first = false;
				} else {
					if ((*palette)[ref].getPriority() == (*palette)[palRefs[layer][i][j]].getPriority())
						passage = (*palette)[palRefs[layer][i][j]].getPassage();
					else
						passage &= (*palette)[palRefs[layer][i][j]].getPassage(); 
				}
				ref = palRefs[layer][i][j];
			}
		}
	
		if (!first)
			return passage;
				
		// If no tile exists at the position, prevent passage.
		return Tile::NONE;
	}
	
	/**
	 * Advances the map to the next frame of its animation loop.
	 */
	void Map::nextFrame() {
		frame = (frame + 1) % Texture::FRAMES;	
	}
	
	/**
	 * Renders the map incrementally. This is used by the game loop to render
	 * tiles lower on the priority-list first.
	 * 
	 * TODO: Optimize prioritization loops, as this currently runs at O(n^2).
	 */
	void Map::renderPriority(TileBlitter* blitter, int vx, int vy, int vw, int vh, int priority, bool grid) {
		int xStart = -(vx % Texture::TILESIZE);
		int yStart = -(vy % Texture::TILESIZE);
		int iTileStart = vx / Texture::TILESIZE;
		int jTileStart = vy / Texture::TILESIZE;
		
		for (int layer = 0; layer < LAYERS; ++layer) {
			int i = iTileStart;
			for (int x = xStart; x < vx + vw && i < width; x += Texture::TILESIZE) {
				int j = jTileStart;
				for (int y = yStart; y < vy + vh && j < height; y += Texture::TILESIZE) {
					if (palRefs[layer][i][j] >= 0) {
						Tile& tile = (*palette)[palRefs[layer][i][j]];
						if (tile.getPriority() == priority) {
							if (grid)
								blitter->blitGrid(tile, getNearbyTiles(i, j, layer), frame, x, y);
							else
								blitter->blit(tile, getNearbyTiles(i, j, layer), frame, x, y);
						}
					}
					++j;
				}
				++i;
			}
		}
	}
	
	/**
	 * Render all logical layers of the map, from bottom to top.
	 * This is used by the editor.
	 */
	void Map::renderLayers(TileBlitter* blitter, int vx, int vy, int vw, int vh) {
		for (int layer = 0; layer < LAYERS; ++layer) {
			renderLayer(blitter, vx, vy, vw, vh, layer);
		}	
	}
	
	/**
	 * Render a single logical layer of the map.
	 */
	void Map::renderLayer(TileBlitter* blitter, int vx, int vy, int vw, int vh, int layer) {
		int xStart = -(vx % Texture::TILESIZE);
		int yStart = -(vy % Texture::TILESIZE);
		int iTileStart = vx / Texture::TILESIZE;
		int jTileStart = vy / Texture::TILESIZE;
		
		int i = iTileStart;
		for (int x = xStart; x < vx + vw && i < width; x += Texture::TILESIZE) {
			int j = jTileStart;
			for (int y = yStart; y < vy + vh && j < height; y += Texture::TILESIZE) {
				if (palRefs[layer][i][j] >= 0) {
					Tile& tile = (*palette)[palRefs[layer][i][j]];
					blitter->blit(tile, getNearbyTiles(i, j, layer), frame, x, y);
				}
				++j;
			}
			++i;
		}
	}
	
	/**
	 * Return pointers to all tiles near the given tile, arranged in a
	 * 3x3 vector.
	 */
	std::vector<Tile*> Map::getNearbyTiles(int i, int j, int layer) {
		std::vector<Tile*> nearby;
		for (int y = j - 1; y <= j + 1; ++y)
			for (int x = i - 1; x <= i + 1; ++x)
				if (x >= 0 && y >= 0 && x < width && y < height)
					nearby.push_back(&(*palette)[palRefs[layer][x][y]]);
				else
					nearby.push_back(&(*palette)[palRefs[layer][i][j]]);
		return nearby;
	}
	
	void Map::addEntity(Entity* e) {
		entities.push_back(e);	
	}
	
	std::vector<Entity*> Map::getEntities() {
		return entities;
	}
	
	/**
	 * Write out the map, in XML format, to the stream.
	 */
	std::ostream& operator <<(std::ostream& out, const Map& map) {
		out << "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
			<< "<map>\n"
			<< "\t<name>" << map.name << "</name>\n"
			<< "\t<width>" << map.width << "</width>\n"
			<< "\t<height>" << map.height << "</height>\n"
			<< "\t<palette>" << map.palette->getName() << "</palette>\n";
			
		for (int i = 0; i < map.width; ++i) {
			for (int j = 0; j < map.height; ++j) {
				out << "\t<tile>\n"
					<< "\t\t<x>" << i << "</x>\n"
					<< "\t\t<y>" << j << "</y>\n";
	
				for (int layer = 0; layer < Map::LAYERS; ++layer) {
					if (map.palRefs[layer][i][j] >= 0)
						out << "\t\t<layer num=\"" << layer << "\">" << map.palRefs[layer][i][j] << "</layer>\n";
				}
				out << "\t</tile>\n";	
			}
		}
		
		out << "</map>\n";
		out.flush();
		return out;
	}	
}
