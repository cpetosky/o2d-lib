package net.tanatopia.o2d.editor;

import java.awt.Color;
import java.awt.Dimension;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.Image;
import java.awt.Point;
import java.util.Observable;
import java.util.Observer;

import javax.swing.JComponent;

import net.tanatopia.o2d.map.Map;
import net.tanatopia.o2d.map.RenderableLayer;
import net.tanatopia.o2d.map.RenderableMap;
import net.tanatopia.o2d.map.Texture;

public class EditorMapViewer extends JComponent implements Observer {
	private RenderableMap map;
	private int curLayer;
		
	JComponent highlight;
	
	public EditorMapViewer(RenderableMap map) {
		super();
		this.map = map;
		
		curLayer = 0;
	
		map.addObserver(this);
		
		setPreferredSize(new Dimension((int)(map.getWidth() * map.getZoom() * Texture.TILESIZE),
				(int)(map.getHeight() * map.getZoom() * Texture.TILESIZE)));
				
		repaint();
	}
	


	public void update(Observable o, Object arg) {
		// TODO Auto-generated method stub
		
	}
		
	public RenderableMap getMap() {
		return map;
	}

	public void highlight(Point... tiles) {
		if (highlight != null)
			remove(highlight);
		if (tiles[0].x >= map.getWidth() || tiles[0].y >= map.getHeight())
			return;
		// TODO Update for multi-tile selection
		if (tiles.length == 1) {
			final int scale = (int)(map.getZoom() * Texture.TILESIZE);
			
			// Make a new single-tile highlight
			highlight = new JComponent() {
				Image backdrop;
								
				private void initImages() {
					backdrop = EditorMapViewer.this.getGraphicsConfiguration().
							createCompatibleImage(scale, scale, Color.TRANSLUCENT);
					Graphics g = backdrop.getGraphics();
					g.setColor(Color.BLACK);
					g.drawRect(0, 0, scale - 1, scale - 1);
					g.setColor(Color.WHITE);
					g.drawRect(1, 1, scale - 3, scale - 3);
					g.drawRect(2, 2, scale - 5, scale - 5);
					g.setColor(Color.BLACK);
					g.drawRect(3, 3, scale - 7, scale - 7);
					g.dispose();
				}
				
				@Override
				protected void paintComponent(Graphics g) {
					if (backdrop == null)
						initImages();
					g.drawImage(backdrop, 0, 0, scale, scale, null);
				}
			};
			highlight.setOpaque(false);
			Point selected = tiles[0];
			add(highlight);
			highlight.setBounds(selected.x * scale, selected.y * scale, scale, scale);
			highlight.setVisible(true);
			
			validate();
			repaint();

		}
	}
	
	@Override
	protected void paintComponent(Graphics g) {
		int w = (int)(map.getWidth() * map.getZoom()) * Texture.TILESIZE;
		int h = (int)(map.getHeight() * map.getZoom()) * Texture.TILESIZE;
		g.setColor(new Color(0xFF, 0x00, 0x99));
		g.fillRect(0, 0, w, h);
/*		
		// Initialize tile to be transparent
		Composite c = g.getComposite();
		g.setComposite(AlphaComposite.Src);
		g.setColor(CLEAR);
		g.fillRect(x, y, scale, scale);
		g.setComposite(c);
*/
		for (RenderableLayer layer : map.getLayers()) {
			layer.render((Graphics2D)g);
		}
		
	}
	
	public int getCurrentLayer() {
		return curLayer;
	}

	public void setCurrentLayer(int l) {
		if (l >= 0 && l < Map.LAYERS) {
			curLayer = l;
			repaint();
		}	
	}

}
