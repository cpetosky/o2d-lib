package net.tanatopia.o2d.editor;

import java.awt.Color;
import java.awt.Dimension;
import java.awt.Graphics;
import java.awt.Image;
import java.awt.Point;
import java.awt.Rectangle;
import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import javax.swing.JComponent;
import javax.swing.JScrollPane;
import javax.swing.Scrollable;
import javax.swing.event.MouseInputListener;

import net.tanatopia.o2d.map.Texture;
import net.tanatopia.o2d.map.TextureFactory;
import net.tanatopia.o2d.xml.XMLReady;

import org.jdom.Document;
import org.jdom.Element;

/**
 * This class defines a generic palette for use in the editor.
 * @author Cory Petosky
 *
 */
public class Palette extends JScrollPane implements XMLReady {
	private enum Mode {
		DRAW, EDIT;
	}

	private static final int width = 8;

	private Map<Point, Texture> textures = new HashMap<Point, Texture>();
	private Image backdrop;
	private int height;
	private Point selected = new Point(0, 0);
	private Pal pal;
	private DrawListener dl = new DrawListener();
	private EditListener el = new EditListener();
	private Texture addTex;
	private Mode mode = Mode.DRAW;

	/**
	 * Create a new, empty palette.
	 *
	 */
	public Palette() {
		height = 1;
				
		initGUI();
	}
	
	/**
	 * Rebuild a palette from one serialized to XML.
	 * @param xml The XML document to rebuild from
	 */
	@SuppressWarnings("unchecked")
	public Palette(Document xml) {
		Element ePalette = xml.getRootElement();
		height = Integer.parseInt(ePalette.getChildText("height"));

		List<Element> children = (List<Element>)ePalette.getChildren("texture");
		for (Element e : children) {
			Element ePosition = e.getChild("position");
			Point p = new Point();
			p.x = Integer.parseInt(ePosition.getChildText("x"));
			p.y = Integer.parseInt(ePosition.getChildText("y"));
			
			Texture t = TextureFactory.create(e.getChildText("name"));
			System.err.println("Adding new texture \"" + t + "\" at " + p);
			textures.put(p, t);
			System.err.println("Total textures added: " + textures.size());
		}
		
		initGUI();
	}
	
	private void initGUI() {
		pal = new Pal();
		pal.addMouseListener(dl);
		
		// Set up ScrollPane
		setHorizontalScrollBarPolicy (HORIZONTAL_SCROLLBAR_NEVER);
		setVerticalScrollBarPolicy (VERTICAL_SCROLLBAR_ALWAYS);
		
		//setPreferredSize(new Dimension(8 * Texture.TILESIZE, 600));
		setViewportView(pal);
		validate();
	}

	public Texture getSelectedTexture() {
		return textures.get(selected);
	}
	
	public void enterDrawMode() {
		pal.addMouseListener(dl);
		pal.removeMouseListener(el);
		pal.removeMouseMotionListener(el);
		mode = Mode.DRAW;
	}
	
	public void addTexture(Texture addTex) {
		// Swap over to edit mode
		pal.removeMouseListener(dl);
		pal.addMouseListener(el);
		pal.addMouseMotionListener(el);
		mode = Mode.EDIT;
		
		this.addTex = addTex;
	}
	
	public void addTexture(Texture addTex, Point p) {
		if (p.y + 1>= height)
			height = p.y + 2;
		textures.put(p, addTex);
	}
	
	public void reinitialize() {
		pal.initImages();
	}
	
	/**
	 * This inner class provides most of the functionality of the palette. The 
	 * Palette class itself provides only the scrolling mechanism.
	 * @author Cory Petosky
	 *
	 */
	private class Pal extends JComponent implements Scrollable {	
		
		public Pal() {
			super();
		}
		
		public void initImages() {
			System.err.println("Initializing palette -- textures: " + textures.size());
			backdrop = createImage(width * Texture.TILESIZE, height * Texture.TILESIZE);
			System.err.println("Backdrop size:" + backdrop.getWidth(this) + "," + backdrop.getHeight(this));
			Graphics g = backdrop.getGraphics();
				
			// Update component height if needed
			setPreferredSize(new Dimension(Texture.TILESIZE * width, Texture.TILESIZE * height));

			// Blank image
			g.setColor(new Color(0xFF, 0x00, 0x99));
			g.fillRect(0, 0, backdrop.getWidth(null), backdrop.getHeight(null));
			
			// Add textures
			for (Entry<Point, Texture> e : textures.entrySet()) {
				Point p = e.getKey();
				Texture t = e.getValue();
				
				g.drawImage(t.getImage(),
						p.x * Texture.TILESIZE, p.y * Texture.TILESIZE,
						Texture.TILESIZE, Texture.TILESIZE, new Color(0xFF, 0x00, 0x99), null);
			}
			
			validate();
			setViewportView(this);
			Palette.this.validate();
			Palette.this.repaint();
		}
		
