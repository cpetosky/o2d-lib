/*
 * o2d -- a 2D game engine -- Entity implementation
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

#include "Entity.h"
#include "Map.h"
#include "Texture.h"
#include <iostream>
#include <cmath>
#include <cstdlib>
#include <queue>
#include <algorithm>

namespace o2d {
	const int Entity::FRAMES = 4;
	const int Entity::DIRECTIONS = 4;

	Entity::Entity(const EntityArchetype& arch, const Map& map, int x, int y) :
			EntityArchetype(arch), map(map),
			speed(50), moving(false), moveSum(0), timer(-1), animTimer(-1), animInterval(200),
			facing(SOUTH), frame(0), animating(false) {
				
		moveToTile(x, y);			
	}
	
	void Entity::moveX(int d) {
		xPos += d;
		if (d > 0)
			facing = EAST;
		else if (d < 0)
			facing = WEST;
	}
	
	void Entity::moveY(int d) {
		yPos += d;
		if (d > 0)
			facing = SOUTH;
		else if (d < 0)
			facing = NORTH;
	}
	
	void Entity::rotateLeft() {
		switch (facing) {
		case SOUTH:
			facing = EAST;
			break;
		case EAST:
			facing = NORTH;
			break;
		case NORTH:
			facing = WEST;
			break;
		case WEST:
			facing = SOUTH;
			break;	
		}
	}
	
	void Entity::rotateRight() {
		switch (facing) {
		case SOUTH:
			facing = WEST;
			break;
		case EAST:
			facing = SOUTH;
			break;
		case NORTH:
			facing = EAST;
			break;
		case WEST:
			facing = NORTH;
			break;	
		}
	}
	
	Entity::Direction Entity::getFacing() const {
		return facing;
	}
	
	/**
	 * Returns the x component of the entity's location.
	 */
	int Entity::getX() const {
		return xPos;
	}
	
	/**
	 * Returns the y component of the entity's location.
	 */
	int Entity::getY() const {
		return yPos;
	}
		
	/**
	 * Get the (current) speed of the entity (in pixels per second)
	 */
	int Entity::getSpeed() const {
		return speed;
	}
	
	/**
	 * Set the current speed of the entity (in pixels per second)
	 */
	void Entity::setSpeed(int s) {
		speed = s;
	}
	
	/**
	 * Return true if the entity is currently moving.
	 */
	bool Entity::isMoving() const {
		return moving;
	}
	
	/**
	 * Starts or stops the entity from moving.
	 */
	void Entity::setMoving(bool m) {
		moving = m;
	}
	
	/**
	 * Returns the timer of the entity.
	 * 
	 * If the timer is -1, it is currently off. If it is 0, the onTimer event
	 * should be fired. If higher than 0, then the onTimer event should be
	 * fired in (timer) milliseconds.
	 */
	int Entity::getTimer() const {
		return timer;
	}
	
	/**
	 * Sets the timer of the entity.
	 * 
	 * If t is -1, disable the timer. If t is 0, the onTimer event should be fired.
	 * If t is higher than 0, then the onTimer event should be fired in t
	 * milliseconds.
	 */
	void Entity::setTimer(int t) {
		timer = t < 0 ? -1 : t;	
	}
	
	/**
	 * Tells the entity that delta milliseconds have passed.
	 * 
	 * This method affects all time-based attributes of the entity. Most
	 * importantly, it affects the entity's timer and his animation loop.
	 */ 
	void Entity::passTime(int delta) {
		if (timer > 0) {
			timer -= delta;
			if (timer < 0)
				timer = 0;
		}
		if (animating) {
			animTimer -= delta;
			if (animTimer <= 0) {
				frame = (frame + 1) % FRAMES;
				animTimer = animInterval;
			}
		}
	}
	
	void Entity::startAnimation(int interval) {
		animating = true;
		animTimer = interval;
		animInterval = interval;
	}
	
	void Entity::stopAnimation() {
		animating = false;
		frame = 0;
	}
	
	int Entity::getFrame() const {
		return frame;	
	}
		
	/**
	 * Attempts to move the entity on the current map.
	 * 
	 * This method checks first to see if movement should occur, based upon the
	 * delta from the last clocktick and the state of the entity. If movement is
	 * desired, this method performs boundary analysis on the surrounding tiles
	 * to ensure movement is possible. If everything checks, the entity is moved
	 * appropriately.
	 * 
	 * If you wish to move the entity regardless of movement rates, facings,
	 * deltas, and boundaries, see moveX and moveY.
	 */
	void Entity::move(int delta) {
		// Movement
		moveSum += (speed * delta);
		int move = moveSum / 1000;
		moveSum %= 1000;

		int x1, x2, y1, y2;
		getTilesOccupied(x1, y1, x2, y2);
	
		if (!path.empty()) {
//			std::cerr << "Lancer is between " << x1 << "," << y1 << " and " << x2 << "," << y2 << std::endl;
//			std::cerr << "Pixel coords: " << xPos << "," << yPos << std::endl;
			// Move according to move queue
			int x, y;
			Point p = path.front();
			while ((x1 == p.first && p.first == x2) &&
			       (y1 == p.second && p.second == y2)) {
				path.pop_front();
				if (path.empty()) {
					moving = false;
					return;
				}
			    p = path.front();
			}
			
			// Figure out which direction to get to tile in question.
			// Here, x and y refer to the distance needed to travel in each
			// direction to get to the goal tile.
			x = std::max(abs(x1 - p.first), abs(x2 - p.first));
			y = std::max(abs(y1 - p.second), abs(y2 - p.second));
			
//			std::cerr << "\tGoal: " << p.first << "," << p.second << std::endl;
//			std::cerr << "\tx = " << x << " & y=" << y << std::endl;
			
			if (y == 0 || (x != 0 && x < y))
				if (p.first <= x1)
					facing = WEST;
				else
					facing = EAST;
			else
				if (p.second <= y1)
					facing = NORTH;
				else
					facing = SOUTH;
						
			moving = true;
		}
		if (moving) {
			// Try to move up
			if ((facing == NORTH) && yPos - move >= 0) {
				bool goodToGo = true;
				// Test if movement crosses tile boundary
				if (((yPos + height - width / 2)/ Texture::TILESIZE) !=
						((yPos + height - width / 2 - move) / Texture::TILESIZE)) {
					// Since movement crosses boundary, check passage information				
					for (int i = x1; i <= x2; ++i) {
						// First check leave passage information on current tiles
						if (!(map.getPassage(i, y1) & Tile::LEAVE_UP)) {
							goodToGo = false;
							break;
						}
						// Then check enter permission on acquiring tile
						if (!(map.getPassage(i, y1 - 1) & Tile::ENTER_DOWN)) {
							goodToGo = false;
							break;
						}
					}
				} 
				if (goodToGo) {
					// Move
					moveY(-move);
				}
			}
			// Try to move down
			else if ((facing == SOUTH) && yPos + move < map.getPixelHeight() - height) {
				bool goodToGo = true;
				// Test if movement crosses tile boundary
				if (((yPos + height) / Texture::TILESIZE) !=
						((yPos + height + move) / Texture::TILESIZE)) {
					// Since movement crosses boundary, check passage information				
					for (int i = x1; i <= x2; ++i) {
						// First check leave passage information on current tiles
						if (!(map.getPassage(i, y2) & Tile::LEAVE_DOWN)) {
							goodToGo = false;
							break;
						}
						// Then check enter permission on acquiring tile
						if (!(map.getPassage(i, y2 + 1) & Tile::ENTER_UP)) {
							goodToGo = false;
							break;
						}
					}
				} 
				if (goodToGo) {
					// Move
					moveY(move);
				}
			}
			// Try to move left
			else if ((facing == WEST) && xPos - move >= 0) {
				bool goodToGo = true;
				// Test if movement crosses tile boundary
				if (((xPos + width / 4)/ Texture::TILESIZE) !=
						((xPos + width / 4 - move) / Texture::TILESIZE)) {
					// Since movement crosses boundary, check passage information				
					for (int j = y1; j <= y2; ++j) {
						// First check leave passage information on current tiles
						if (!(map.getPassage(x1, j) & Tile::LEAVE_LEFT)) {
							goodToGo = false;
							break;
						}
						// Then check enter permission on acquiring tile
						if (!(map.getPassage(x1 - 1, j) & Tile::ENTER_RIGHT)) {
							goodToGo = false;
							break;
						}
					}
				} 
				if (goodToGo) {
					// Move
					moveX(-move);
				}
			}
			// Try to move right
			else if ((facing == EAST) && xPos + move < map.getPixelWidth() - width) {
				bool goodToGo = true;
				// Test if movement crosses tile boundary
				if (((xPos + 3 * (width / 4))/ Texture::TILESIZE) != 
						((xPos + 3 * (width / 4) + move) / Texture::TILESIZE)) {
					// Since movement crosses boundary, check passage information				
					for (int j = y1; j <= y2; ++j) {
						// First check leave passage information on current tiles
						if (!(map.getPassage(x2, j) & Tile::LEAVE_RIGHT)) {
							goodToGo = false;
							break;
						}
						// Then check enter permission on acquiring tile
						if (!(map.getPassage(x2 + 1, j) & Tile::ENTER_LEFT)) {
							goodToGo = false;
							break;
						}
					}
				} 
				if (goodToGo) {
					// Move
					moveX(move);
				}
			}
		}
	}
	
	/**
	 * Immediately moves the entity to the specified tile on its current map.
	 * This method ignores tile and map boundaries.
	 */ 
	void Entity::moveToTile(int x, int y) {
		xPos = x * Texture::TILESIZE;
		yPos = (y + 1) * Texture::TILESIZE - height - 1;
	}
		
	int Entity::guessDistance(int x1, int y1, int x2, int y2) {
		return std::abs(x1 - x2) + std::abs(y1 - y2);
	}
	
	int Entity::moveCost(int x1, int y1, int x2, int y2) {
		return 1;
	}
	
	int Entity::mark(Node* node, Node* parent, int dX, int dY) {
		int cost = moveCost(node->x, node->y, parent->x, parent->y) + guessDistance(node->x, node->y, dX, dY);
		if (node->cost == -1 || node->cost > cost) {
			node->parent = parent;
			node->cost = cost;
			return cost;
		}
		return node->cost; 
	}
		
	void Entity::walkToTile(int dX, int dY) {
		std::vector<std::vector<Node*> > tree;
		tree.resize(map.getWidth());
		for (int i = 0; i < map.getWidth(); ++i) {
			tree[i].resize(map.getHeight());
			for (int j = 0; j < map.getHeight(); ++j) {
				tree[i][j] = new Node(i, j);
			}
		}
		std::priority_queue<Node*, std::vector<Node*>, NodeComp> nodeQ;
		int x1, y1, x2, y2;
		getTilesOccupied(x1, y1, x2, y2);
		nodeQ.push(tree[x1][y1]);
		while (!nodeQ.empty()) {
			Node* node = nodeQ.top();
			nodeQ.pop();
			
			// End if target node found
			if (node->x == dX && node->y == dY)
				break;
				
			if (!node->closed) {
				// Push neighboring nodes into the queue.
				if (node->x > 0 && !tree[node->x-1][node->y]->closed &&
						map.getPassage(node->x-1, node->y) & Tile::ENTER_RIGHT) {
					mark(tree[node->x-1][node->y], node, dX, dY);
					nodeQ.push(tree[node->x-1][node->y]);
				}
				if (node->x < map.getWidth() - 1 && !tree[node->x+1][node->y]->closed &&
						map.getPassage(node->x+1, node->y) & Tile::ENTER_LEFT) {
					mark(tree[node->x+1][node->y], node, dX, dY);
					nodeQ.push(tree[node->x+1][node->y]);
				}
				if (node->y > 0 && !tree[node->x][node->y-1]->closed &&
						map.getPassage(node->x, node->y-1) & Tile::ENTER_DOWN) {
					mark(tree[node->x][node->y-1], node, dX, dY);
					nodeQ.push(tree[node->x][node->y-1]);
				}
				if (node->y < map.getHeight() - 1 && !tree[node->x][node->y+1]->closed &&
						map.getPassage(node->x, node->y+1) & Tile::ENTER_UP) {
					mark(tree[node->x][node->y+1], node, dX, dY);
					nodeQ.push(tree[node->x][node->y+1]);
				}
				node->closed = true;			
			}
		} 
		
		Node* n = tree[dX][dY];
		do {
			path.push_front(Point(n->x, n->y));
		} while ((n = n->parent));
		
		for (int i = 0; i < map.getWidth(); ++i) {
			for (int j = 0; j < map.getHeight(); ++j) {
				delete tree[i][j];
			}
		}
	}
	
	
	/**
	 * Returns all the tile coordinates which this entity is currently occupying.
	 * This takes projected 3D space into account. In general, an entity is
	 * considered to occupy the tiles covered by a rectangle (width / 2) pixels wide
	 * and (width / 2) pixels tall, starting from its base. Naturally, entities with
	 * strange form factors won't fit this general rule.
	 * 
	 * This is used mostly for map-based border detection. It is unsuitable for
	 * entity-on-entity collision, and should not be used for such purposes.
	 * 
	 * TODO: Load necessary form factor information from the XML instead of relying
	 * upon above formula to always hold true.
	 */
	void Entity::getTilesOccupied(int& x1, int& y1, int& x2, int& y2) {
		x1 = xPos + (width / 4);
		y1 = yPos + height - (width / 2);
		x2 = x1 + (width / 2);
		y2 = y1 + (width / 2);
		
		x1 /= Texture::TILESIZE;
		y1 /= Texture::TILESIZE;
		x2 /= Texture::TILESIZE;
		y2 /= Texture::TILESIZE;
	}
	void Entity::setFacing(Direction d) {
		facing = d;
	}
		
	bool Entity::isAnimating() const {
		return animating;
	}
		
	Entity::~Entity() {
	}
	
	bool Entity::operator <(const Entity& e) const {
		if (xPos != e.xPos)
			return xPos < e.xPos;
		return yPos < e.yPos;
	}
}
