/*
 * o2d -- a 2D game engine -- Database definition
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
 *
 * 
 */

#ifndef DATABASE_H_
#define DATABASE_H_

#include <map>
#include <string>
#include <iterator>
#include <boost/filesystem/operations.hpp>
#include <boost/filesystem/fstream.hpp>
#include <boost/filesystem/convenience.hpp>
#include <libxml++/libxml++.h>

#include "Map.h"
#include "Palette.h"
#include "EntityArchetype.h"
#include "ImageLoader.h"
#include "Script.h"
#include "ScriptAction.h"
#include "Exception.h"

namespace o2d {
	/**
	 * The database contains all relavent definitions of game data and controls
	 * their use. All maps, entity archetypes, and palettes are stored in the 
	 * database. Additionally, project data, like the game's title, the avatar to
	 * use for the player, and the avatar's starting location are also stored in the
	 * database.
	 */
	class Database {
	private:
		/**
		 * Used for holding database information.
		 */
		struct Element {
			std::string name;
			std::string description;
			std::string filename;
		};
	
		typedef std::map<std::string, Element>::iterator DbIterator;
		typedef std::map<std::string, Element>::const_iterator ConstDbIterator;
	
	public:
		/**
		 * Create a new resource database based in the given directory
		 */
		Database(boost::filesystem::path baseDir, ImageLoader& imageLoader);
		virtual ~Database();
		
		static const std::string PROJECT_FILE_NAME;
		
		static const std::string TYPES[];
		static const std::string TYPES_PLURAL[];
		static const int NUM_TYPES;
		
		class ConstListIterator : public std::iterator<std::forward_iterator_tag, Element> {
			public:
				ConstListIterator(ConstDbIterator b, ConstDbIterator e);
				~ConstListIterator();
				
				ConstListIterator& operator =(const ConstListIterator& other);
				bool operator ==(const ConstListIterator& other);
				bool operator !=(const ConstListIterator& other);
				
				ConstListIterator& operator ++();
				ConstListIterator operator ++(int);
				
				const Element operator *();
				const Element* operator ->();
				
			private:
				ConstDbIterator b, e;		
		};
	
		// Accessors
		
		/**
		 * Returns a forward const iterator to traverse all <type>s in the database.
		 */
		ConstListIterator getMapListBegin() const;
		ConstListIterator getPaletteListBegin() const;
		ConstListIterator getEntityListBegin() const;
		ConstListIterator getScriptListBegin() const;

		/**
		 * Returns an iterator to the end of the <type> list.
		 */
		ConstListIterator getMapListEnd() const;
		ConstListIterator getPaletteListEnd() const;
		ConstListIterator getEntityListEnd() const;
		ConstListIterator getScriptListEnd() const;

		/**
		 * Returns true if a <type> with this name exists in the metadata database.
		 */
		bool mapExists(const std::string& name) const;
		bool paletteExists(const std::string& name) const;
		bool entityExists(const std::string& name) const;
		bool scriptExists(const std::string& name) const;
		
		/**
		 * Gets the object referred to by this name, loading it from disk if needed.
		 */
		Map& getMap(const std::string& name);
		Palette& getPalette(const std::string& name);
		Script& getScript(const std::string& name);
		ScriptAction& getScriptAction(int type);
				
		/**
		 * Returns the map specified as the initial map by the game project.
		 */
		Map& getInitialMap();
		
		/**
		 * Gets the palette object referred to by this name, loading it from disk if needed.
		 */
		
		/**
		 * Returns an instance of the entity archetype refered to by this name and
		 * initializes its location to the specified map and tile.
		 */
		Entity* getEntityInstance(const std::string& name, const Map& map, int x, int y);
		
		/**
		 * Returns an instance of the entity specified as the game's avatar.
		 */
		Entity* getInitialAvatar();
		
		// Updaters
		
		/**
		 * Adds a map to the metadata database with the provided information.
		 * 
		 * This method does not check to see if such a map actually exists, neither
		 * on disk nor in memory.
		 */ 
		void addMap(const std::string& name, const std::string& description, const std::string& filename);
		
		/**
		 * Adds a palette to the metadata database with the provided information.
		 * 
		 * This method does not check to see if such a palette actually exists, neither
		 * on disk nor in memory.
		 */ 		
		void addPalette(const std::string& name, const std::string& description, const std::string& filename);
		
