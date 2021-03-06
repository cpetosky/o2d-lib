/*
 * o2d -- a 2D game engine -- GTK tile blitter definition
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

#ifndef GTKTILEBLITTER_H_
#define GTKTILEBLITTER_H_

#include <glibmm/refptr.h>
#include <gdkmm/pixbuf.h>
#include <gtkmm/drawingarea.h>
#include "TileBlitter.h"

namespace o2d {
	/**
	 * This is the GTK version of TileBlitter.
	 */
	class GTKTileBlitter : public TileBlitter {
	public:
		GTKTileBlitter(Gtk::DrawingArea* dest);
		
		// From TextureBlitter
		void blit(Tile& tile, int dx, int dy);
		void blit(Tile& tile, const std::vector<Tile*>& nearby, int frame, int dx, int dy);
		void blitGrid(Tile& tile, const std::vector<Tile*>& nearby, int frame, int dx, int dy);
	private:
		Gtk::DrawingArea* dest;
	
		void addCorner(Glib::RefPtr<Gdk::Pixbuf> src, int dx, int dy, int sx, int sy);
		void addSide(Glib::RefPtr<Gdk::Pixbuf> src, int dx, int dy, int sx, int sy, SliceType st);
		void addBase(Glib::RefPtr<Gdk::Pixbuf> src, int dx, int dy, int sx, int sy);
		void addBend(Glib::RefPtr<Gdk::Pixbuf> src, int dx, int dy, int sx, int sy);
	};
}
#endif /*GTKTILEBLITTER_H_*/