		public void drawTexture(Point p) {
			Texture t = textures.get(p);
			Graphics g = backdrop.getGraphics();
			g.drawImage(t.getImage(),
					p.x * Texture.TILESIZE, p.y * Texture.TILESIZE,
					Texture.TILESIZE, Texture.TILESIZE, Color.WHITE, null);
		}
		
		@Override
		protected void paintComponent(Graphics g) {
			if (backdrop == null)
				initImages();
			
			// Blank component
			g.setColor(Color.WHITE);
			g.fillRect(0, 0, getWidth(), getHeight());
			
			g.drawImage(backdrop, 0, 0, backdrop.getWidth(null), backdrop.getHeight(null), null);
			
			// Draw selection rectangle
			if (selected != null) {
				switch (mode) {
				case DRAW: // Draw selection rectangle
					g.setColor(Color.BLACK);
					g.drawRect(selected.x * Texture.TILESIZE, selected.y * Texture.TILESIZE,
							Texture.TILESIZE, Texture.TILESIZE);
					g.setColor(Color.WHITE);
					g.drawRect(selected.x * Texture.TILESIZE + 1, selected.y * Texture.TILESIZE + 1,
							Texture.TILESIZE - 2, Texture.TILESIZE - 2);
					g.drawRect(selected.x * Texture.TILESIZE + 2, selected.y * Texture.TILESIZE + 2,
							Texture.TILESIZE - 4, Texture.TILESIZE - 4);
					g.setColor(Color.BLACK);
					g.drawRect(selected.x * Texture.TILESIZE + 3, selected.y * Texture.TILESIZE + 3,
							Texture.TILESIZE - 6, Texture.TILESIZE - 6);
					break;
					
				case EDIT: // Show addable texture
					g.drawImage(addTex.getImage(),
							selected.x * Texture.TILESIZE, selected.y * Texture.TILESIZE,
							Texture.TILESIZE, Texture.TILESIZE, Color.WHITE, this);
					break;
				}
			}
		}

		public Dimension getPreferredScrollableViewportSize() {
			return new Dimension(Texture.TILESIZE * width, 600);
		}

		public int getScrollableUnitIncrement(Rectangle visibleRect, int orientation, int direction) {
			return Texture.TILESIZE;
		}

		public int getScrollableBlockIncrement(Rectangle visibleRect, int orientation, int direction) {
			return Texture.TILESIZE * 2;
		}

		public boolean getScrollableTracksViewportWidth() {
			// TODO Auto-generated method stub
			return true;
		}

		public boolean getScrollableTracksViewportHeight() {
			return false;
		}		
	}
	
	private class EditListener implements MouseInputListener {
		public void mousePressed(MouseEvent e) { }
		public void mouseReleased(MouseEvent e) { }
		public void mouseEntered(MouseEvent e) { }
		public void mouseExited(MouseEvent e) { }
		public void mouseDragged(MouseEvent e) { }

		public void mouseClicked(MouseEvent e) {
			int x = e.getX() / (int)(Texture.TILESIZE);
			int y = e.getY() / (int)(Texture.TILESIZE);
			
			selected = new Point(x, y);
			
			textures.remove(selected);
			textures.put(selected, addTex);
			
			if (selected.y + 1 == height)
				++height;
			
			enterDrawMode();
			pal.initImages();
		}

		public void mouseMoved(MouseEvent e) {
			int x = e.getX() / (int)(Texture.TILESIZE);
			int y = e.getY() / (int)(Texture.TILESIZE);
			
			selected = new Point(x, y);
			repaint();
			
		}
		
	}
	
	private class DrawListener implements MouseListener {

		public void mouseClicked(MouseEvent e) { }
		public void mouseReleased(MouseEvent e) { }
		public void mouseEntered(MouseEvent e) { }
		public void mouseExited(MouseEvent e) { }
		
		public void mousePressed(MouseEvent e) {
			int x = e.getX() / Texture.TILESIZE;
			int y = e.getY() / Texture.TILESIZE;
			
			selected = new Point(x, y);
			repaint();
		}	
	}

	public Document getXML() {
		Document doc = new Document();
		Element ePalette = new Element("palette");
		
		ePalette.addContent(new Element("height").setText("" + height));

		for (Entry<Point, Texture> e : textures.entrySet()) {
			Element eTexture = new Element("texture");
			Element ePosition = new Element("position");
			ePosition.addContent(new Element("x").setText("" + e.getKey().x));
			ePosition.addContent(new Element("y").setText("" + e.getKey().y));
			eTexture.addContent(ePosition);
			eTexture.addContent(new Element("name").setText(e.getValue().getName()));
			ePalette.addContent(eTexture);
		}
		
		doc.setRootElement(ePalette);
		return doc;
	}
}