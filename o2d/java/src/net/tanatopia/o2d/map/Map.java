package net.tanatopia.o2d.map;

import java.awt.Dimension;
import java.awt.Point;
import java.io.BufferedReader;
import java.io.IOException;
import java.util.Observable;

/**
 * The Map class describes map data. It is not, in and of itself, directly
 * displayable. To display a map in a Swing environment, wrap it with a
 * MapViewer. To display a map in an accelerated environment, wrap it with a
 * RenderableMap.
 * @author Cory Petosky
 *
 */
public class Map extends Observable {
	protected Dimension size;
	protected String name;
	protected Tile[][] tiles;
	
	public static int LAYERS = 4;
	public static int PRIORITIES = 6;
	
	/**
	 * Creates a single-layer map consisting of the default tile.
	 * @param size The size of the new map
	 * @param name The name of the new map
	 */
	public Map(Dimension size, String name) {
		this.size = size;
		this.name = name;
		System.err.println(size);
		tiles = new Tile[size.width][size.height];
		for (int i = 0; i < size.width; ++i)
			for (int j = 0; j < size.height; ++j)		
				tiles[i][j] = new Tile(new Point(i, j));
	}
	
	protected Map(Map m) {
		this.size = m.size;
		this.name = m.name;
		this.tiles = m.tiles;
	}

	public Dimension getSize() {
		return (Dimension)size.clone();
	}
	
	public int getHeight() {
		return size.height;
	}
	
	public int getWidth() {
		return size.width;
	}
	
	public String getName() {
		return name;
	}
	
	public Tile getTile(int i, int j) {
		if (i < 0 || j < 0 || i >= size.width || j >= size.height)
			return null;
		return tiles[i][j];
	}
	
	public String save() {
		StringBuffer sb = new StringBuffer("");
		sb.append(name + "\n");
		sb.append(size.width + " " + size.height + "\n");
		for (int i = 0; i < size.width; ++i) {
			for (int j = 0; j < size.height; ++j) {
				for (int k = 0; k < LAYERS; ++k) {
					Texture t = tiles[i][j].getTexture(k);
					if (t == null)
						sb.append("_");
					else
						sb.append(t.getName());
					sb.append(" ");
				}
				sb.append(tiles[i][j].getPassage());
				sb.append("\n");
			}
		}
		return sb.toString();
	}
	
	public static Map load(BufferedReader in) {
		String line;
		String[] tokens;
		String name;
		Dimension size;
		Map m;
		try {
			line = in.readLine();
			name = line;
			line = in.readLine();
			tokens = line.trim().split(" ");
			size = new Dimension(Integer.parseInt(tokens[0]), Integer.parseInt(tokens[1]));
			m = new Map(size, name);
			for (int i = 0; i < size.width; ++i) {
				for (int j = 0; j < size.height; ++j) {
					line = in.readLine();
					tokens = line.trim().split(" ");
					for (int k = 0; k < LAYERS; ++k)
						m.tiles[i][j].setTexture(TextureFactory.create(tokens[k]), k);
					m.tiles[i][j].setPassage(Integer.parseInt(tokens[LAYERS]));
				}
			}
		} catch (IOException ex) {
			ex.printStackTrace();
			return null;
		}
		return m;
	}
}
