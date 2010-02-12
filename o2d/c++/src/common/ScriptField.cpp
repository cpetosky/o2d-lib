/*
 * o2d -- a 2D game engine -- Script field implementation
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
 
#include "ScriptField.h"

#include "Exception.h"

namespace o2d {

	const std::string ScriptField::FIELD_TOKEN = "~";
	ScriptField::ScriptField() : type(NONE) {
	}
	
	ScriptField::~ScriptField()	{ }
	
	ScriptField& ScriptField::operator <<(Type t) {
		if (type != NONE)
			throw Exception("Attempt to change the type of an existing script field!");
		if (t == NONE)
			throw Exception("Attempt to change the type of a script field to NONE!");
		type = t;
		spot = 0;
		return *this;
	}
	
	ScriptField& ScriptField::operator <<(int n) {
		switch (type) {
		case STRING:
		case BOOL:
		case NONE:
		case FLOAT:
			throw Exception("Invalid integer given to script field!");
		case INT:
			if (spot == 0)
				nMin = n;
			else if (spot == 1)
				nMax = n;
			else
				throw Exception("Tried to pass extra int parameter to int script field!");
			break;
		case CHOICE:
			if (spot == 0)
				numChoices = n;
			else
				throw Exception("Tried to pass extra int parameter to choice script field!");
			break;
		}
		
		++spot;
		return *this;
	}
	
	ScriptField& ScriptField::operator <<(double f) {
		if (type != FLOAT)
			throw Exception("Tried to pass float parameter to non-float script field!");
		
		if (spot == 0)
			fMin = f;
		else if (spot == 1)
			fMax = f;
		else
			throw Exception("Tried to pass extra parameter to float script field!");
		
		++spot;
		return *this;
	}
	
	ScriptField& ScriptField::operator <<(std::string s) {
		if (type != CHOICE)
			throw Exception("Tried to pass string parameter to non-string script field!");
		
		if (spot == 0)
			throw Exception("String passed to choice script field while number of choices undefined!");
			
		if (choices.size() >= numChoices)
			throw Exception("Extra string passed to choice script field!");
		
		choices.push_back(s);
		return *this;	
	}
	
	ScriptField::Type ScriptField::getType() const {
		return type;
	}


	bool ScriptField::validate(int n) const {
		switch (type) {
		case STRING:
		case BOOL:
		case FLOAT:
		case NONE:
			throw Exception("Attempted to validate an integer in a non-integral field.");
		case INT:
			return nMin <= n && n <= nMax;
		case CHOICE:
			return 0 <= n && n <= numChoices;	
		}
		return false;
	}
	
	
	bool ScriptField::validate(double f) const {
		if (type != FLOAT)
			throw Exception("Attempted to validate a float in a non-floating-point field.");
		else
			return fMin <= f && f <= fMax;
	}
	
	std::ostream& operator <<(std::ostream& out, const ScriptField& field) {
		out << "ScriptField: ";
		
		switch (field.type) {
		case ScriptField::NONE:
			out << "Type = NONE";
			break;
		case ScriptField::INT:
			out << "Type = INT, min ";
			if (field.spot == 0)
				out << "& max undefined";
			else {
				out << "= " << field.nMin << ", max ";
				if (field.spot == 1)
					out << "undefined";
				else
					out << "= " << field.nMax;
			}
			break;			
		case ScriptField::FLOAT:
			out << "Type = FLOAT, min ";
			if (field.spot == 0)
				out << "& max undefined";
			else {
				out << "= " << field.fMin << ", max ";
				if (field.spot == 1)
					out << "undefined";
				else
					out << "= " << field.fMax;
			}
			break;			
		case ScriptField::STRING:
			out << "Type = STRING";
			break;
		case ScriptField::BOOL:
			out << "Type = BOOL";
			break;
		case ScriptField::CHOICE:
			out << "Type = CHOICE";
			if (field.spot == 0)
				out << ", choices undefined";
			else {
				for (int i = 0; i < field.numChoices; ++i) {
					out << "\n\tChoice " << i << ": ";
					if (i >= field.choices.size())
						out << "undefined";
					else
						out << field.choices[i];
				}
			}
		}
		return out;
	}
}
