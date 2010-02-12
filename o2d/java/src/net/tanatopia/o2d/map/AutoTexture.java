package net.tanatopia.o2d.map;

import java.awt.Graphics2D;
import java.awt.Point;
import java.awt.image.BufferedImage;
import java.io.IOException;

import net.tanatopia.o2d.io.ResourceManager;


public class AutoTexture extends Texture {
	private enum SliceType {
		HORIZONTAL, VERTICAL;
	}
	private static final int BORDER_NONE =  0x00;
	private static final int BORDER_UP =    0x01;
	private static final int BORDER_RIGHT = 0x02;
	private static final int BORDER_DOWN =  0x04;
	private static final int BORDER_LEFT =  0x08;
	
	public AutoTexture(String name) {
		super(name);
		try {
			image = ResourceManager.getImage("textures", name + ".png");
		} catch (IOException e) {
			e.printStackTrace();
			System.exit(-1);
		}
		
		// Check for animation frames
		totalFrames = image.getWidth() / (TILESIZE * 3);

	}

	public BufferedImage getImage() {
		return image.getSubimage(0, 0, TILESIZE, TILESIZE);
	}
	
	private Point dest;
	public void render(Graphics2D g, Point p, Map map, int layer, int frame) {
		if (frame >= totalFrames)
			frame = 0;
		int borders = BORDER_NONE;
		int offset = frame * TILESIZE * 3;
		
		dest = new Point(p.x * TILESIZE, p.y * TILESIZE);
		
		// Check borders, set border flags
		Tile t;
		t = map.getTile(p.x - 1, p.y);
		if (t == null || (t.getTexture(layer) != null && t.getTexture(layer).equals(this)))
			borders |= BORDER_LEFT;
		
		t = map.getTile(p.x + 1, p.y);
		if (t == null || (t.getTexture(layer) != null && t.getTexture(layer).equals(this)))
			borders |= BORDER_RIGHT;

		t = map.getTile(p.x, p.y - 1);
		if (t == null || (t.getTexture(layer) != null && t.getTexture(layer).equals(this)))
			borders |= BORDER_UP;

		t = map.getTile(p.x, p.y + 1);
		if (t == null || (t.getTexture(layer) != null && t.getTexture(layer).equals(this)))
			borders |= BORDER_DOWN;
		
//		g.setComposite(AlphaComposite.Src);
//		g.setColor(new Color(0, 0, 0, 0));
//		g.fillRect(0, 0, TILESIZE, TILESIZE);
		
		// Check cases
		switch (borders) {
		// No border case -- default tile
		// No inside corner checks
		case BORDER_NONE:
			g.drawImage(image.getSubimage(offset, 0, TILESIZE, TILESIZE), dest.x, dest.y, null);
		
		// Dead end cases -- corner tile + extra corner tile
		// No inside corner checks.
		case BORDER_LEFT:
			addNEBase(g, frame);
			addSide(g, 0, TILESIZE / 2, offset + (2 * TILESIZE), 3 * TILESIZE + TILESIZE / 2, SliceType.HORIZONTAL);
			break;
			
		case BORDER_RIGHT:
			addSWBase(g, frame);
			addSide(g, 0, 0, offset, TILESIZE, SliceType.HORIZONTAL);
			break;

		case BORDER_UP:
			addSWBase(g, frame);
			addSide(g, TILESIZE / 2, 0, offset + (2 * TILESIZE) + (TILESIZE / 2), 3 * TILESIZE, SliceType.VERTICAL);
			break;
			
		case BORDER_DOWN:
			addNEBase(g, frame);
			addSide(g, 0, 0, offset, TILESIZE, SliceType.VERTICAL);
			break;

		// Elbow cases -- corner tile
		// Gotta check for the inside corner!
		case BORDER_LEFT | BORDER_UP:
			addSEBase(g, frame);
			addNWCorner(g, p, map, layer, frame);
			break;
			
		case BORDER_UP | BORDER_RIGHT:
			addSWBase(g, frame);
			addNECorner(g, p, map, layer, frame);
			break;
			
		case BORDER_RIGHT | BORDER_DOWN:
			addNWBase(g, frame);
			addSECorner(g, p, map, layer, frame);
			break;
			
		case BORDER_DOWN | BORDER_LEFT:
			addNEBase(g, frame);
			addSWCorner(g, p, map, layer, frame);
			break;
			
		// Row/column cases -- side + opposite side
		// No inside corner checks.
		case BORDER_UP | BORDER_DOWN:
			addWBase(g, frame);
			addSide(g, TILESIZE / 2, 0, offset + 2 * TILESIZE + TILESIZE / 2, 2 * TILESIZE, SliceType.VERTICAL);
			break;
				
		case BORDER_LEFT | BORDER_RIGHT:
			addNBase(g, frame);
			addSide(g, 0, TILESIZE / 2, offset + TILESIZE, 3 * TILESIZE + TILESIZE / 2, SliceType.HORIZONTAL);
			break;

		// T cases -- side tile
		// Gotta check for both inside corners!
		case BORDER_LEFT | BORDER_UP | BORDER_RIGHT:
			addSBase(g, frame);
			addNWCorner(g, p, map, layer, frame);
			addNECorner(g, p, map, layer, frame);
			break;

		case BORDER_UP | BORDER_RIGHT | BORDER_DOWN:
			addWBase(g, frame);
			addNECorner(g, p, map, layer, frame);
			addSECorner(g, p, map, layer, frame);
			break;

		case BORDER_RIGHT | BORDER_DOWN | BORDER_LEFT:
			addNBase(g, frame);
			addSWCorner(g, p, map, layer, frame);
			addSECorner(g, p, map, layer, frame);
			break;

		case BORDER_DOWN | BORDER_LEFT | BORDER_UP:
			addEBase(g, frame);
			addNWCorner(g, p, map, layer, frame);
			addSWCorner(g, p, map, layer, frame);
			break;

		// Middle case -- middle tile
		// Gotta check for every inside corner!
		case BORDER_LEFT | BORDER_UP | BORDER_RIGHT | BORDER_DOWN:
			addCenterBase(g, frame);
			addNWCorner(g, p, map, layer, frame);
			addNECorner(g, p, map, layer, frame);
			addSWCorner(g, p, map, layer, frame);
			addSECorner(g, p, map, layer, frame);
			break;
			
		}
	}
	
