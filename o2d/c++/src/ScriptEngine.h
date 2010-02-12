/*
 * o2d -- a 2D game engine -- Script engine definition
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

#ifndef SCRIPTENGINE_H_
#define SCRIPTENGINE_H_

#include <vector>
#include <map>

#include "Database.h"
#include "Script.h"
#include "Entity.h"

namespace o2d {
	class Game;
	
	/**
	 * The script engine class handles loading and running of o2dscripts.
	 */
	class ScriptEngine {
	public:
		ScriptEngine(Game& game, Database& db);
		virtual ~ScriptEngine();
		
		void track(Entity* entity);
		
		void run();
	private:
		typedef std::map<Script::Type, std::map<Entity*, Script*> > EntityScriptDB;
		Game& game;
		Database& db;
		EntityScriptDB entityScripts;
		
		void run(Script* script, Entity* entity);
		
		// Scripting hooks
		void doWalkToTile(int x, int y, Entity* entity);
		void doSetTimer(int time, Entity* entity);
		void doPrint(std::string message);
		void doRotateLeft(Entity* entity);
		void doRotateRight(Entity* entity);
		void doSetMoving(bool move, Entity* entity);
		void doMoveToTile(int x, int y, Entity* entity);
		
	};

}

#endif /*SCRIPTENGINE_H_*/
