/*
 * o2d -- a 2D game engine -- Editor implementation
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

#include "Editor.h"
#include <libxml++/libxml++.h>
#include "Map.h"
#include "Texture.h"
#include "MapViewer.h"
#include "PaletteEditor.h"
#include <sstream>

namespace o2d {
	/**
	 * Constants.
	 */
	const std::string Editor::TITLE = "o2d Editor";
	const std::string Editor::VERSION = "v0.0.3";
	
	Editor::Editor() : db(NULL), drawMode(PENCIL), vBox(false, 0), hBox(false, 0),
				mapList(1), mapViewer(NULL), imageLoader(".") {
		set_title(TITLE + " " + VERSION);
		addMenuBar(vBox);
		add(vBox);
		// Configure XML parser	
		parser.set_substitute_entities(); //We just want the text to be resolved/unescaped automatically.
	
		// Configure palette scrolling window
		palScroller.set_policy(Gtk::POLICY_NEVER, Gtk::POLICY_ALWAYS);
			
		// Configure map scroller
		mapScroller.set_size_request(500, 500);
		
		// Configure map list
		mapList.set_column_title(0, "Maps");
		mapList.signal_cursor_changed().connect(sigc::mem_fun(*this, &Editor::mapChange));
		
		vBox.pack_start(hBox, true, true, 0);
		leftPaned.add1(palScroller);
		leftPaned.add2(mapList);
		hBox.pack_start(leftPaned, false, false, 0);
		hBox.pack_start(mapScroller, true, true, 0);
		
		statusbar.push("Please create or open a project to begin.");
		vBox.pack_start(statusbar, false, false, 0);
		
		show_all_children();
		palScroller.hide();
		mapScroller.hide();
		mapList.hide();
	}
	
	Editor::~Editor() {
		if (palViewer != NULL)
			delete palViewer;
	}
	
	Gtk::ScrolledWindow* Editor::makeMapScroller(MapViewer* m) {
		Gtk::ScrolledWindow* w = new Gtk::ScrolledWindow();
		w->add(*m);
		w->show();
		return w;
	}
	
	void Editor::addMenuBar(Gtk::VBox& vBox) {
		
		Glib::RefPtr<Gtk::ActionGroup> refActionGroup = Gtk::ActionGroup::create();
		
		Gtk::RadioButtonGroup drawGroup, scaleGroup, layerGroup;
		
		refActionGroup->add(Gtk::Action::create("FileMenu", "_File"));
		
		aNewProject = Gtk::Action::create("New Project", Gtk::Stock::NEW, "New Project...");
		refActionGroup->add(aNewProject, sigc::mem_fun(*this, &Editor::onNewProject));
		
		aOpenProject = Gtk::Action::create("Open Project", Gtk::Stock::OPEN, "Open Project...");
		refActionGroup->add(aOpenProject, sigc::mem_fun(*this, &Editor::onOpenProject));
		
		aSaveProject = Gtk::Action::create("Save Project", Gtk::Stock::SAVE, "Save Project");
		refActionGroup->add(aSaveProject, sigc::mem_fun(*this, &Editor::onSaveProject));
		aSaveProject->set_sensitive(false);
	
		aQuit = Gtk::Action::create("Quit", Gtk::Stock::QUIT);
		refActionGroup->add(aQuit, sigc::mem_fun(*this, &Editor::onQuit));
	
		refActionGroup->add(Gtk::Action::create("MapMenu", "_Map"));
		
		aNew = Gtk::Action::create("New", "_New Map...");
		refActionGroup->add(aNew, sigc::mem_fun(*this, &Editor::onNewMap));
		
		aSave = Gtk::Action::create("Save", "_Save Map");
		refActionGroup->add(aSave, sigc::mem_fun(*this, &Editor::onSaveMap));
		aSave->set_sensitive(false);
		
		refActionGroup->add(Gtk::Action::create("DrawMenu", "_Draw"));
		
		aPencil = Gtk::RadioAction::create(drawGroup, "Pencil", "Pencil");
		refActionGroup->add(aPencil);
		
		aRectangle = Gtk::RadioAction::create(drawGroup, "Rectangle", "Rectangle");
		refActionGroup->add(aRectangle);
		aRectangle->set_sensitive(false);
		
		aEllipse = Gtk::RadioAction::create(drawGroup, "Ellipse", "Ellipse");
		refActionGroup->add(aEllipse);
		aEllipse->set_sensitive(false);
		
		aFill = Gtk::RadioAction::create(drawGroup, "Fill", "Fill");
		refActionGroup->add(aFill);
		aFill->set_sensitive(false);
		
		refActionGroup->add(Gtk::Action::create("ScaleMenu", "_Scale"));
		
		aScale100 = Gtk::RadioAction::create(scaleGroup, "100%", "100%");
		refActionGroup->add(aScale100);
		
		aScale50 = Gtk::RadioAction::create(scaleGroup, "50%", "50%");
		refActionGroup->add(aScale50);
		aScale50->set_sensitive(false);
		
		aScale25 = Gtk::RadioAction::create(scaleGroup, "25%", "25%");
		refActionGroup->add(aScale25);
		aScale25->set_sensitive(false);
		
		refActionGroup->add(Gtk::Action::create("LayerMenu", "_Layer"));
		
		aLayerBottom = Gtk::RadioAction::create(layerGroup, "Bottom", "Bottom");
		refActionGroup->add(aLayerBottom,
				sigc::bind<MapViewer::Layer>(sigc::mem_fun(*this, &Editor::changeLayer), MapViewer::BOTTOM));
		aLayerBottom->set_sensitive(false);
		
		aLayerMiddle = Gtk::RadioAction::create(layerGroup, "Middle", "Middle");
		refActionGroup->add(aLayerMiddle,
				sigc::bind<MapViewer::Layer>(sigc::mem_fun(*this, &Editor::changeLayer), MapViewer::MIDDLE));
		aLayerMiddle->set_sensitive(false);
				
		aLayerTop = Gtk::RadioAction::create(layerGroup, "Top", "Top");
		refActionGroup->add(aLayerTop,
				sigc::bind<MapViewer::Layer>(sigc::mem_fun(*this, &Editor::changeLayer), MapViewer::TOP));
		aLayerTop->set_sensitive(false);
		
		aLayerEvent = Gtk::RadioAction::create(layerGroup, "Event", "Event");
		refActionGroup->add(aLayerEvent,
				sigc::bind<MapViewer::Layer>(sigc::mem_fun(*this, &Editor::changeLayer), MapViewer::EVENT));
		aLayerEvent->set_sensitive(false);
				
		refActionGroup->add(Gtk::Action::create("ToolsMenu", "_Tools"));
		refActionGroup->add(Gtk::Action::create("Palette Editor", "_Palette Editor..."),
				sigc::mem_fun(*this, &Editor::onPaletteEditor));
		refActionGroup->add(Gtk::Action::create("HelpMenu", "_Help"));
		refActionGroup->add(Gtk::Action::create("About", Gtk::Stock::ABOUT),
				sigc::mem_fun(*this, &Editor::onAbout));	
		
		uiManager = Gtk::UIManager::create();
		uiManager->insert_action_group(refActionGroup);
		add_accel_group(uiManager->get_accel_group());
		
		Glib::ustring ui_info =
			"<ui>"
			"  <menubar name='MenuBar'>"
			"    <menu action='FileMenu'>"
			"      <menuitem action='New Project'/>"
			"      <menuitem action='Open Project'/>"
			"      <menuitem action='Save Project'/>"
			"      <separator/>"
			"      <menuitem action='Quit'/>"
			"    </menu>"
			"    <menu action='MapMenu'>"
			"      <menuitem action='New'/>"
			"      <menuitem action='Save'/>"
			"    </menu>"
			"    <menu action='DrawMenu'>"
			"      <menuitem action='Pencil'/>"
			"      <menuitem action='Rectangle'/>"
			"      <menuitem action='Ellipse'/>"
			"      <menuitem action='Fill'/>"
			"    </menu>"
			"    <menu action='ScaleMenu'>"
			"      <menuitem action='100%'/>"
			"      <menuitem action='50%'/>"
			"      <menuitem action='25%'/>"
			"    </menu>"
			"    <menu action='LayerMenu'>"
			"      <menuitem action='Bottom'/>"
			"      <menuitem action='Middle'/>"
			"      <menuitem action='Top'/>"
			"      <menuitem action='Event'/>"
			"    </menu>"
			"    <menu action='ToolsMenu'>"
			"      <menuitem action='Palette Editor'/>"
			"    </menu>"
			"    <menu action='HelpMenu'>"
			"      <menuitem action='About'/>"
			"    </menu>"
			"  </menubar>"
			"  <toolbar name='ToolBar'>"
			"    <toolitem action='Pencil'/>"
			"    <toolitem action='Rectangle'/>"
			"    <toolitem action='Ellipse'/>"
			"    <toolitem action='Fill'/>"
			"    <separator/>"		
			"    <toolitem action='Bottom'/>"
			"    <toolitem action='Middle'/>"
			"    <toolitem action='Top'/>"
			"    <toolitem action='Event'/>"
			"  </toolbar>"
			"</ui>";
			
	
	    uiManager->add_ui_from_string(ui_info);
	    Gtk::Widget* widget = uiManager->get_widget("/MenuBar");
	    vBox.pack_start(*widget, false, false, 0);
	    widget->show();
	    widget = uiManager->get_widget("/ToolBar");
	    vBox.pack_start(*widget, false, false, 0);
	    widget->show();
	}
	
	Gtk::FileChooserDialog* Editor::makeFolderChooser(std::string title) {
		Gtk::FileChooserDialog* dialog = new
			Gtk::FileChooserDialog(*this, title, Gtk::FILE_CHOOSER_ACTION_SELECT_FOLDER);
	
		dialog->set_select_multiple(false);
	
		dialog->add_button(Gtk::Stock::OPEN, Gtk::RESPONSE_OK);
		dialog->add_button(Gtk::Stock::CANCEL, Gtk::RESPONSE_CANCEL);
	
		dialog->set_default_response(Gtk::RESPONSE_OK);
		
		Gtk::FileFilter filter;
		filter.set_name("Directories only");
		filter.add_pattern("");
		dialog->add_filter(filter);
		
		dialog->show_all_children();
		
		return dialog;
	}
	
	void Editor::addPalette(Palette& p) {
		palViewer = new PaletteViewer(p);
		palScroller.add(*palViewer); 
		
		Gtk::Widget* viewport = palScroller.get_child();
		viewport->set_size_request(p.getWidth() * Texture::TILESIZE + 2, Texture::TILESIZE * 10);
		palScroller.show();
	}
	
	void Editor::setMap(Map& m) {
		if (mapViewer != NULL) {
			onSaveMap();
			mapScroller.remove();
			mapViewer->get_parent()->remove(*mapViewer);
			delete mapViewer;
		}	
		
		mapViewer = new MapViewer(m);
		mapViewer->show();
		mapViewer->signal_button_press_event().connect(sigc::mem_fun(*this, &Editor::mapMousePressed)); 
		mapViewer->signal_motion_notify_event().connect(sigc::mem_fun(*this, &Editor::mapMouseDragged));
		mapScroller.add(*mapViewer);
		
		mapScroller.show();
		
		// Make sure actions are enabled
		aSave->set_sensitive();
		//aRectangle->set_sensitive();
		//aEllipse->set_sensitive();
		//aFill->set_sensitive();
		//aScale50->set_sensitive();
		//aScale25->set_sensitive();
		aLayerBottom->set_sensitive();
		aLayerMiddle->set_sensitive();
		aLayerTop->set_sensitive();
		//aLayerEvent->set_sensitive();		
	}
	
	void Editor::onNewProject() {
		Gtk::FileChooserDialog* dialog = makeFolderChooser("Choose empty directory for new project");
		
		int result = dialog->run();
		
		if (result == Gtk::RESPONSE_OK) {
			bool error = false;
			boost::filesystem::path dir(dialog->get_current_folder());
			
			// Make sure the directory is either empty or creatably empty.
			if (boost::filesystem::exists(dir)) {
				if (!boost::filesystem::is_empty(dir)) {
					error = true;
				}	
			} else {
				if (!boost::filesystem::create_directories(dir)) {
					error = true;
				}
			}
			
			if (error) {
				// Output an error message and end if above check failed
				Gtk::MessageDialog errDialog(*this, "Error: you must choose an empty directory.", false, Gtk::MESSAGE_ERROR);
				errDialog.run();
			} else {
				// Make project information dialog
				Gtk::Dialog inDialog("Enter project information", *this);
				Gtk::Label lTitle("Project title:");
				Gtk::Entry eTitle;
				Gtk::HBox hBox;
				hBox.pack_start(lTitle);
				hBox.pack_start(eTitle);
				inDialog.get_vbox()->pack_start(hBox);
				inDialog.add_button(Gtk::Stock::OPEN, Gtk::RESPONSE_OK);
				inDialog.add_button(Gtk::Stock::CANCEL, Gtk::RESPONSE_CANCEL);
				
				// Show information dialog
				inDialog.show_all_children();
				result = inDialog.run();
				
				if (result == Gtk::RESPONSE_OK) {
					// Directory exists and is empty -- write default project
					db = new Database(dir, imageLoader);
					db->setTitle(eTitle.get_text());
					
					// Set editor to use project data
					imageLoader.setBaseDirectory(db->getPath().string());
					
					// Make blank palette
					Palette p("Default", imageLoader);
					boost::filesystem::ofstream out(db->getPath() / "palettes" / "default.xml");
					out << p;
					db->addPalette("Default", "Default", "default.xml");
					
					addPalette(db->getPalette(db->getPaletteListBegin()->name));
					
					// Update statusbar
					statusbar.push(db->getTitle() + "  --  " + db->getPath().native_directory_string());
				}
			}
		}
		delete dialog;
	}
	
	void Editor::onOpenProject() {
		Gtk::FileChooserDialog* dialog = makeFolderChooser("Choose an o2d project directory");
		
		int result = dialog->run();
		
		if (result == Gtk::RESPONSE_OK) {
			boost::filesystem::path dir(dialog->get_current_folder());
			
			// Make sure the directory exists and contains an o2d project
			if (!(boost::filesystem::exists(dir) && boost::filesystem::exists(dir / Database::PROJECT_FILE_NAME))) {
				// Output an error message and end if above check failed
				Gtk::MessageDialog errDialog(*this, "Error: you must choose an o2d project directory.", false, Gtk::MESSAGE_ERROR);
				errDialog.run();
			} else {
				// Set editor to use project data
				db = new Database(dir, imageLoader);
				imageLoader.setBaseDirectory(db->getPath().string());
				
				// Update statusbar
				statusbar.push(db->getTitle() + "  --  " + db->getPath().native_directory_string());
	
				// Set up map list
				if (db->getMapCount() > 0) {
					for (Database::ConstListIterator it = db->getMapListBegin(); it != db->getMapListEnd(); ++it) {
						mapList.append_text(it->name);
					}
					mapList.show();
					mapList.set_cursor(Gtk::TreeModel::Path("0"));
				}
				// Load a palette, just for kicks.
				if (db->getPaletteCount() > 0) {
					addPalette(db->getPalette(db->getPaletteListBegin()->name));				
				}
							
			}		
		}
		
		delete dialog;
	}
	
	void Editor::onSaveProject() {
		// Save the current map.
		onSaveMap();
		
		// Save all project databases
		db->save();
	}
	
	void Editor::onNewMap() {
		Gtk::Dialog dialog("New Map", *this, true, true);
		Gtk::VBox* vBox = dialog.get_vbox();
	
		Gtk::HBox boxName(false, 5);
		Gtk::Label labelName("Name:");
		boxName.pack_start(labelName, false, false, 0);
		Gtk::Entry entryName;
		boxName.pack_start(entryName, true, true, 0);
		
		vBox->pack_start(boxName, false, false, 0);
	
		Gtk::HBox boxSize(false, 5);
		Gtk::Label labelWidth("Width:");
		boxSize.pack_start(labelWidth, false, false, 0);
		Gtk::Adjustment adjWidth(25, 25, 512);
		Gtk::SpinButton spinWidth(adjWidth);
		spinWidth.set_value(25);
		boxSize.pack_start(spinWidth, true, false, 0);
	
		Gtk::Label labelHeight("Height:");
		boxSize.pack_start(labelHeight, false, false, 0);
		Gtk::Adjustment adjHeight(20, 20, 512);
		Gtk::SpinButton spinHeight(adjHeight);
		spinHeight.set_value(20);
		boxSize.pack_start(spinHeight, true, false, 0);
	
		vBox->pack_start(boxSize, false, false, 0);
			
		Gtk::HBox boxPalette(false, 5);
		Gtk::Label labelPalette("Palette: ");
		boxPalette.pack_start(labelPalette, false, false, 0);
		Gtk::ComboBoxText paletteChooser;
		for (Database::ConstListIterator it = db->getPaletteListBegin(); it != db->getPaletteListEnd(); ++it) {
			paletteChooser.append_text(it->name);
		}
		paletteChooser.set_active_text(db->getPaletteListBegin()->name);
		boxPalette.pack_start(paletteChooser, true, false, 0);
		
		vBox->pack_start(boxPalette, false, false, 0);
		
		dialog.add_button(Gtk::Stock::OK, Gtk::RESPONSE_OK);
		dialog.add_button(Gtk::Stock::CANCEL, Gtk::RESPONSE_CANCEL);
		
		dialog.show_all_children();
		
		dialog.set_default_response(Gtk::RESPONSE_OK);
		int result = dialog.run();
		
		if (result == Gtk::RESPONSE_OK) {
			Map m(db->getPalette(paletteChooser.get_active_text()),
					spinWidth.get_value_as_int(), spinHeight.get_value_as_int(), entryName.get_text());
			
			// Generate a unique name for the new map, based upon its name.
			if (db->mapExists(m.getName())) {
				std::ostringstream s;
				std::string base = m.getName();
				int n = 2;
				do {
					s.str("");
					s << n++;
					std::cerr << s.str() << std::endl;
					m.setName(base + s.str());
				} while (db->mapExists(m.getName()));
			}
			
			// Save new map
			std::string filename = m.getName() + ".xml";
			boost::filesystem::fstream fout(db->getPath() / "maps" / filename, std::ios::out);
			fout << m;
			fout.flush();
			fout.close();
			
			// Add map to the map database
			db->addMap(m.getName(), m.getName(), filename);
			
			// Add map to the map list
			mapList.append_text(m.getName());
			mapList.show();
			
			// Select new map
			std::ostringstream s;
			s << (mapList.size() - 1);
			mapList.set_cursor(Gtk::TreeModel::Path(s.str()));
		}
	}
	
	void Editor::onSaveMap() {
		if (mapViewer == NULL)
			return;
		
		Map& map = mapViewer->getMap();
		db->saveMap(map.getName());
	}
	
	void Editor::onQuit() {
		// Hide main window, which ends GTK main loop and terminates program.
		hide();
	}
	
	void Editor::onPaletteEditor() {
		palScroller.remove();
		palViewer->get_parent()->remove(*palViewer);
		PaletteEditor pEdit(palViewer, db->getPath(), imageLoader);
		Gtk::Dialog dialog("Palette Editor", *this, true);
		dialog.get_vbox()->pack_start(pEdit);
		dialog.show_all_children();
		dialog.run();
		palViewer = pEdit.getPalette();
		palViewer->get_parent()->remove(*palViewer);
		palScroller.add(*palViewer);
	}
	
	void Editor::onAbout() {
		Gtk::AboutDialog dialog;
		dialog.set_transient_for(*this);
		
		dialog.set_name(TITLE);
		dialog.set_version(VERSION);
		dialog.set_copyright("Copyright 2007 Cory Petosky");
		dialog.set_comments("The o2d Project Data Editor");
		
		dialog.set_license("See gpl.txt for information.");
		
		dialog.set_website("http://o2dproject.net");
		
		std::list<Glib::ustring> authors;
		authors.push_back("Cory Petosky <cory@tanatopia.net>");
		authors.push_back("Special thanks: Marco Alanen, Jon Hall, Dave Conway");
		dialog.set_authors(authors);
		
		dialog.set_logo(Gdk::Pixbuf::create_from_file("gui/logo.png"));
		
		dialog.run();	
	}
	
	void Editor::mapChange() {
		setMap(db->getMap(mapList.get_text(mapList.get_selected()[0])));
	}
	
	void Editor::changeLayer(MapViewer::Layer layer) {
		mapViewer->setLayer(layer);
	}
	
	bool Editor::mapMousePressed(GdkEventButton* event) {
		int x = (int)event->x / Texture::TILESIZE;
		int y = (int)event->y / Texture::TILESIZE;
		
		std::cerr << "Mouse pressed: " << x << "," << y << std::endl;
	
		if (x >= 0 && y >= 0 && x < mapViewer->getMap().getWidth() && y < mapViewer->getMap().getHeight()) {
			drawTexture(x, y);
		}
		
		return true;
	}
	
	bool Editor::mapMouseDragged(GdkEventMotion* event) {
	//	cout << "Editor listener called!\n";
		int x = (int)event->x / Texture::TILESIZE;
		int y = (int)event->y / Texture::TILESIZE;
	
		if (x >= 0 && y >= 0 && x < mapViewer->getMap().getWidth() && y < mapViewer->getMap().getHeight()) {
			if (event->state & Gdk::BUTTON1_MASK) {
				drawTexture(x, y);
			}
	
			std::list<Gdk::Point> tiles;
			tiles.push_back(Gdk::Point(x, y));
			mapViewer->highlight(tiles);
		}
		return true;
	}
		
	void Editor::drawTexture(int x, int y) {
		int palRef = palViewer->getSelectedReference();
		mapViewer->getMap().setTile(x, y, mapViewer->getLayer(), palRef); 
		mapViewer->get_window()->invalidate_rect(Gdk::Rectangle((x - 1) * Texture::TILESIZE,
					(y - 1) * Texture::TILESIZE, Texture::TILESIZE * 3, Texture::TILESIZE * 3), false);
	}
	
	void Editor::on_hide() {
		// Try to save the map.
		onSaveMap();

		// Try to save the project
		if (db != NULL) {
			db->save();
			delete db;
		}
	}

} // namespace

/**
 * Spawns an Editor instance and runs the GTK main loop.
 */
int main(int argc, char *argv[]) {
	Gtk::Main kit(argc, argv);
	
	o2d::Editor editor;

	// Show layout boxes and window
	Gtk::Main::run(editor);

	return 0;
}

