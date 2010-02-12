package net.tanatopia.o2d.map;

import java.awt.Dimension;
import java.awt.Graphics2D;
import java.awt.Point;


public class RenderableLayer {
	private int frame = 0;
	private RenderableMap map;
	private int layer;
	
	public RenderableLayer(RenderableMap map, int layer) {
		this.map = map;
		this.layer = layer;
	}
	
	public void nextFrame() {
		frame = (frame + 1) % Texture.FRAMES;
	}
	
	public void drawNearbyTextures(Point p, Graphics2D g) {
		drawNearbyTextures(p.x, p.y, g);
	}

	public void drawNearbyTextures(int i, int j, Graphics2D g) {
		for (int row = Math.max(i - 1, 0); (row <= i + 1) && (row < map.getWidth()); ++row)
			for (int col = Math.max(j - 1, 0); (col <= j + 1) && (col < map.getHeight()); ++col)
				drawTexture(row, col, g);
	}
	
	private void drawTexture(int i, int j, Graphics2D g) {
		Texture tex = map.getTile(i, j).getTexture(layer);
		
		if (tex != null) {
			tex.render(g, new Point(i, j), map, layer, frame);
		}
	}
	
	public void render(Graphics2D g) {
		for (int i = 0; i < map.getWidth(); ++i)
			for (int j = 0; j < map.getHeight(); ++j)
				drawTexture(i, j, g);
	}

	public void renderViewable(Point viewAnchor, Dimension screenSize, Graphics2D g) {
		int xOffset = viewAnchor.x % Texture.TILESIZE;
		int yOffset = viewAnchor.y % Texture.TILESIZE;
		int xStart = -xOffset;
		int yStart = -yOffset;
		int iTileStart = viewAnchor.x / Texture.TILESIZE;
		int jTileStart = viewAnchor.y / Texture.TILESIZE;
		
		int i = iTileStart;
		for (int x = xStart; x < viewAnchor.x + screenSize.width; x += Texture.TILESIZE) {
			int j = jTileStart;
			for (int y = yStart; y < viewAnchor.y + screenSize.height; y += Texture.TILESIZE) {
				Texture tex = map.getTile(i, j).getTexture(layer);
				if (tex != null) {
					tex.render(g, new Point(i, j), map, layer, frame);
				}
				++j;
			}
			++i;
		}
	}


	
}
