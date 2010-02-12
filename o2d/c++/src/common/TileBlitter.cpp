/*
 * o2d -- a 2D game engine -- Tile blitter implementation
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

#include "TileBlitter.h"

namespace o2d {
	const int TileBlitter::BORDER_NONE =  0x00;
	const int TileBlitter::BORDER_UP =    0x01;
	const int TileBlitter::BORDER_RIGHT = 0x02;
	const int TileBlitter::BORDER_DOWN =  0x04;
	const int TileBlitter::BORDER_LEFT =  0x08;
	
	TileBlitter::TileBlitter()
	{
	}
	
	TileBlitter::~TileBlitter()
	{
	}
	
	std::bitset<20> TileBlitter::getAutoTextureActions(Tile& tile, const std::vector<Tile*>& nearby) {
		std::bitset<20> flags(false);
		
		int borders = BORDER_NONE;
		
		Tile* t;
		t = nearby[3];
		if (*t == tile)
			borders |= BORDER_LEFT;
		
		t = nearby[5];
		if (*t == tile)
			borders |= BORDER_RIGHT;
	
		t = nearby[1];
		if (*t == tile)
			borders |= BORDER_UP;
	
		t = nearby[7];
		if (*t == tile)
			borders |= BORDER_DOWN;
		
		switch (borders) {
		// No border case -- default tile
		// No inside corner checks
		case BORDER_NONE:
			flags[BASE_EMPTY] = true;
			break;
		
		// Dead end cases -- corner tile + extra corner tile
		// No inside corner checks.
		case BORDER_LEFT:
			flags[BASE_NE] = flags[SIDE_S] = flags[BEND_SE] = true;
			break;
			
		case BORDER_RIGHT:
			flags[BASE_SW] = flags[SIDE_N] = flags[BEND_NW] = true;
			break;
	
		case BORDER_UP:
			flags[BASE_SW] = flags[SIDE_E] = flags[BEND_SE] = true;
			break;
			
		case BORDER_DOWN:
			flags[BASE_NE] = flags[SIDE_W] = flags[BEND_NW] = true;
			break;
	
		// Elbow cases -- corner tile
		// Gotta check for the inside corner!
		case BORDER_LEFT | BORDER_UP:
			flags[BASE_SE] = true;
			flags[CORNER_NW] = checkNWCorner(tile, nearby);
			break;
			
		case BORDER_UP | BORDER_RIGHT:
			flags[BASE_SW] = true;
			flags[CORNER_NE] = checkNECorner(tile, nearby);
			break;
			
		case BORDER_RIGHT | BORDER_DOWN:
			flags[BASE_NW] = true;
			flags[CORNER_SE] = checkSECorner(tile, nearby);
			break;
			
		case BORDER_DOWN | BORDER_LEFT:
			flags[BASE_NE] = true;
			flags[CORNER_SW] = checkSWCorner(tile, nearby);
			break;
			
		// Row/column cases -- side + opposite side
		// No inside corner checks.
		case BORDER_UP | BORDER_DOWN:
			flags[BASE_W] = flags[SIDE_E] = true;
			break;
				
		case BORDER_LEFT | BORDER_RIGHT:
			flags[BASE_N] = flags[SIDE_S] = true;	
			break;
	
		// T cases -- side tile
		// Gotta check for both inside corners!
		case BORDER_LEFT | BORDER_UP | BORDER_RIGHT:
			flags[BASE_S] = true;
			flags[CORNER_NW] = checkNWCorner(tile, nearby);
			flags[CORNER_NE] = checkNECorner(tile, nearby);
			break;
	
		case BORDER_UP | BORDER_RIGHT | BORDER_DOWN:
			flags[BASE_W] = true;
			flags[CORNER_NE] = checkNECorner(tile, nearby);
			flags[CORNER_SE] = checkSECorner(tile, nearby);
			break;
	
		case BORDER_RIGHT | BORDER_DOWN | BORDER_LEFT:
			flags[BASE_N] = true;
			flags[CORNER_SW] = checkSWCorner(tile, nearby);
			flags[CORNER_SE] = checkSECorner(tile, nearby);
			break;
	
		case BORDER_DOWN | BORDER_LEFT | BORDER_UP:
			flags[BASE_E] = true;
			flags[CORNER_NW] = checkNWCorner(tile, nearby);
			flags[CORNER_SW] = checkSWCorner(tile, nearby);
			break;
	
		// Middle case -- middle tile
		// Gotta check for every inside corner!
		case BORDER_LEFT | BORDER_UP | BORDER_RIGHT | BORDER_DOWN:
			flags[BASE_CENTER] = true;
			flags[CORNER_NW] = checkNWCorner(tile, nearby);
			flags[CORNER_NE] = checkNECorner(tile, nearby);
			flags[CORNER_SW] = checkSWCorner(tile, nearby);
			flags[CORNER_SE] = checkSECorner(tile, nearby);
			break;		
		}
		
		return flags;
	}
	
	bool TileBlitter::checkNWCorner(Tile& tile, const std::vector<Tile*>& nearby) {
		return *nearby[0] != tile;	
	}
	
	bool TileBlitter::checkNECorner(Tile& tile, const std::vector<Tile*>& nearby) {
		return *nearby[2] != tile;	
	}
	
	bool TileBlitter::checkSWCorner(Tile& tile, const std::vector<Tile*>& nearby) {
		return *nearby[6] != tile;	
	}
	
	bool TileBlitter::checkSECorner(Tile& tile, const std::vector<Tile*>& nearby) {
		return *nearby[8] != tile;		
	}
}
