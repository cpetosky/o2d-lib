/*
 * o2d -- a 2D game engine -- Script definition
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
 
#ifndef SCRIPT_H_
#define SCRIPT_H_

#include <fstream>
#include <string>

#include "ImageLoader.h"
#include "ScriptEntry.h"

namespace o2d {
	class Database;
	
	/**
	 * The script class holds the internal represenation of a single o2dscript.
	 */
	class Script {
	public:
		enum Type {
			INIT = 0, IDLE, TIMER
		};
		
		Script();
		Script(std::fstream& doc, ImageLoader& imageLoader, Database* db);
		
		std::string getName() const;
		
		const ScriptEntry& operator [](int i) const;
		const int size() const;
		virtual ~Script();
	private:
		std::string name;
		Type type;
		std::vector<ScriptEntry*> entries;
	};

}

#endif /*SCRIPT_H_*/
