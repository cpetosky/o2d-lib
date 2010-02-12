/*
 * o2d -- a 2D game engine -- Entity archetype definition
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

#ifndef ENTITYARCHETYPE_H_
#define ENTITYARCHETYPE_H_

#include <string>
#include <vector>
#include <libxml++/libxml++.h>

#include "Image.h"
#include "ImageLoader.h"


namespace o2d {
	// Forward declaration
	class Entity;
	class Map;
	class Database;
	
	/**
	 * EntityArchetypes represent the abstract, internally "clean" entity 
	 * types that actual, in-game entities are built from. These archetypes
	 * lack game-specific information like which map they are on or local
	 * variable that have been set. Instead, they serve as the basis from which
	 * those game-specific entities are created.
	 * 
	 * An EntityArchetype can be thought of as a factory for creating Entities.
	 */
	class EntityArchetype {
	public:
		/**
		 * Construct an EntityArchetype based upon an XML document. Use the 
		 * provided ImageLoader to load its images from the disk.
		 */
		EntityArchetype(xmlpp::Document* doc, ImageLoader& loader, Database* db);
	
		/**
		 * Return the name of this archetype, as defined in the database.
		 */
		std::string getName() const;
		
		/**
		 * Return the width of this entity, in pixels.
		 */
		int getWidth() const;
		
		/**
		 * Return the height of this entity, in pixels.
		 */
		int getHeight() const;
		
		/**
		 * Return the filename of the script that controls this entity.
		 */
		std::string getTimerScript() const;
		std::string getInitScript() const;
		std::string getIdleScript() const;

		/**
		 * Return the Image that this entity uses.
		 */
		Image* getImage() const;
		
		/**
		 * Create and return an instance of this archetype at the specified
		 * location.
		 * 
		 * Note that this does no checking as to whether such a location is
		 * actually accessible to an entity.
		 */
		Entity* instance(const Map& map, int x, int y) const;
	
	protected:

		/**
		 * Copy an archetype.
		 */
		EntityArchetype(const EntityArchetype& arch);

		int width;
		int height;
	
	private:
		std::string name;
		int frames;
		std::vector<std::string> modes;
		
		std::string timerScript, idleScript, initScript;
		
		Image* image;
	};
}

#endif /*ENTITYARCHETYPE_H_*/