		// Utility
		
		/**
		 * Writes the map specified to disk, if the map is already in the cache.
		 */
		void saveMap(const std::string& name) const;
		
		/**
		 * Writes the palette specified to disk, if the palette is in the cache.
		 */
		void savePalette(const std::string& name) const;
		
		// Metadata
		
		/**
		 * Get number of maps in database.
		 */
		unsigned int getMapCount() const;

		/**
		 * Get number of palettes in database.
		 */
		unsigned int getPaletteCount() const;

		/**
		 * Get number of entity archetypes in database.
		 */
		unsigned int getEntityCount() const;
		
		// Project Data

		/**
		 * Set the title of the game project.
		 */
		void setTitle(std::string title);
		
		/**
		 * Returns the title of the game project.
		 */
		std::string getTitle() const;
		
		/**
		 * Returns the path at which this game project exists.
		 */
		const boost::filesystem::path& getPath() const;
	
		// Control
		/**
		 * Save all database information to disk.
		 */
		void save() const;
		
	private:
		static const int MAP_TYPE;
		static const int ENTITY_TYPE;
		static const int PALETTE_TYPE;
		static const int SCRIPT_TYPE;
		
		boost::filesystem::path baseDir;
		ImageLoader& imageLoader;	
		
		// Database information
		std::string title;
		std::string initialMap;
		std::string avatar;
		int initX, initY;
		std::map<std::string, std::map<std::string, Element> > db;
		
		// Backing data
		std::map<std::string, Map*> maps;
		std::map<std::string, Palette*> palettes;
		std::map<std::string, EntityArchetype*> entities;
		std::map<std::string, Script*> scripts;
		
		std::vector<ScriptAction*> scriptActions;
		
		/**
		 * Private implementations for accessors.
		 */
		ConstListIterator getBegin(std::string type) const;
		ConstListIterator getEnd(std::string type) const;
		bool exists(const std::string& name, const std::string& type) const;
		
		
		/**
		 * Load database files into memory, creating them if necessary
		 */
		void init();

		/**
		 * Parses an XML database file and loads the corresponding db map with its contents.
		 */	
		void loadDB(std::map<std::string, Element>& db, std::string singular, std::string plural);

		/**
		 * Saves a db map to its XML database file.
		 */
		void saveDB(const std::map<std::string, Element>& db, std::string singular, std::string plural) const;
		
		/**
		 * Parses and initializes scripting actions.
		 */
		void loadScriptActions();
		
		/**
		 * Adds an element to the database provided.
		 */
		void addElement(const std::string& name, const std::string& description,
			const std::string& filename, const std::string& dbName);

		/**
		 * Gets an element, loading it if necessary.
		 */
		template <typename T>
		T& getXML(const std::string& name, int type, std::map<std::string, T*>& dict) {
			// If it doesn't exist, throw an exception
			if (db[TYPES[type]].find(name) == db[TYPES[type]].end())
				throw Exception((TYPES[type] + " \"" + name + "\" doesn't exist.").c_str());
			
			// If it is already loaded, just return it
			if (dict.find(name) != dict.end()) {
				return *dict[name];
			}
				
			// Otherwise, load it from disk, store it in the cache, and return it
			xmlpp::DomParser parser;
			parser.parse_file((baseDir / TYPES_PLURAL[type] / db[TYPES[type]][name].filename).string());
			dict[name] = new T(parser.get_document(), imageLoader, this);
			return *dict[name];			
		}
		
		/**
		 * Gets an element, loading it from a file if necessary.
		 */
		template <typename T>
		T& getFile(const std::string& name, int type, std::map<std::string, T*>& dict) {
			// If it doesn't exist, throw an exception
			if (db[TYPES[type]].find(name) == db[TYPES[type]].end())
				throw Exception((TYPES[type] + " \"" + name + "\" doesn't exist.").c_str());
			
			// If it is already loaded, just return it
			if (dict.find(name) != dict.end()) {
				return *dict[name];
			}
				
			// Otherwise, load it from disk, store it in the cache, and return it
			boost::filesystem::fstream fin(baseDir / TYPES_PLURAL[type] / db[TYPES[type]][name].filename, std::ios::in);
			dict[name] = new T(fin, imageLoader, this);
			fin.close();
			return *dict[name];			
		}
	};
}

#endif /*DATABASE_H_*/
