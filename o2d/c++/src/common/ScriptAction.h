/*
 * o2d -- a 2D game engine -- Script action implementation
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
 
#ifndef SCRIPTACTION_H_
#define SCRIPTACTION_H_

#include <set>
#include <string>
#include <vector>

#include "ScriptField.h"

namespace o2d {

	/**
	 * A script action is a generic template for a line of script.
	 */
	class ScriptAction {
	public:
		enum Type {
			WALK_TO_TILE = 0, SET_TIMER, PRINT, ROTATE_LEFT, ROTATE_RIGHT, SET_MOVING,
			MOVE_TO_TILE
		};
		
		ScriptAction(int n);
		ScriptAction(Type type);
		virtual ~ScriptAction();
		
		ScriptAction& operator <<(std::string s);
		ScriptAction& operator <<(const ScriptField& field);
		
		const ScriptField& operator [](unsigned int n) const;
		
		unsigned int size() const;
		std::string string() const;
		
		const Type getType() const;
		
	private:
		Type type;
		
		struct Token {
			bool is_field;
			union {
				ScriptField* field;
				std::string* string;
			};
			
			Token(ScriptField field) : is_field(true) {
				this->field = new ScriptField(field);
			}
			
			Token(std::string string) : is_field(false) {
				this->string = new std::string(string);
			} 	
		};
		
		std::vector<Token> tokens;
		unsigned int fieldCount;
	};
	
	}

#endif /*SCRIPTACTION_H_*/
