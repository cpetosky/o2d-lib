package net.tanatopia.o2d.map;

import java.awt.Graphics2D;
import java.awt.Point;
import java.awt.image.BufferedImage;

public abstract class Texture {
	protected String name;
	protected BufferedImage image;
	protected int totalFrames;
	
	public static final int TILESIZE = 32;
	public static final int FRAMES = 4;
	public static final String DEFAULT = "grass";
	
	protected Texture(String name) {
		this.name = name;
	}
	
	/**
	 * Get the default image for this texture
	 * @return image default
	 */
	public abstract BufferedImage getImage();
	
	/**
	 * Get the image based upon the tile's location and neighbors
	 * @param layer The layer this tile is in
	 * @param source The tile to compare on
	 */
	public abstract void render(Graphics2D g, Point p, Map map, int layer, int frame);
		
	public String getName() {
		return name;
	}
		
	public boolean isAnimated() {
		return (totalFrames > 1);
	}
	
	@Override
	public boolean equals(Object o) {
		if (!(o instanceof Texture))
			return false;
		else
			return ((Texture)o).name.equals(name);
	}

	@Override
	public String toString() {
		return getName();
	}
}

