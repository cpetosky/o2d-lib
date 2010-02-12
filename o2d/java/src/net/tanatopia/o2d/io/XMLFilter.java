package net.tanatopia.o2d.io;

import java.io.File;

import javax.swing.filechooser.FileFilter;

public class XMLFilter extends FileFilter {

	public boolean accept(File f) {
		if (f.isDirectory())
			return true;
		if (f.getName().toLowerCase().endsWith(".xml"))
			return true;
		else
			return false;
	}

	//The description of this filter
	public String getDescription() {
		return "XML Files (.xml)";
	}
}