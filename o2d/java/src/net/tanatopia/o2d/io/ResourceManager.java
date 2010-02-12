package net.tanatopia.o2d.io;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.util.Map;
import java.util.TreeMap;

import javax.imageio.ImageIO;

public class ResourceManager {
	private static Map<String, BufferedImage> images = new TreeMap<String, BufferedImage>();
	private static Map<String, File> directories = new TreeMap<String, File>();
	private static File base;


	public static void setBase(File base) {
		ResourceManager.base = base;
	}
	
	public static File getBase() {
		return base;
	}
	
	public static void addDirectory(String path) {
		addDirectory(path, path);
	}
	
	public static void addDirectory(String path, String name) {
		File dir = new File(base, path);
		if (!dir.exists())
			dir.mkdirs();
		directories.put(name, dir);
	}
	
	public static BufferedImage getImage(String path, String name) throws IOException {
		String fullPath = path + File.separator + name;
		if (images.containsKey(fullPath)) {
			return images.get(fullPath);
		}

		File dir = directories.get(path);
		if (dir != null) {
			File img = new File(dir, name);
			if (img.exists()) {
				images.put(fullPath, ImageIO.read(img));
				return images.get(fullPath);
			} else {
				return null;
			}
		}
		return null;
	}
	
	public static File getResource(String path, String name) {
		File dir = directories.get(path);
		if (dir != null) {
			File f = new File(dir, name);
			if (f.exists()) {
				return f;
			} else {
				return null;
			}
		}
		return null;
		
	}
	
	public static File getDirectory(String path) {
		File dir = new File(base, path);
		if (dir.exists())
			return dir;
		else
			return null;
	}

	public static BufferedImage loadImage(String path) throws IOException {
		if (images.containsKey(path)) {
			return images.get(path);
		}

		File img = new File(base, path);
		if (img.exists()) {
			images.put(path, ImageIO.read(img));
			return images.get(path);
		} else {
			return null;
		}
	}
}