/*
 * o2d project -- a 2D game engine -- Palette editor implementation
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

#include "PaletteEditor.h"
#include <iostream>

namespace o2d {
	PaletteEditor::PaletteEditor(PaletteViewer* palette, boost::filesystem::path b, ImageLoader& il)
			: palViewer(palette), normal("Normal"), passability("Passability"), priority("Priority"), 
			transparency("Transparency"), status("Palette"), fileChooser(Gtk::FILE_CHOOSER_ACTION_OPEN),
			importOne("Import Image as Tile"), importMany("Import and Tile Image"),
			load("Load Palette"), save("Save Palette"), baseDir(b / "gfx" / "textures"), il(il) {
		sPal.add(*palette);
		boxLeft.pack_start(sPal, true, true, 0);
		
		displayButtons.pack_start(normal);
		displayButtons.pack_start(passability);
		displayButtons.pack_start(priority);
		displayButtons.pack_start(transparency);
		
		boxLeft.pack_start(displayButtons, false, false, 0);
		
		boxRight.pack_start(status, false, false, 0);
		
		tileBox.pack_start(fileChooser);
		boxRight.pack_start(tileBox, true, true, 0);
		
	//	buttonBox.pack_start(importOne);
	//	buttonBox.pack_start(importMany);
	//	buttonBox.pack_start(load);
	//	buttonBox.pack_start(save);
		
	//	boxRight.pack_start(buttonBox, false, false, 0);
		
		pack_start(boxLeft, false, false, 0);
		pack_start(boxRight);
		
		// Set up file chooser
		fileChooser.set_current_folder(baseDir.string());
		fileChooser.set_select_multiple(false);
		fileChooser.signal_file_activated().connect(sigc::mem_fun(*this, &PaletteEditor::fileActivated));
	}
	
	PaletteEditor::~PaletteEditor() { }
	
	void PaletteEditor::fileActivated() {
		std::string selFile = fileChooser.get_filename();
		if (selFile.find(baseDir.string()) == std::string::npos)
			return;
		std::cerr << selFile << " -> ";
		selFile = selFile.substr(baseDir.string().length() + 1);
		std::cerr << selFile << std::endl;
		if (!selFile.empty()) {
			palViewer->enterEditMode(Texture::create(il, selFile));
		}
	}
	
	
	PaletteViewer* PaletteEditor::getPalette() {
		return palViewer;
	}
}
