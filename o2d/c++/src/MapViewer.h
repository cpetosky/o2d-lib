/*
 * o2d -- a 2D game engine -- Map viewer definition
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

#ifndef MAPVIEWER_H_
#define MAPVIEWER_H_

#include <gtkmm/drawingarea.h>
#include <gdkmm/types.h>

#include <list>

#include "Map.h"
#include "GTKTileBlitter.h"

namespace o2d {
	/**
	 * The map viewer allows the editor to display a map in a GTK environment.
	 */
	class MapViewer : public Gtk::DrawingArea {
	public:
		MapViewer(Map& map);
		virtual ~MapViewer();
		
		enum Layer {
			BOTTOM, MIDDLE, TOP, EVENT
		};
		
		Map& getMap();
		Layer getLayer();
		void setLayer(Layer l);
		
		void highlight();
		void highlight(const std::list<Gdk::Point>& tiles);
		
		// Event handlers
		bool on_expose_event(GdkEventExpose *event);
		
		
		
	private:
		Layer layer;
		Map& map;
		TileBlitter* blitter;
		
		std::list<Gdk::Point> activeTiles;
	};
}
#endif /*MAPVIEWER_H_*/
