/*
 * o2d -- a 2D game engine -- Editor definition
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

#ifndef EDITOR_H_
#define EDITOR_H_
#include <gtkmm.h>
#include <string>
#include <map>
#include <boost/filesystem/path.hpp>

#include "Palette.h"
#include "PaletteViewer.h"
#include "MapViewer.h"
#include "GTKImageLoader.h"
#include "GTKTileBlitter.h"
#include "Database.h"

namespace o2d {
	/**
	 * The editor is the GUI interface that allows a user to create his game.
	 */
	class Editor : public Gtk::Window {
	public:
		Editor();
		virtual ~Editor();
		
		enum DrawMode {
			PENCIL, RECTANGLE, ELLIPSE, FILL
		};
		
		static const std::string TITLE;
		static const std::string VERSION;
		
	protected:
		/**
		 * Saves the project before allowing the main window to be hidden.
		 */
		void on_hide();
		
	private:
		// Project data
		Database* db;
		
		// XML
		xmlpp::DomParser parser;
	
		// GUI widgets
		DrawMode drawMode;
		Gtk::VBox vBox;
		Gtk::HBox hBox;
		Gtk::ScrolledWindow palScroller;
		Gtk::ScrolledWindow mapScroller;
		Gtk::Statusbar statusbar;
		Gtk::VPaned leftPaned;
		Gtk::ListViewText mapList;
		PaletteViewer* palViewer;
		MapViewer* mapViewer;
		
		// Actions
		Glib::RefPtr<Gtk::Action> aNewProject, aOpenProject, aSaveProject, aQuit;
		Glib::RefPtr<Gtk::Action> aNew, aSave;
		Glib::RefPtr<Gtk::Action> aPencil, aRectangle, aEllipse, aFill;
		Glib::RefPtr<Gtk::Action> aScale100, aScale50, aScale25;
		Glib::RefPtr<Gtk::Action> aLayerBottom, aLayerMiddle, aLayerTop, aLayerEvent;
		
		Glib::RefPtr<Gtk::UIManager> uiManager;
		
		GTKImageLoader imageLoader;
		
		/**
		 * Sets map as the active map, removing the previous (if any)
		 */
		void setMap(Map& m);
		
		/**
		 * Wraps a MapViewer in a Gtk::ScrolledWindow to facilitate adding it to the map pane.
		 */
		Gtk::ScrolledWindow* makeMapScroller(MapViewer* m);
		
		/**
		 * Creates and initializes the actions that control the menu bar and tool bar.
		 */
		void addMenuBar(Gtk::VBox& vBox);
		
		/**
		 * Adds the specified palette to the palette scroller, replacing
		 * the previous palette.
		 */	
		void addPalette(Palette& p);
			
		// GUI utilities

		/**
		 * Makes a folder chooser, for making new projects or opening existing ones.
		 */
		Gtk::FileChooserDialog* makeFolderChooser(std::string title);
		
		// Action handlers

		/**
		 * Creates a new project in a directory specified by the user via a dialog
		 * box.
		 */
		void onNewProject();
		
		/**
		 * Opens a project specified by a file selection dialog box.
		 */
		void onOpenProject();
		
		/**
		 * Saves the current project and all changes.
		 */		
		void onSaveProject();
		
		/**
		 * Creates a new map and appends it to the map notebook. This signal handler
		 * creates and displays a dialog from which the specs for the new map are
		 * gathered.
		 */
		void onNewMap();
		
		/**
		 * Writes the current map to its file.
		 */	
		void onSaveMap();
		
		/**
		 * Closes the main window, ending the program.
		 */
		void onQuit();
		
		/**
		 * Launch the palette editor.
		 */
		void onPaletteEditor();
		
		/**
		 * Shows an about dialog.
		 */
		void onAbout();
		
		/**
		 * Changes the layer of the current map.
		 */
		void changeLayer(MapViewer::Layer layer);
		
		// GUI handlers
		void mapChange();
		
		// Draw handlers
		
		/**
		 * Replaces current tile with one from the palette.
		 */	
		bool mapMousePressed(GdkEventButton* event);
		
		/**
		 * Applies current draw tool to all tiles drug over.
		 */
		bool mapMouseDragged(GdkEventMotion* event);
		
		/**
		 * Apply selected texture from palette to the map.
		 */	
		void drawTexture(int x, int y);
	};
}
#endif /*EDITOR_H_*/
