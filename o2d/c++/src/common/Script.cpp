/*
 * o2d -- a 2D game engine -- Script implementation
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
 
#include "Script.h"

#include "Exception.h"
#include "Database.h"

namespace o2d {

	Script::Script()
	{
	}
	
	Script::Script(std::fstream& fin, ImageLoader& imageLoader, Database* db) {
		int n;
		getline(fin, name);
		fin >> n;
		type = Type(n);
		int actionType;
		while (fin >> actionType) {
			ScriptEntry* entry = new ScriptEntry(db->getScriptAction(actionType));
			std::string token;
			for (int i = 0; i < db->getScriptAction(actionType).size(); ++i) {
				fin >> token;
				*entry << token;
			}
			if (!entry->valid())
				throw Exception("Invalid script read.");
			else
				entries.push_back(entry);
		}
	}
	
	Script::~Script() {
		for (int i = 0; i < entries.size(); ++i) {
			delete entries[i];
		}
	}
	
	std::string Script::getName() const {
		return name;
	}

	const ScriptEntry& Script::operator [](int i) const {
		return *entries[i];	
	}
	
	const int Script::size() const {
		return entries.size();	
	}
}
