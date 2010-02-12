package net.tanatopia.o2d.map;

import java.awt.Graphics2D;
import java.awt.Point;
import java.awt.image.BufferedImage;
import java.io.IOException;

import net.tanatopia.o2d.io.ResourceManager;


/**
 * This class provides the default implementation for a simple texture. This
 * default texture has no context or adaptability. It can be animated.
 * @author Cory Petosky
 *
 */
public class PlainTexture extends Texture {
	/**
	 * Build the texture based upon the name of its source image. This will load
	 * the image from disk if it has not been loaded already.
	 * @param name the name of the texture
	 */
	public PlainTexture(String name) {
		super(name);
		try {
			image = ResourceManager.getImage("textures", name + ".png");
		} catch (IOException e) {
			System.err.println("Error: texture \"" + name + "\" does not exist.");
			try {
				image = ResourceManager.getImage("textures", "grass.png");
			} catch (IOException ex) {
				System.err.println("Fatal Error: default texture does not exist. Aborting.");
				System.exit(-1);
			}
		}
		
		// Check for animation frames
		totalFrames = image.getWidth() / TILESIZE;
	}
	
	/**
	 * Accesses and returns the default tile image for this texture. This returns only a
	 * single frame of animation, based upon the current internal frame counter, on an
	 * animated texture.
	 * @return the tile image
	 */
	public BufferedImage getImage() {
		return getImage(0);
	}
	
	private BufferedImage getImage(int frame) {
		if (totalFrames == 1)
			return image;
		else {
			return image.getSubimage(frame * TILESIZE, 0, TILESIZE, TILESIZE);
		}
		
	}
	
	/**
	 * Simply calls getImage(), as this texture doesn't have any context.
	 */
	public void render(Graphics2D g, Point p, Map map, int layer, int frame) {
		g.drawImage(getImage(), p.x * TILESIZE, p.y * TILESIZE, null);
	}

}
