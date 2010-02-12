/*
 * o2d -- a 2D game engine -- Tile blitter definition
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

#ifndef TEXTUREBLITTER_H_
#define TEXTUREBLITTER_H_

#include <bitset>
#include "Tile.h"

namespace o2d {
	/**
	 * A tile blitter is used to render tiles onto the screen.
	 * 
	 * For simple tiles, this usually means just blitting the entire image.
	 * For animated tiles, the correct subimage corresponding to the current
	 * frame must be used. For complex autotiles, a series of blits are
	 * performed, creating a complex composite image based upon the tile's
	 * neighbors.
	 * 
	 * Because o2d uses a variety of renderers, this class is abstract and
	 * much of the heavy lifting is performed by its subclasses.
	 */
	class TileBlitter {
	public:
		virtual ~TileBlitter();
		
		virtual void blit(Tile& tile, int dx, int dy) = 0;
		virtual void blit(Tile& tile, const std::vector<Tile*>& nearby, int frame, int dx, int dy) = 0;
		virtual void blitGrid(Tile& tile, const std::vector<Tile*>& nearby, int frame, int dx, int dy) = 0;
		
	protected:
		TileBlitter();
		
		enum SliceType {
			HORIZONTAL, VERTICAL
		};
		enum Actions {
			BASE_EMPTY, BASE_CENTER, BASE_NW, BASE_N, BASE_NE, BASE_W, BASE_E, BASE_SW, BASE_S, BASE_SE,
			SIDE_N, SIDE_W, SIDE_S, SIDE_E,
			BEND_NW, BEND_SE,
			CORNER_NW, CORNER_NE, CORNER_SW, CORNER_SE
		};
			
		static const int BORDER_NONE;
		static const int BORDER_UP;
		static const int BORDER_RIGHT;
		static const int BORDER_DOWN;
		static const int BORDER_LEFT;
		
		std::bitset<20> getAutoTextureActions(Tile& tile, const std::vector<Tile*>& nearby);
		bool checkNWCorner(Tile& tile, const std::vector<Tile*>& nearby);
		bool checkNECorner(Tile& tile, const std::vector<Tile*>& nearby);
		bool checkSWCorner(Tile& tile, const std::vector<Tile*>& nearby);
		bool checkSECorner(Tile& tile, const std::vector<Tile*>& nearby);
	};
}
#endif /*TEXTUREBLITTER_H_*/
