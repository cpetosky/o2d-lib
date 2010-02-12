/*
 * o2d -- a 2D game engine -- Script field definition
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

#ifndef SCRIPTFIELD_H_
#define SCRIPTFIELD_H_

#include <string>
#include <vector>
#include <ostream>

namespace o2d {

	class ScriptField {
	public:
		enum Type {
			NONE = 0, STRING, BOOL, INT, FLOAT, CHOICE
		};
		
		static const std::string FIELD_TOKEN;
		
		ScriptField();
		virtual ~ScriptField();
		
		ScriptField& operator <<(Type t);
		ScriptField& operator <<(int n);
		ScriptField& operator <<(double f);
		ScriptField& operator <<(std::string s);
		
		Type getType() const;
		
		bool validate(int n) const;
		bool validate(double f) const;
		
		friend std::ostream& operator <<(std::ostream& out, const ScriptField& field);
		
	private:		
		Type type;
		int nMin;
		double fMin;		
		int nMax;
		double fMax;
		int numChoices;
		std::vector<std::string> choices;
		
		unsigned int spot;
	};

}

#endif /*SCRIPTFIELD_H_*/
