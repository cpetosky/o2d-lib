package net.tanatopia.o2d.map;

import java.awt.Point;

public class Tile {
	
	// Bits for controlling passage through a tile
	public static final int ENTER_LEFT = 0x01;
	public static final int ENTER_UP = 0x02;
	public static final int ENTER_RIGHT = 0x04;
	public static final int ENTER_DOWN = 0x08;
	public static final int LEAVE_LEFT = 0x10;
	public static final int LEAVE_UP = 0x20;
	public static final int LEAVE_RIGHT = 0x40;
	public static final int LEAVE_DOWN = 0x80;
	
	public static final int LEFT = 0x11;
	public static final int UP = 0x22;
	public static final int RIGHT = 0x44;
	public static final int DOWN = 0x88;
	
	private Texture[] textures = new Texture[Map.LAYERS];
	private int[] priorities = new int[Map.LAYERS];
	private int passage;
	private Point position;
	
	/**
	 * Creates a tile using the default texture and all passage enabled.
	 * @param map Map in which this tile resides
	 * @param position Position in which this tile resides
	 */
	public Tile(Point position) {
		this.position = position;
		passage = LEFT | UP | RIGHT | DOWN;
	}
	
	public void setTexture(Texture t, int layer) {
		textures[layer] = t;
	}
	
	public Texture getTexture(int layer) {
		return textures[layer];
	}
	
	public Point getPosition() {
		return (Point)position.clone();
	}

	public void setPassage(int passage) {
		this.passage = passage;
	}

	public int getPassage() {
		return passage;
	}
}
