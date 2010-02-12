SUBDIRS = common

AM_CPPFLAGS = -I$(srcdir)/common `pkg-config libxml++-2.6 --cflags`

bin_PROGRAMS = o2d-editor o2d
o2d_editor_SOURCES = Editor.h Editor.cpp GTKImage.h GTKImage.cpp GTKImageLoader.h GTKImageLoader.cpp \
		GTKTileBlitter.h GTKTileBlitter.cpp MapViewer.h MapViewer.cpp PaletteEditor.h PaletteEditor.cpp \
		PaletteViewer.h PaletteViewer.cpp
o2d_editor_LDADD = common/libo2d-common.a -lboost_filesystem
o2d_editor_LDFLAGS = `pkg-config --libs libxml++-2.6 ` `pkg-config --libs gtkmm-2.4`
o2d_editor_CPPFLAGS = `pkg-config gtkmm-2.4 --cflags` $(AM_CPPFLAGS)

o2d_SOURCES = Game.h Game.cpp SDLEntityBlitter.h SDLEntityBlitter.cpp SDLImage.h SDLImage.cpp \
		SDLImageLoader.h SDLImageLoader.cpp SDLTileBlitter.h SDLTileBlitter.cpp \
		ScriptEngine.h ScriptEngine.cpp
o2d_LDADD = common/libo2d-common.a -lboost_filesystem
o2d_LDFLAGS = `pkg-config --libs libxml++-2.6 `
