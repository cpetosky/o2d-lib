/*
 * o2d -- a 2D game engine -- GTK tile blitter implementation
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

#include "GTKTileBlitter.h"
#include <iostream>

namespace o2d {
	GTKTileBlitter::GTKTileBlitter(Gtk::DrawingArea* dest) : TileBlitter(), dest(dest) { 
	}
	
	void GTKTileBlitter::blit(Tile& tile, int dx, int dy) {
		Glib::RefPtr<Gdk::Pixbuf> src = 
				*reinterpret_cast<Glib::RefPtr<Gdk::Pixbuf>*>(tile.getTexture()->getImage()->getData());
		dest->get_window()->draw_pixbuf(dest->get_style()->get_fg_gc(dest->get_state()),
			src,
			0, 0,
			dx, dy,
			Texture::TILESIZE, Texture::TILESIZE,
			Gdk::RGB_DITHER_NONE, 0, 0);
	}
	
	void GTKTileBlitter::blitGrid(Tile& tile, const std::vector<Tile*>& nearby, int frame,
			int dx, int dy) {
		blit(tile, nearby, frame, dx, dy);
	}
	
	void GTKTileBlitter::blit(Tile& tile, const std::vector<Tile*>& nearby, int frame,
			int dx, int dy) {
		Texture* tex = tile.getTexture();
		if (tex == NULL)
			return;
		Glib::RefPtr<Gdk::Pixbuf> src = 
				*reinterpret_cast<Glib::RefPtr<Gdk::Pixbuf>*>(tex->getImage()->getData());
	
		if (src->get_height() > Texture::TILESIZE) { // Blit as AutoTexture
			if (frame >= tex->getFrames())
				frame = 0;
			int offset = frame * Texture::TILESIZE * 3;
			// Check borders, set border flags
			std::bitset<20> actions = getAutoTextureActions(tile, nearby);
			
			// Check cases
			if (actions[BASE_EMPTY]) {
				addBase(src, dx, dy, offset, 0);
			}
			
			if (actions[BASE_CENTER]) {
				addBase(src, dx, dy, offset + Texture::TILESIZE, 2 * Texture::TILESIZE);
			}
			
			if (actions[BASE_NW]) {
				addBase(src, dx, dy, offset, Texture::TILESIZE);
			}
			
			if (actions[BASE_N]) {
				addBase(src, dx, dy, offset + Texture::TILESIZE, Texture::TILESIZE);		
			}
			
			if (actions[BASE_NE]) {
				addBase(src, dx, dy, offset + Texture::TILESIZE + Texture::TILESIZE, Texture::TILESIZE);
			}
			
			if (actions[BASE_W]) {
				addBase(src, dx, dy, offset, 2 * Texture::TILESIZE);			
			}
			
			if (actions[BASE_E]) {
				addBase(src, dx, dy, offset + Texture::TILESIZE + Texture::TILESIZE, Texture::TILESIZE + Texture::TILESIZE);
			}
			
			if (actions[BASE_SW]) {
				addBase(src, dx, dy, offset, Texture::TILESIZE + Texture::TILESIZE + Texture::TILESIZE);
			}
			
			if (actions[BASE_S]) {
				addBase(src, dx, dy, offset + Texture::TILESIZE, Texture::TILESIZE + Texture::TILESIZE + Texture::TILESIZE);			
			}
			
			if (actions[BASE_SE]) {
				addBase(src, dx, dy, offset + Texture::TILESIZE + Texture::TILESIZE, Texture::TILESIZE + Texture::TILESIZE + Texture::TILESIZE);
			}
			
			if (actions[SIDE_W]) {
				addSide(src, dx, dy, offset, Texture::TILESIZE * 2, VERTICAL);
			}
			
			if (actions[SIDE_N]) {
				addSide(src, dx, dy, offset + Texture::TILESIZE, Texture::TILESIZE, HORIZONTAL);
			}
			
			if (actions[SIDE_E]) {
				addSide(src, dx + Texture::TILESIZE / 2, dy,
					offset + 2 * Texture::TILESIZE + Texture::TILESIZE / 2, 2 * Texture::TILESIZE, VERTICAL);
			}
			
			if (actions[SIDE_S]) {
				addSide(src, dx, dy + Texture::TILESIZE / 2,
						offset + Texture::TILESIZE, 3 * Texture::TILESIZE + Texture::TILESIZE / 2, HORIZONTAL);
			}
			
			if (actions[BEND_NW]) {
				addBend(src, dx, dy, offset, Texture::TILESIZE);
			}
			
			if (actions[BEND_SE]) {
				addBend(src, dx + Texture::TILESIZE / 2, dy + Texture::TILESIZE / 2, offset + Texture::TILESIZE * 2 + Texture::TILESIZE / 2, Texture::TILESIZE * 3 + Texture::TILESIZE / 2);
			}
					
			if (actions[CORNER_NW]) {
				addCorner(src, dx, dy, offset + Texture::TILESIZE * 2, 0);
			}
			
			if (actions[CORNER_NE]) {
				addCorner(src, dx + Texture::TILESIZE / 2, dy, offset + Texture::TILESIZE * 2 + Texture::TILESIZE / 2, 0);			
			}
			
			if (actions[CORNER_SW]) {
				addCorner(src, dx, dy + Texture::TILESIZE / 2, offset + Texture::TILESIZE * 2, Texture::TILESIZE / 2);	
			}
			
			if (actions[CORNER_SE]) {
				addCorner(src, dx + Texture::TILESIZE / 2, dy + Texture::TILESIZE / 2, offset + Texture::TILESIZE * 2 + Texture::TILESIZE / 2, Texture::TILESIZE / 2);
			}
		} else { // Blit as PlainTexture
			dest->get_window()->draw_pixbuf(dest->get_style()->get_fg_gc(dest->get_state()),
				src,
				(frame < tex->getFrames()) ? (frame * Texture::TILESIZE) : 0, 0,
				dx, dy,
				Texture::TILESIZE, Texture::TILESIZE,
				Gdk::RGB_DITHER_NONE, 0, 0);
		}
	}	
		
	void GTKTileBlitter::addSide(Glib::RefPtr<Gdk::Pixbuf> src, int dx, int dy, int sx, int sy, SliceType st) {
		int w, h;
		switch (st) {
		case HORIZONTAL:
			w = Texture::TILESIZE;
			h = Texture::TILESIZE / 2;
			break;
		case VERTICAL:
			w = Texture::TILESIZE / 2;
			h = Texture::TILESIZE;
			break;
		}
		dest->get_window()->draw_pixbuf(dest->get_style()->get_fg_gc(dest->get_state()),
			src,
			sx, sy,
			dx, dy,
			w, h,
			Gdk::RGB_DITHER_NONE, 0, 0);
	}
	
	void GTKTileBlitter::addCorner(Glib::RefPtr<Gdk::Pixbuf> src, int dx, int dy, int sx, int sy) {
		dest->get_window()->draw_pixbuf(dest->get_style()->get_fg_gc(dest->get_state()),
			src,
			sx, sy,
			dx, dy,
			Texture::TILESIZE / 2, Texture::TILESIZE / 2,
			Gdk::RGB_DITHER_NONE, 0, 0);
	}
	
	void GTKTileBlitter::addBase(Glib::RefPtr<Gdk::Pixbuf> src, int dx, int dy, int sx, int sy) {
		dest->get_window()->draw_pixbuf(dest->get_style()->get_fg_gc(dest->get_state()),
			src,
			sx, sy,
			dx, dy,
			Texture::TILESIZE, Texture::TILESIZE,
			Gdk::RGB_DITHER_NONE, 0, 0);
	}
	
	void GTKTileBlitter::addBend(Glib::RefPtr<Gdk::Pixbuf> src, int dx, int dy, int sx, int sy) {
		dest->get_window()->draw_pixbuf(dest->get_style()->get_fg_gc(dest->get_state()),
			src,
			sx, sy,
			dx, dy,
			Texture::TILESIZE / 2, Texture::TILESIZE / 2,
			Gdk::RGB_DITHER_NONE, 0, 0);
	}
}
