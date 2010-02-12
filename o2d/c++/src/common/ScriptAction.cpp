/*
 * o2d -- a 2D game engine -- Script action definition
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
 
#include "ScriptAction.h"

#include <sstream>

#include "Exception.h"

namespace o2d {

	ScriptAction::ScriptAction(int n) : type(Type(n)), fieldCount(0) {
	}

	ScriptAction::ScriptAction(Type type) : type(type), fieldCount(0) {
	}
	
	ScriptAction::~ScriptAction() {
		for (int i = 0; i < tokens.size(); ++i) {
			if (tokens[i].is_field) {
				delete tokens[i].field;
			} else {
				delete tokens[i].string;
			}
		}
	}
	
	ScriptAction& ScriptAction::operator <<(std::string s) {
		if (tokens.empty()) {
			tokens.push_back(Token(s));
		} else {
			int last = tokens.size() - 1;
			// Check if the last token was also a string
			if (!tokens[last].is_field) {
				// Append string to last token
				std::string old = *tokens[last].string;
				delete tokens[last].string;
				tokens[last].string = new std::string(old + " " + s);
			} else {
				// Add new token
				tokens.push_back(Token(s));	
			}	
		}
		return *this;
	}
	
	ScriptAction& ScriptAction::operator <<(const ScriptField& field) {
		tokens.push_back(Token(field));
		++fieldCount;
		return *this;
	}
	
	const ScriptField& ScriptAction::operator [](unsigned int n) const {
		if (n >= fieldCount)
			throw Exception("Request for field of script action out of bounds.");
			
		unsigned int c = 0;
		for (unsigned int i = 0; i < tokens.size(); ++i) {
			if (tokens[i].is_field) {
				if (c == n) {
					return *tokens[i].field;
				} else {
					++c;
				}	
			}
		}
		throw Exception("Request for field of script action out of bounds.");
	}
	
	unsigned int ScriptAction::size() const {
		return fieldCount;
	}
	
	std::string ScriptAction::string() const {
		std::ostringstream out;
		out << "ScriptAction:";
		for (int i = 0; i < tokens.size(); ++i) {
			out << "\n\tEntry " << i << ": ";
			if (tokens[i].is_field) {
				out << *tokens[i].field;
			} else {
				out << *tokens[i].string;
			}
		}
		return out.str();
	}
	
	const ScriptAction::Type ScriptAction::getType() const {
		return type;
	}

}
