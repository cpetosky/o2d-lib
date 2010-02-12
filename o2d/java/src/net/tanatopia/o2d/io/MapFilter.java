package net.tanatopia.o2d.io;

import java.io.File;

import javax.swing.filechooser.FileFilter;

public class MapFilter extends FileFilter {

	public boolean accept(File f) {
		if (f.isDirectory())
			return true;
		if (f.getName().toLowerCase().endsWith(".map"))
			return true;
		else
			return false;
	}

	//The description of this filter
	public String getDescription() {
		return "o2d Maps (.map)";
	}
}