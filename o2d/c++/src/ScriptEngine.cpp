/*
 * o2d -- a 2D game engine -- Script engine implementation
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

#include "ScriptEngine.h"
#include "Game.h"

#include <iostream>

namespace o2d {

	ScriptEngine::ScriptEngine(Game& game, Database& db) : 
			game(game), db(db) {
	}
	
	ScriptEngine::~ScriptEngine() {
	}
	
	void ScriptEngine::track(Entity* entity) {
		if (!entity->getInitScript().empty()) {
			entityScripts[Script::INIT][entity] = &db.getScript(entity->getInitScript());
			run(entityScripts[Script::INIT][entity], entity);
		}
		if (!entity->getIdleScript().empty()) {
			entityScripts[Script::IDLE][entity] = &db.getScript(entity->getIdleScript());
		}
		if (!entity->getTimerScript().empty()) {
			entityScripts[Script::TIMER][entity] = &db.getScript(entity->getTimerScript());
		}		
	}

	void ScriptEngine::run() {
		for (std::vector<Entity*>::iterator it = game.entitiesBegin(); it != game.entitiesEnd(); ++it) {
			Entity* e = *it;
			if (e->getTimer() == 0) {
				e->setTimer(-1);
				run(entityScripts[Script::TIMER][e], e);
			}
			else if (!e->isMoving())
				run(entityScripts[Script::IDLE][e], e);
		}
	}
	
	void ScriptEngine::run(Script* script, Entity* entity) {
		if (script == NULL || entity == NULL)
			return;
		for (int i = 0; i < script->size(); ++i) {
			const ScriptEntry& entry = (*script)[i];

			switch(entry.getType()) {
			case ScriptAction::WALK_TO_TILE:
				doWalkToTile(*entry[0].n, *entry[1].n, entity);
				break;
			case ScriptAction::SET_TIMER:
				doSetTimer(*entry[0].n, entity);
				break;
			case ScriptAction::PRINT:
				doPrint(*entry[0].s);
				break;
			case ScriptAction::ROTATE_LEFT:
				doRotateLeft(entity);
				break;
			case ScriptAction::ROTATE_RIGHT:
				doRotateRight(entity);
				break;
			case ScriptAction::SET_MOVING:
				doSetMoving(*entry[0].b, entity);
				break;
			case ScriptAction::MOVE_TO_TILE:
				doMoveToTile(*entry[0].n, *entry[1].n, entity);
				break;
			}
		}
	}

	void ScriptEngine::doWalkToTile(int x, int y, Entity* entity) {
		entity->walkToTile(x, y);
	}

	void ScriptEngine::doSetTimer(int time, Entity* entity) {
		entity->setTimer(time);
	}
	
	void ScriptEngine::doPrint(std::string message) {
		std::cout << message << std::endl;
	}
	
	void ScriptEngine::doRotateLeft(Entity* entity) {
		entity->rotateLeft();
	}
	
	void ScriptEngine::doRotateRight(Entity* entity) {
		entity->rotateRight();
	}
	
	void ScriptEngine::doSetMoving(bool move, Entity* entity) {
		entity->setMoving(move);
	}
	
	void ScriptEngine::doMoveToTile(int x, int y, Entity* entity) {
		entity->moveToTile(x, y);
	}

}
