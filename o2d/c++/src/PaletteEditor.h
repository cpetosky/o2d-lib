/*
 * o2d -- a 2D game engine -- Palette editor definition
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

#ifndef PALETTEEDITOR_H_
#define PALETTEEDITOR_H_

#include <gtkmm/box.h>
#include <gtkmm/button.h>
#include <gtkmm/togglebutton.h>
#include <gtkmm/label.h>
#include <gtkmm/filechooserwidget.h>
#include <gtkmm/scrolledwindow.h>

#include <boost/filesystem/path.hpp>

#include "PaletteViewer.h"
#include "ImageLoader.h"

namespace o2d {
	/**
	 * The palette editor is a collection of widgets that allow the editing
	 * of a palette.
	 * 
	 * Currently, the palette editor interacts directly with the filesystem
	 * to see what tiles are available for use in a palette. This should be
	 * changed to go through the database eventually.
	 */
	class PaletteEditor : public Gtk::HBox {
	public:
		PaletteEditor(PaletteViewer* palette, boost::filesystem::path baseDir, ImageLoader& il);
		virtual ~PaletteEditor();
		
		PaletteViewer* getPalette();
		
	private:
		void fileActivated();
		
		Gtk::VBox boxLeft;
		Gtk::VBox boxRight;
		PaletteViewer* palViewer;
		Gtk::HBox displayButtons;
		Gtk::Button normal, passability, priority;
		Gtk::ToggleButton transparency;
		Gtk::Label status;
		Gtk::HBox tileBox;
		Gtk::FileChooserWidget fileChooser;
		Gtk::Button importOne, importMany, load, save;
		Gtk::HBox buttonBox;
		Gtk::ScrolledWindow sPal;
		
		boost::filesystem::path baseDir;
		ImageLoader& il;
		
	};
}
#endif /*PALETTEEDITOR_H_*/
