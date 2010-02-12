/*
 * o2d -- a 2D game engine -- Palette implementation
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

#include "Palette.h"
#include "Texture.h"
#include <iostream> 

namespace o2d {
	const int Palette::WIDTH = 8;
	
	Palette::Palette(std::string name, ImageLoader& loader) :	tiles(WIDTH), height(1), name(name) {
		addRow();	
	}
	
	Palette::Palette(xmlpp::Document* doc, ImageLoader& loader, Database* db) : tiles(WIDTH), height(0) {
		const xmlpp::Element* root = dynamic_cast<const xmlpp::Element*>(doc->get_root_node());
		setHeight(atoi(dynamic_cast<const xmlpp::Element*>(root->find("height")[0])->get_child_text()->get_content().c_str()));
		name = dynamic_cast<const xmlpp::Element*>(root->find("name")[0])->get_child_text()->get_content();
		std::vector<xmlpp::Node*> chipNodes = root->find("tile");
		for (unsigned int i = 0; i < chipNodes.size(); ++i) {
			const xmlpp::Element* position = dynamic_cast<const xmlpp::Element*>(chipNodes[i]->find("position")[0]);
			int x = atoi(dynamic_cast<const xmlpp::Element*>(position->find("x")[0])->get_child_text()->get_content().c_str());
			int y = atoi(dynamic_cast<const xmlpp::Element*>(position->find("y")[0])->get_child_text()->get_content().c_str());
	
			std::string name = dynamic_cast<const xmlpp::Element*>(chipNodes[i]->find("texture")[0])->get_child_text()->get_content();
			int priority = atoi(dynamic_cast<const xmlpp::Element*>(chipNodes[i]->find("priority")[0])->get_child_text()->get_content().c_str());
	
			const xmlpp::Element* passageNode = dynamic_cast<const xmlpp::Element*>(chipNodes[i]->find("passage")[0]);
			int passage = Tile::NONE;
			if (!passageNode->find("north").empty())
				passage |= Tile::UP;
			if (!passageNode->find("east").empty())
				passage |= Tile::RIGHT;
			if (!passageNode->find("south").empty())
				passage |= Tile::DOWN;
			if (!passageNode->find("west").empty())
				passage |= Tile::LEFT;
			
			tiles[x][y] = new Tile(Texture::create(loader, name), passage, priority);
		}
	}
	
	Palette::~Palette() {
	}
	
	int Palette::getWidth() const {
		return WIDTH;
	}
	
	int Palette::getHeight() const {
		return height;
	}
	
	std::string Palette::getName() const {
		return name;
	}
	
	void Palette::setTile(Tile* t, int pos) {
		if (pos < 0)
			return;
		int x = pos % getWidth();
		int y = pos / getWidth();
		tiles[x][y] = t;
		
		if (y == height)
			addRow();			
	}
	
	Tile& Palette::operator [](int pos) const {
		if (pos < 0)
			return Tile::blank();
		int x = pos % getWidth();
		int y = pos / getWidth();
		return tiles[x][y] != NULL ? *tiles[x][y] : Tile::blank(); 
	}
	
	std::ostream& operator << (std::ostream& out, const Palette& p) {
		out << "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
			<< "<palette>\n"
			<< "\t<name>" << p.name << "</name>\n"
			<< "\t<height>" << p.height << "</height>\n";
			
		for (int i = 0; i < Palette::WIDTH; ++i) {
			for (int j = 0; j < p.height; ++j) {
				if (p.tiles[i][j] != NULL) {
					out << "\t<tile>\n"
						<< "\t\t<position><x>" << i << "</x><y>" << j << "</y></position>\n"
						<< "\t\t<texture>" << p.tiles[i][j]->getTexture()->getName() << "</texture>\n"
						<< "\t\t<priority>" << p.tiles[i][j]->getPriority() << "</priority>\n"
						<< "\t\t<passage>";
					
					if (Tile::UP & p.tiles[i][j]->getPassage())
						out << "<north/>";
					if (Tile::RIGHT & p.tiles[i][j]->getPassage())
						out << "<east/>";
					if (Tile::DOWN & p.tiles[i][j]->getPassage())
						out << "<south/>";
					if (Tile::LEFT & p.tiles[i][j]->getPassage())
						out << "<west/>";
					
					out << "</passage>\n"
						<< "\t</tile>\n";
				}
			}
		}
		out << "</palette>\n";
		out.flush();
		return out;
	}
	
	void Palette::setHeight(int newHeight) {
		for (int i = 0; i < WIDTH; ++i)
			tiles[i].resize(newHeight);
			
		height = newHeight;
	}
	void Palette::addRow() {
		for (int i = 0; i < WIDTH; ++i)
			tiles[i].push_back(NULL);
			
		height = tiles[0].size();
	}
}
