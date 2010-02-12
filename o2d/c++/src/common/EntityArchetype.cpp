/*
 * o2d -- a 2D game engine -- Entity archetype implementation
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

#include "EntityArchetype.h"

#include "Entity.h"
#include "Database.h"

namespace o2d {
	EntityArchetype::EntityArchetype(xmlpp::Document* doc, ImageLoader& loader, Database* db) {
		const xmlpp::Element* root = dynamic_cast<const xmlpp::Element*>(doc->get_root_node());
			
		name = dynamic_cast<const xmlpp::Element*>(root->find("name")[0])->get_child_text()->get_content();
		width = atoi(dynamic_cast<const xmlpp::Element*>(root->find("width")[0])->get_child_text()->get_content().c_str());
		height = atoi(dynamic_cast<const xmlpp::Element*>(root->find("height")[0])->get_child_text()->get_content().c_str());
		frames = atoi(dynamic_cast<const xmlpp::Element*>(root->find("frames")[0])->get_child_text()->get_content().c_str());
		std::string imgName = dynamic_cast<const xmlpp::Element*>(root->find("image")[0])->get_child_text()->get_content();
		
		if (!root->find("scripts").empty()) {
			const xmlpp::Element* scripts = dynamic_cast<const xmlpp::Element*>(root->find("scripts")[0]);
			if (!scripts->find("idle").empty())
				idleScript = dynamic_cast<const xmlpp::Element*>(scripts->find("idle")[0])->get_child_text()->get_content();
			if (!scripts->find("timer").empty())
				timerScript = dynamic_cast<const xmlpp::Element*>(scripts->find("timer")[0])->get_child_text()->get_content();
			if (!scripts->find("init").empty())
				initScript = dynamic_cast<const xmlpp::Element*>(scripts->find("init")[0])->get_child_text()->get_content();
		}
		
		std::vector<xmlpp::Node*> modeNodes = root->find("modes");
		for (unsigned int i = 0; i < modeNodes.size(); ++i) {
			modes.push_back(dynamic_cast<const xmlpp::Element*>(modeNodes[i])->get_child_text()->get_content());
		}
		
		image = loader.loadFromFile("gfx/entities/" + imgName);
	}
	
	EntityArchetype::EntityArchetype(const EntityArchetype& arch) :
			width(arch.width), height(arch.height), name(arch.name), frames(arch.frames),
			timerScript(arch.timerScript), initScript(arch.initScript), idleScript(arch.idleScript),
			image(arch.image) {
	
		modes.resize(arch.modes.size());
		for (unsigned int i = 0; i < arch.modes.size(); ++i) 
			modes[i] = arch.modes[i];			
	}

	int EntityArchetype::getWidth() const {
		return width;
	}

	int EntityArchetype::getHeight() const {
		return height;
	}	
	
	std::string EntityArchetype::getName() const {
		return name;
	}
	
	std::string EntityArchetype::getTimerScript() const {
		return timerScript;
	}

	std::string EntityArchetype::getInitScript() const {
		return initScript;
	}

	std::string EntityArchetype::getIdleScript() const {
		return idleScript;
	}
	
	Image* EntityArchetype::getImage() const {
		return image;
	}
	
	Entity* EntityArchetype::instance(const Map& map, int x, int y) const {
		return new Entity(*this, map, x, y);
	}
}
