/*
 * o2d -- a 2D game engine -- Script entry definition
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

#ifndef SCRIPTENTRY_H_
#define SCRIPTENTRY_H_

#include "ScriptAction.h"

namespace o2d {

	/**
	 * A script entry holds a set of data that meets the restrictions
	 * for input to a script action.
	 */
	class ScriptEntry {
	public:
		union Data {
			int* n;
			double* f;
			bool* b;
			std::string* s;
		};
		ScriptEntry(const ScriptAction& action);
		virtual ~ScriptEntry();
		
		ScriptEntry& operator <<(std::string s);
		bool valid() const;
		
		const ScriptAction::Type getType() const;
		const Data operator[](int i) const;
		const unsigned int size() const;
		const std::string string() const;
	
	private:
		const ScriptAction& action;
		std::vector<Data> data;
	};

}

#endif /*SCRIPTENTRY_H_*/
