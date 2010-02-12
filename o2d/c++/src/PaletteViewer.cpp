/*
 * o2d project -- a 2D game engine -- Palette viewer implementation
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

#include "PaletteViewer.h"
#include <iostream>

namespace o2d {
	PaletteViewer::PaletteViewer(Palette& p) : p(p), selX(0), selY(0), mode(DRAW) {
		blitter = new GTKTileBlitter(this);
		set_size_request(p.getWidth() * 32, p.getHeight() * 32);
		add_events(Gdk::BUTTON_PRESS_MASK | Gdk::POINTER_MOTION_MASK);
		
		signal_button_press_event().connect(sigc::mem_fun(*this, &PaletteViewer::mousePressed));
		signal_motion_notify_event().connect(sigc::mem_fun(*this, &PaletteViewer::mouseDragged));
		
		enterDrawMode();
		show();
	}
	
	PaletteViewer::~PaletteViewer() {
	}
	
	Texture* PaletteViewer::getSelectedTexture() const {
		return p[selX + p.getWidth() * selY].getTexture();
	}
	
	int PaletteViewer::getSelectedReference() const {
		if (p[selX + p.getWidth() * selY] == Tile::blank())
			return -1;
		return selX + p.getWidth() * selY;
	}
	
	Palette& PaletteViewer::getPalette() const {
		return p;
	}
	
	void PaletteViewer::clearHighlight() {
		Gdk::Rectangle oldSelection(
			selX * Texture::TILESIZE, selY * Texture::TILESIZE, Texture::TILESIZE, Texture::TILESIZE);
		get_window()->invalidate_rect(oldSelection, false);
	}
	
	void PaletteViewer::highlight() {
		Glib::RefPtr<Gdk::Window> d = get_window();
		
		if (mode == DRAW) {
			Glib::RefPtr<Gdk::GC> black = get_style()->get_black_gc();
			Glib::RefPtr<Gdk::GC> white = get_style()->get_white_gc();
			
			d->draw_rectangle(black, false, selX * Texture::TILESIZE, selY * Texture::TILESIZE,
					Texture::TILESIZE - 1, Texture::TILESIZE - 1);
			d->draw_rectangle(white, false, selX * Texture::TILESIZE + 1, selY * Texture::TILESIZE + 1,
					Texture::TILESIZE - 3, Texture::TILESIZE - 3);
			d->draw_rectangle(white, false, selX * Texture::TILESIZE + 2, selY * Texture::TILESIZE + 2,
					Texture::TILESIZE - 5, Texture::TILESIZE - 5);
			d->draw_rectangle(black, false, selX * Texture::TILESIZE + 3, selY * Texture::TILESIZE + 3,
					Texture::TILESIZE - 7, Texture::TILESIZE - 7);\
		} else {
			if (addTexture != NULL) {
				Glib::RefPtr<Gdk::Pixbuf> pixbuf = 
						*static_cast<Glib::RefPtr<Gdk::Pixbuf>*>(addTexture->getImage()->getData());
				d->draw_pixbuf(get_style()->get_fg_gc(get_state()), pixbuf, 0, 0, selX * Texture::TILESIZE, selY * Texture::TILESIZE,
								Texture::TILESIZE, Texture::TILESIZE, Gdk::RGB_DITHER_NONE, 0, 0);
			}
		}
	}
	
	void PaletteViewer::highlight(int x, int y) {
		selX = x;
		selY = y;
		highlight();
	}
	
	bool PaletteViewer::on_expose_event(GdkEventExpose *event) {
		// Draw textures
		for (int i = 0; i < p.getWidth(); ++i) {
			for (int j = 0; j < p.getHeight(); ++j) {
				Tile& tile = p[i + p.getWidth() * j];
				if (!tile.isBlank())
					blitter->blit(tile, i * Texture::TILESIZE, j * Texture::TILESIZE);
			}
		}
		
		highlight();
					
		return false;
	}
	
	void PaletteViewer::enterDrawMode() {
		mode = DRAW;
	}
	
	void PaletteViewer::enterEditMode(Texture* t) {
		mode = EDIT;
		addTexture = t;
	}
	
	bool PaletteViewer::mousePressed(GdkEventButton *event) {
		int x = (int)event->x / Texture::TILESIZE;
		int y = (int)event->y / Texture::TILESIZE;
		if (x >= 0 && y >= 0 && x < p.getWidth() && y < p.getHeight()) { 
			if (mode == DRAW) {
				std::cerr << "Draw Mouse Press\n";
				clearHighlight();				
				highlight(x, y);
			} else {
				Tile* t = new Tile(addTexture);
				p.setTile(t, x + p.getWidth() * y);
					
				enterDrawMode();
			}
		}
		return true;
	}
	
	bool PaletteViewer::mouseDragged(GdkEventMotion* event) {
		if (mode == EDIT) {
			int x = (int)event->x / Texture::TILESIZE;
			int y = (int)event->y / Texture::TILESIZE;
			
			if (x >= 0 && y >= 0 && x < p.getWidth() && y < p.getHeight()) {
				clearHighlight();
				highlight(x, y);
			}
			return true;
		}
		return false;
	}
}
