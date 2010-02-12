/*
 * o2d -- a 2D game engine -- Script entry implementation
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

#include "ScriptEntry.h"

#include "Exception.h"

namespace o2d {

	ScriptEntry::ScriptEntry(const ScriptAction& action) : action(action) {
		
	}
	
	ScriptEntry::~ScriptEntry() {
		for (int i = 0; i < data.size(); ++i) {
			switch (action[i].getType()) {
			case ScriptField::INT:
			case ScriptField::CHOICE:
				delete data[i].n;
				break;
			case ScriptField::FLOAT:
				delete data[i].f;
				break;
			case ScriptField::BOOL:
				delete data[i].b;
				break;
			case ScriptField::STRING:
				delete data[i].s;
				break;	
			}
		}
	}

	ScriptEntry& ScriptEntry::operator <<(std::string s) {
		if (data.size() >= action.size())
			throw Exception("Error: attempt to push too push data into script entry.");
			
		// Validate input
		int loc = data.size();
		Data d;
		switch (action[loc].getType()) {
		case ScriptField::INT:
		case ScriptField::CHOICE:
			d.n = new int(atoi(s.c_str()));
			if (!action[loc].validate(*d.n)) {
				delete d.n;
				throw Exception("Invalid data passed to script.");
			}
			break;
		case ScriptField::FLOAT:
			d.f = new double(atof(s.c_str()));
			if (!action[loc].validate(*d.f)) {
				delete d.f;
				throw Exception("Invalid data passed to script.");
			}
			break;
		case ScriptField::BOOL:
			d.b = new bool(atoi(s.c_str()) != 0);
			break;
		case ScriptField::STRING:
			d.s = new std::string(s);
			break;
		default:
			throw Exception("Something strange occured while feeding data to a new script entry.");	
		}
		data.push_back(d);
		return *this;
	}
	
	bool ScriptEntry::valid() const {
		return data.size() == action.size();
	}
	
	const ScriptAction::Type ScriptEntry::getType() const {
		return action.getType();
	}
	
	const ScriptEntry::Data ScriptEntry::operator[](int i) const {
		return data[i];
	}
	
	const unsigned int ScriptEntry::size() const {
		return data.size();	
	}
	
	const std::string ScriptEntry::string() const {
		return action.string() + "\nwith some data";
	}	
}