	private void addSide(Graphics2D g, int dx, int dy, int sx, int sy, SliceType st) {
		switch (st) {
		case HORIZONTAL:
			g.drawImage(image,
					dest.x + dx, dest.y + dy, dest.x + dx + TILESIZE, dest.y + dy + TILESIZE / 2,
					sx, sy, sx + TILESIZE, sy + TILESIZE / 2,
					null);
			break;
		case VERTICAL:
			g.drawImage(image,
					dest.x + dx, dest.y + dy, dest.x + dx + TILESIZE / 2, dest.y + dy + TILESIZE,
					sx, sy, sx + TILESIZE / 2, sy + TILESIZE,
					null);
			break;
		}
	}
	
	private void addCorner(Graphics2D g, int dx, int dy, int sx, int sy) {
		g.drawImage(image,
				dest.x + dx, dest.y + dy, dest.x + dx + TILESIZE / 2, dest.y + dy + TILESIZE / 2,
				sx, sy, sx + TILESIZE / 2, sy + TILESIZE / 2,
				null);
	}
	
	private void addNWCorner(Graphics2D g, Point p, Map map, int layer, int frame) {
		Tile t = map.getTile(p.x - 1, p.y - 1);
		if (t != null && (t.getTexture(layer) == null || !t.getTexture(layer).equals(this)))
			addCorner(g, 0, 0, frame * TILESIZE * 3 + TILESIZE * 2, 0);
	}
	
	private void addNECorner(Graphics2D g, Point p, Map map, int layer, int frame) {
		Tile t = map.getTile(p.x + 1, p.y - 1);
		if (t != null && (t.getTexture(layer) == null || !t.getTexture(layer).equals(this)))
			addCorner(g, TILESIZE / 2, 0, frame * TILESIZE * 3 + TILESIZE * 2 + TILESIZE / 2, 0);
	}
	
	private void addSWCorner(Graphics2D g, Point p, Map map, int layer, int frame) {
		Tile t = map.getTile(p.x - 1, p.y + 1);
		if (t != null && (t.getTexture(layer) == null || !t.getTexture(layer).equals(this)))
			addCorner(g, 0, TILESIZE / 2, frame * TILESIZE * 3 + TILESIZE * 2, TILESIZE / 2);
	}
	
	private void addSECorner(Graphics2D g, Point p, Map map, int layer, int frame) {
		Tile t = map.getTile(p.x + 1, p.y + 1);
		if (t != null && (t.getTexture(layer) == null || !t.getTexture(layer).equals(this)))
			addCorner(g, TILESIZE / 2, TILESIZE / 2, frame * TILESIZE * 3 + TILESIZE * 2 + TILESIZE / 2, TILESIZE / 2);
	}
	
	private void addBase(Graphics2D g, int sx, int sy) {
		g.drawImage(image,
				dest.x + 0, dest.y + 0, dest.x + TILESIZE, dest.y + TILESIZE,
				sx, sy, sx + TILESIZE, sy + TILESIZE,
				null);
	}
	private void addNWBase(Graphics2D g, int frame) {
		addBase(g, frame * TILESIZE * 3, TILESIZE);
	}

	private void addNBase(Graphics2D g, int frame) {
		addBase(g, frame * TILESIZE * 3 + TILESIZE, TILESIZE);
	}

	private void addNEBase(Graphics2D g, int frame) {
		addBase(g, frame * TILESIZE * 3 + TILESIZE + TILESIZE, TILESIZE);
	}

	private void addWBase(Graphics2D g, int frame) {
		addBase(g, frame * TILESIZE * 3, 2 * TILESIZE);
	}

	private void addCenterBase(Graphics2D g, int frame) {
		addBase(g, frame * TILESIZE * 3 + TILESIZE, 2 * TILESIZE);
	}

	private void addEBase(Graphics2D g, int frame) {
		addBase(g, frame * TILESIZE * 3 + TILESIZE + TILESIZE, TILESIZE + TILESIZE);
	}

	private void addSWBase(Graphics2D g, int frame) {
		addBase(g, frame * TILESIZE * 3, TILESIZE + TILESIZE + TILESIZE);
	}

	private void addSBase(Graphics2D g, int frame) {
		addBase(g, frame * TILESIZE * 3 + TILESIZE, TILESIZE + TILESIZE + TILESIZE);
	}

	private void addSEBase(Graphics2D g, int frame) {
		addBase(g, frame * TILESIZE * 3 + TILESIZE + TILESIZE, TILESIZE + TILESIZE + TILESIZE);
	}

}
