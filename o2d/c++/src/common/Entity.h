/*
 * o2d -- a 2D game engine -- Entity definition
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

#ifndef ENTITY_H_
#define ENTITY_H_
#include <map>
#include <string>
#include <vector>

#include "EntityArchetype.h"
#include "Script.h"

namespace o2d {	
	/**
	 * Entities are anything that can move or interact in the game world,
	 * including the player's character. This class encapsulates entity
	 * movement, collisions, scripting hooks, and animation.
	 */
	class Entity : public EntityArchetype {
	public:
		static const int FRAMES;
		static const int DIRECTIONS;
		
		enum Direction {
			SOUTH = 0, WEST = 1, EAST = 2, NORTH = 3
		};
		
		Entity(const EntityArchetype& e, const Map& map, int x, int y);
		
		void moveX(int d);
		void moveY(int d);
		void rotateLeft();
		void rotateRight();
		int getX() const;
		int getY() const;
		
		int getSpeed() const;
		void setSpeed(int s);
		
		int getTimer() const;
		void setTimer(int t);
		void passTime(int delta);
		
		bool isMoving() const;
		void setMoving(bool m = true);
		
		void move(int delta);
		void moveToTile(int x, int y);
		void walkToTile(int x, int y);
		
		
		void getTilesOccupied(int& x1, int& y1, int& x2, int& y2);
		
		void setFacing(Direction d);
		Direction getFacing() const;
		
		void startAnimation(int interval);
		void stopAnimation();
		bool isAnimating() const;
		int getFrame() const;
		
		virtual ~Entity();
		
		// Operators
		bool operator <(const Entity& e) const;
					
	private:
		typedef std::pair<int, int> Point;
		struct Node {
			Node(int x, int y) : x(x), y(y), parent(NULL), cost(-1), closed(false) {}
			int x;
			int y;
			Node* parent;
			int cost;
			bool closed;
		};
		class NodeComp {
		public:
			bool operator ()(Node* n1, Node* n2) {
				return n1->cost > n2->cost;
			}
		};
		
		int guessDistance(int x1, int y1, int x2, int y2);
		int moveCost(int x1, int y1, int x2, int y2);
		int mark(Node* node, Node* parent, int dX, int dY); 
		 		
		// Position and movement
		const Map& map;
		int xPos, yPos;
		int speed;
		bool moving;
		int moveSum;
		std::list<Point> path;
		
		int timer;
		int animTimer;
		int animInterval;
		
		Direction facing;
		int frame;
		bool animating;
	};
}
#endif /*ENTITY_H_*/
