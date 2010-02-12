/*
 * o2d -- a 2D game engine -- Database implementation
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

#include "Database.h"
#include <iostream>
#include <sstream>
#include "Exception.h"

namespace o2d {
	/**
	 * Constants.
	 */
	const std::string Database::PROJECT_FILE_NAME = "project.xml";
	const std::string Database::TYPES[] = {"map", "palette", "entity", "script"};
	const std::string Database::TYPES_PLURAL[] = {"maps", "palettes", "entities", "scripts"};
	const int Database::NUM_TYPES = sizeof TYPES / sizeof TYPES[0];

	const int Database::MAP_TYPE = 0;
	const int Database::PALETTE_TYPE = 1;
	const int Database::ENTITY_TYPE = 2;
	const int Database::SCRIPT_TYPE = 3;

	Database::Database(boost::filesystem::path baseDir, ImageLoader& imageLoader)
			: baseDir(baseDir), imageLoader(imageLoader) {
		init();
	}
	
	Database::~Database() {
		for (std::map<std::string, Map*>::iterator it = maps.begin(); it != maps.end(); ++it) {
			delete it->second;
			it->second = NULL;
		}
		for (std::map<std::string, Palette*>::iterator it = palettes.begin(); it != palettes.end(); ++it) {
			delete it->second;
			it->second = NULL;
		}
		for (std::map<std::string, EntityArchetype*>::iterator it = entities.begin(); it != entities.end(); ++it) {
			delete it->second;
			it->second = NULL;
		}
		for (std::map<std::string, Script*>::iterator it = scripts.begin(); it != scripts.end(); ++it) {
			delete it->second;
			it->second = NULL;
		}
	}
	
	void Database::init() {
		// Check if project exists
		if (boost::filesystem::exists(baseDir / PROJECT_FILE_NAME)) {
			// Load database	
			// Parse database files and load contents
			for (int i = 0; i < NUM_TYPES; ++i) {
				db[TYPES[i]]; // Create db before using it.
				loadDB(db[TYPES[i]], TYPES[i], TYPES_PLURAL[i]);
			}
			
			// Load script actions
			loadScriptActions();
	
			// Parse project file
			xmlpp::DomParser parser;
			parser.parse_file((baseDir / PROJECT_FILE_NAME).string());
			xmlpp::Document* doc = parser.get_document();
			const xmlpp::Element* root = dynamic_cast<const xmlpp::Element*>(doc->get_root_node());
			title = dynamic_cast<const xmlpp::Element*>(root->find("title")[0])->get_child_text()->get_content();
			initialMap = dynamic_cast<const xmlpp::Element*>(root->find("map")[0])->get_child_text()->get_content();
			const xmlpp::Element* avatarNode = dynamic_cast<const xmlpp::Element*>(root->find("avatar")[0]);
			avatar = dynamic_cast<const xmlpp::Element*>(avatarNode->find("name")[0])->get_child_text()->get_content();
			initX = atoi(dynamic_cast<const xmlpp::Element*>(avatarNode->find("x")[0])->get_child_text()->get_content().c_str());
			initY = atoi(dynamic_cast<const xmlpp::Element*>(avatarNode->find("y")[0])->get_child_text()->get_content().c_str());
		} else {
			// Create database
			boost::filesystem::create_directory(baseDir / "db");
			boost::filesystem::create_directory(baseDir / "entities");
			boost::filesystem::create_directory(baseDir / "fonts");
			boost::filesystem::create_directory(baseDir / "maps");
			boost::filesystem::create_directory(baseDir / "palettes");
			boost::filesystem::create_directory(baseDir / "scripts");
			boost::filesystem::create_directory(baseDir / "scripts" / "entity");
			boost::filesystem::create_directory(baseDir / "gfx");
			boost::filesystem::create_directory(baseDir / "gfx" / "entities");
			boost::filesystem::create_directory(baseDir / "gfx" / "textures");
			
			// Write empty project XML
			title = "New Project";
			boost::filesystem::fstream fout(baseDir / PROJECT_FILE_NAME, std::ios::out);
			fout << "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
				 << "<project>\n"
				 << "\t<title>" << title << "</title>\n"
				 << "</project>\n";
	
			fout.flush();
			fout.close();
				
			// Write empty project database XML
			for (int i = 0; i < NUM_TYPES; ++i) {
				fout.open(baseDir / "db" / (TYPES_PLURAL[i] + ".xml"), std::ios::out);
				fout << "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
					 << "<" << TYPES_PLURAL[i] << ">\n"
					 << "</" << TYPES_PLURAL[i] << ">\n";
				 fout.flush();
				 fout.close();
			}
		}
	}

	Database::ConstListIterator Database::getBegin(std::string type) const {
		return Database::ConstListIterator(db.find(type)->second.begin(), db.find(type)->second.end());
	}
	
	Database::ConstListIterator Database::getMapListBegin() const {
		return getBegin("map");
	}
	
	Database::ConstListIterator Database::getPaletteListBegin() const {
		return getBegin("palette");
	}
	
	Database::ConstListIterator Database::getEntityListBegin() const {
		return getBegin("entity");
	}
	
	Database::ConstListIterator Database::getScriptListBegin() const {
		return getBegin("script");
	}
	
	Database::ConstListIterator Database::getEnd(std::string type) const {
		return Database::ConstListIterator(db.find(type)->second.end(), db.find(type)->second.end());	
	}
	Database::ConstListIterator Database::getMapListEnd() const  {
		return getEnd("map");
	}
	
	Database::ConstListIterator Database::getPaletteListEnd() const  {
		return getEnd("palette");
	}
	
	Database::ConstListIterator Database::getEntityListEnd() const  {
		return getEnd("entity");
	}
	
	Database::ConstListIterator Database::getScriptListEnd() const {
		return getEnd("script");
	}
	
	bool Database::exists(const std::string& name, const std::string& type) const {
		return db.find(type)->second.find(name) != db.find(type)->second.end();
	}
	
	bool Database::mapExists(const std::string& name) const {
		return exists(name, "map");
	}
	
	bool Database::paletteExists(const std::string& name) const {
		return exists(name, "palette");
	}
	
	bool Database::entityExists(const std::string& name) const {
		return exists(name, "entity");
	}

	bool Database::scriptExists(const std::string& name) const {
		return exists(name, "script");
	}

	Map& Database::getMap(const std::string& name) {
		return getXML(name, MAP_TYPE, maps);
	}
		
	Palette& Database::getPalette(const std::string& name) {
		return getXML(name, PALETTE_TYPE, palettes);
	}

	Script& Database::getScript(const std::string& name) {
		return getFile(name, SCRIPT_TYPE, scripts);
	}

	ScriptAction& Database::getScriptAction(int type) {
		return *scriptActions[type];	
	}
	
	Map& Database::getInitialMap() {
		return getMap(initialMap);
	}
	
	Entity* Database::getEntityInstance(const std::string& name, const Map& map, int x, int y) {
		EntityArchetype& e = getXML(name, ENTITY_TYPE, entities);	
		return e.instance(map, x, y);
	}
	
	Entity* Database::getInitialAvatar() {
		return getEntityInstance(avatar, getInitialMap(), initX, initY);
	}
	
	void Database::addElement(const std::string& name, const std::string& description,
			const std::string& filename, const std::string& dbName) {
		Element e;
		e.name = name;
		e.description = description;
		e.filename = filename;		
		db[dbName][e.name] = e;
	}
	
	void Database::addMap(const std::string& name, const std::string& description, const std::string& filename) {
		addElement(name, description, filename, "map");
	}
	
	void Database::addPalette(const std::string& name, const std::string& description, const std::string& filename) {
		addElement(name, description, filename, "palette");
	}
	
	void Database::saveMap(const std::string& name) const {
		// Make sure map exists and is cached
		if (maps.find(name) == maps.end())
			return;
			
		boost::filesystem::fstream fout(baseDir / "maps" / db.find("map")->second.find(name)->second.filename,
				std::ios::out | std::ios::trunc);
		
		fout << *maps.find(name)->second;
		fout.flush();
		fout.close();
	}
	
	void Database::savePalette(const std::string& name) const {
		// Make sure palette exists and is cached
		if (palettes.find(name) == palettes.end())
			return;
			
		boost::filesystem::fstream fout(baseDir / "palettes" / db.find("palette")->second.find(name)->second.filename,
				std::ios::out | std::ios::trunc);
		
		fout << *palettes.find(name)->second;
		fout.flush();
		fout.close();
	}
	
	unsigned int Database::getMapCount() const {
		return db.find("map")->second.size();
	}
	
	unsigned int Database::getPaletteCount() const {
		return db.find("palette")->second.size();
	}
	
	void Database::setTitle(std::string title) {
		this->title = title;
	}
	
	std::string Database::getTitle() const {
		return title;
	}
	
	const boost::filesystem::path& Database::getPath() const {
		return baseDir;	
	}
	
	void Database::save() const {
		for (int i = 0; i < NUM_TYPES; ++i)
			saveDB(db.find(TYPES[i])->second, TYPES[i], TYPES_PLURAL[i]);
			
		for (std::map<std::string, Map*>::const_iterator it = maps.begin(); it != maps.end(); ++it)
			saveMap(it->first);
		
		for (std::map<std::string, Palette*>::const_iterator it = palettes.begin(); it != palettes.end(); ++it)
			savePalette(it->first);
		
	}
	
	void Database::loadDB(std::map<std::string, Element>& db, std::string singular, std::string plural) {
		static xmlpp::DomParser parser;
		parser.set_substitute_entities();
		parser.parse_file((baseDir / "db" / (plural + ".xml")).string());
		xmlpp::Document* doc = parser.get_document();
		const xmlpp::Element* root = dynamic_cast<const xmlpp::Element*>(doc->get_root_node());
		
		std::vector<xmlpp::Node*> dbNodes = root->find(singular);
		for (unsigned int i = 0; i < dbNodes.size(); ++i) {
			Element e;
			e.name = dynamic_cast<const xmlpp::Element*>(dbNodes[i]->find("name")[0])->get_child_text()->get_content(); 
			e.description = dynamic_cast<const xmlpp::Element*>(dbNodes[i]->find("description")[0])->get_child_text()->get_content();
			e.filename = dynamic_cast<const xmlpp::Element*>(dbNodes[i]->find("filename")[0])->get_child_text()->get_content();
			db[e.name] = e;
		}
	}
	
	void Database::saveDB(const std::map<std::string, Element>& db, std::string singular, std::string plural) const {
		boost::filesystem::fstream fout(baseDir / "db" / (plural + ".xml"), std::ios::out | std::ios::trunc);
		
		fout << "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
			 << "<" << plural << ">\n";
		
		for (ConstDbIterator it = db.begin(); it != db.end(); ++it)
			fout << "\t<" << singular << ">\n"
				 << "\t\t<name>" << it->second.name << "</name>\n"
				 << "\t\t<description>" << it->second.description << "</description>\n"
				 << "\t\t<filename>" << it->second.filename << "</filename>\n"
				 << "\t</" << singular << ">\n";
		
		fout << "</" << plural << ">\n";
		fout.flush();
		fout.close();
	}
	
	void Database::loadScriptActions() {
		boost::filesystem::fstream fin(baseDir / "db" / "scripts", std::ios::in);
		std::string line;
		int count = 0;
		while (std::getline(fin, line)) {
			std::istringstream sin(line);
			std::string word;

			ScriptAction* action = new ScriptAction(count);
			
			while (sin >> word) {
				if (word == ScriptField::FIELD_TOKEN) {
					ScriptField field;
					fin >> word;
					if (word == "int") {
						field << ScriptField::INT;
						fin >> word;
						field << atoi(word.c_str());
						fin >> word;
						field << atoi(word.c_str());
						fin.ignore(1000, '\n');
					} else if (word == "float") {
						field << ScriptField::FLOAT;
						fin >> word;
						field << atof(word.c_str());
						fin >> word;
						field << atof(word.c_str());
						fin.ignore(1000, '\n');
					} else if (word == "bool") {
						field << ScriptField::BOOL;
						fin.ignore(1000, '\n');
					} else if (word == "string") {
						field << ScriptField::STRING;
						fin.ignore(1000, '\n');
					} else if (word == "choice") {
						field << ScriptField::CHOICE;
						fin >> word;
						int numChoices = atoi(word.c_str());
						field << numChoices;
						fin.ignore(1000, '\n');
						for (int i = 0; i < numChoices; ++i) {
							std::getline(fin, word);
							field << word;	
						}
					}
					*action << field;
				} else {
					*action << word;
				}
			}
			scriptActions.push_back(action);
			++count;
		}
	}
}

