package net.tanatopia.o2d.map;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.util.Map;
import java.util.TreeMap;

import net.tanatopia.o2d.io.ResourceManager;


public class TextureFactory {
	private static Map<String, Texture> textures = new TreeMap<String, Texture>();
	public static Texture create(String filename) {
		
		if (textures.containsKey(filename))
			return textures.get(filename);
		else {
			try {
				BufferedImage image = ResourceManager.loadImage("textures" + File.separator + filename + ".png");
				if (image == null)
					return null;
				Texture tex;
				if (image.getHeight() > Texture.TILESIZE)
					tex = new AutoTexture(filename);
				else
					tex = new PlainTexture(filename);
				
				textures.put(filename, tex);
				return tex;
			} catch (IOException e) {
				return null;
			}
		}
	}
	
	public static Map<String, Texture> getTextures() {
		return textures;
	}
}
