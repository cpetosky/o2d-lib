/*
 * o2d project -- a 2D game engine -- Map viewer implementation
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

#include "MapViewer.h"

namespace o2d {
	MapViewer::MapViewer(Map& map) : layer(BOTTOM), map(map) {
		blitter = new GTKTileBlitter(this);
		set_size_request(map.getWidth() * Texture::TILESIZE, map.getHeight() * Texture::TILESIZE);
		add_events(Gdk::POINTER_MOTION_MASK | Gdk::BUTTON_PRESS_MASK);	
	}
	
	MapViewer::~MapViewer() { }
	
	Map& MapViewer::getMap() {
		return map;
	}
	
	MapViewer::Layer MapViewer::getLayer() {
		return layer;
	}
	
	void MapViewer::setLayer(MapViewer::Layer l) {
		layer = l;
	}
	
	void MapViewer::highlight() {
		Glib::RefPtr<Gdk::Window> d = get_window();
		Glib::RefPtr<Gdk::GC> black = get_style()->get_black_gc();
		Glib::RefPtr<Gdk::GC> white = get_style()->get_white_gc();
		
		if (activeTiles.size() == 1) {
			Gdk::Point tile = *activeTiles.begin(); 
			int selX = tile.get_x();
			int selY = tile.get_y();
			d->draw_rectangle(black, false, selX * Texture::TILESIZE, selY * Texture::TILESIZE,
					Texture::TILESIZE - 1, Texture::TILESIZE - 1);
			d->draw_rectangle(white, false, selX * Texture::TILESIZE + 1, selY * Texture::TILESIZE + 1,
					Texture::TILESIZE - 3, Texture::TILESIZE - 3);
			d->draw_rectangle(white, false, selX * Texture::TILESIZE + 2, selY * Texture::TILESIZE + 2,
					Texture::TILESIZE - 5, Texture::TILESIZE - 5);
			d->draw_rectangle(black, false, selX * Texture::TILESIZE + 3, selY * Texture::TILESIZE + 3,
					Texture::TILESIZE - 7, Texture::TILESIZE - 7);
		}
	}
	
	void MapViewer::highlight(const std::list<Gdk::Point>& tiles) {
		for (std::list<Gdk::Point>::iterator it = activeTiles.begin(); it != activeTiles.end(); ++it) {
			get_window()->invalidate_rect(Gdk::Rectangle(it->get_x() * Texture::TILESIZE,
					it->get_y() * Texture::TILESIZE, Texture::TILESIZE, Texture::TILESIZE), false);
		}
		activeTiles = tiles;
		for (std::list<Gdk::Point>::iterator it = activeTiles.begin(); it != activeTiles.end(); ++it) {
			get_window()->invalidate_rect(Gdk::Rectangle(it->get_x() * Texture::TILESIZE,
					it->get_y() * Texture::TILESIZE, Texture::TILESIZE, Texture::TILESIZE), false);
		}
	}
	
	bool MapViewer::on_expose_event(GdkEventExpose *event) {
		map.renderLayers(blitter, 0, 0, map.getWidth() * Texture::TILESIZE, map.getHeight() * Texture::TILESIZE);
		highlight();
		return false;	
	}
}
