/*
 * o2d -- a 2D game engine -- Palette viewer definition
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
 
#ifndef PALETTEVIEWER_H_
#define PALETTEVIEWER_H_

#include <gtkmm/drawingarea.h>
#include <gdkmm/types.h>
#include <gdkmm/pixbuf.h>
#include <glibmm/refptr.h>

#include "Palette.h"
#include "GTKTileBlitter.h"

namespace o2d {
	/**
	 * The palette viewer displays an o2d palette in the GTK environment.
	 * It also supports various mouse controls to allow selection of tiles,
	 * usually for drawing onto a map.
	 */
	class PaletteViewer : public Gtk::DrawingArea {
	public:
		PaletteViewer(Palette& p);
		virtual ~PaletteViewer();
	
		void highlight();
		void highlight(int x, int y);
		void clearHighlight();
		Texture* getSelectedTexture() const;
		int getSelectedReference() const;
		Palette& getPalette() const;
		
		void enterDrawMode();
		void enterEditMode(Texture* t);
		
		// Event handlers for Palette widgets
		bool on_expose_event(GdkEventExpose *event);
		bool mousePressed(GdkEventButton *event);
		bool mouseDragged(GdkEventMotion* event);
	
	private:
		enum Mode {
			DRAW, EDIT
		};
		
		Palette& p;
		int selX, selY;
		Texture* addTexture;
		Mode mode;
		Glib::RefPtr<Gdk::Pixbuf> pixbuf;
		TileBlitter* blitter;
	
		void initImages();
	};
}
#endif /*PALETTEVIEWER_H_*/
