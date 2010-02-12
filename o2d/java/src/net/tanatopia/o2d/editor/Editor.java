package net.tanatopia.o2d.editor;

import java.awt.BorderLayout;
import java.awt.Dimension;
import java.awt.Graphics2D;
import java.awt.Point;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.MouseEvent;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.util.prefs.Preferences;

import javax.swing.JFileChooser;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTabbedPane;
import javax.swing.JToolBar;
import javax.swing.UIManager;
import javax.swing.WindowConstants;
import javax.swing.border.BevelBorder;
import javax.swing.event.MouseInputListener;

import net.tanatopia.o2d.io.MapFilter;
import net.tanatopia.o2d.io.ResourceManager;
import net.tanatopia.o2d.map.Map;
import net.tanatopia.o2d.map.RenderableMap;
import net.tanatopia.o2d.map.Texture;
import net.tanatopia.o2d.map.TextureFactory;
import net.tanatopia.o2d.map.Tile;

/**
 * An editor is used to edit all data for the o2d project. An editor can be instantiated
 * from another class, or this class can be run directly to create a standalone editor.
 * 
 * @author Cory Petosky
 *
 */
public class Editor extends JFrame implements ActionListener {
	public enum DrawMode {
		PENCIL, RECTANGLE, ELLIPSE, FILL, SELECTION;
	}
	
	private static final String TITLE = "o2d Editor";
	
	// Preference node names
	private static final String PREF_DIR = "datadir";
	
	// GUI elements
	private JTabbedPane mapWindows;
	private JLabel statusBar;
	private EditorToolbar toolbox;
	private Palette palette;
	private JPanel bottomPanel;
	
	// State
	private DrawMode drawMode;

	/**
	 * Initializes a new Editor instance.
	 * @param title The title of the editor frame.
	 */
	public Editor(String title) {
		super(title);
		
		// Load/initialize user preferences
		Preferences prefs = Preferences.userNodeForPackage(Editor.class);
		String dataDir = prefs.get(PREF_DIR, System.getProperty("user.home") + File.separator + "o2d");
		
		// Initialize data directory
		File dd = new File(dataDir);
		if (!dd.exists())
			dd.mkdir();
		
		// Initialize resource manager
		ResourceManager.setBase(dd);
		ResourceManager.addDirectory("textures");
		ResourceManager.addDirectory("palettes");
		ResourceManager.addDirectory("maps");
		
		// Instantiate stuff
		drawMode = DrawMode.PENCIL;
	
		// Initialize GUI
		setJMenuBar(new EditorMenuBar(this));
		toolbox = new EditorToolbar(this, JToolBar.HORIZONTAL);
		
		palette = new Palette();
		palette.setVisible(true);
		palette.setBorder(new BevelBorder(BevelBorder.LOWERED));
		
		mapWindows = new JTabbedPane(JTabbedPane.TOP);
		mapWindows.setPreferredSize(new Dimension(640, 480));
		mapWindows.setVisible(true);
		
		statusBar = new JLabel("o2d editor v.0.0.2");
		statusBar.setVisible(true);
		statusBar.setVerticalTextPosition(JLabel.BOTTOM);
		statusBar.setBorder(new BevelBorder(BevelBorder.LOWERED));
		
		bottomPanel = new JPanel(new BorderLayout());
		bottomPanel.add(statusBar, BorderLayout.SOUTH);

		setLayout(new BorderLayout());
		add(toolbox, BorderLayout.NORTH);
		add(palette, BorderLayout.WEST);
		add(mapWindows, BorderLayout.CENTER);
		add(bottomPanel, BorderLayout.SOUTH);
		pack();
		setVisible(true);	
	}
	
	/**
	 * Establishes and initializes the GUI for the editor. This is only called
	 * when this class is run on its own.
	 * 
	 * TODO: Update to load preferences from a local file.
	 *
	 */
	private static void createEditor() 
	{
		JFrame.setDefaultLookAndFeelDecorated(true);
		//String server = JOptionPane.showInputDialog("Enter the hostname of the o2d server:", "localhost");
		//int port = Integer.parseInt(JOptionPane.showInputDialog("Enter the port:", 16150));
		Editor editor = new Editor(TITLE);
		editor.setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);
		//editor.addWindowListener(editor);
		editor.setVisible(true);
	}
	


	
	/**
	 * Runs the editor. This is used to create an instance of the editor standalone,
	 * instead of creating it from another program.
	 * @param args Currently unused.
	 */
	public static void main(String[] args) 
	{
		// Set look-and-feel for swing components to the local system default.
		try 
		{
			UIManager.setLookAndFeel(
				UIManager.getSystemLookAndFeelClassName());
		} 
		catch (Exception e) { }

		// Schedule the creation of the GUI.
		javax.swing.SwingUtilities.invokeLater(new Runnable() 
		{
			public void run() 
			{
				createEditor();
			}
		});
	}
	
	private void addMap(RenderableMap map) {
        EditorMapViewer mv = new EditorMapViewer(map);
        DrawHandler dh = new DrawHandler();
        mv.addMouseListener(dh);
        mv.addMouseMotionListener(dh);
        JScrollPane scroller = new JScrollPane(mv);
        mapWindows.addTab(map.getName(), scroller);
        mapWindows.validate();	
	}

	public void actionPerformed(ActionEvent e) {
		EditorMapViewer mv;
		JFileChooser fc;
		
		switch (EditorMenuBar.MenuOption.valueOf(e.getActionCommand())) {
		case NEW_MAP:
			Runnable r = new Runnable() {
				public void run() {
					int height = Integer.parseInt(JOptionPane.showInputDialog(Editor.this, "Enter height:"));
					int width = Integer.parseInt(JOptionPane.showInputDialog(Editor.this, "Enter width:"));
					String name = JOptionPane.showInputDialog(Editor.this, "Enter map name:");
					RenderableMap map = new RenderableMap(new Map(new Dimension(width, height), name));
		            addMap(map);
		            System.err.println("NUMTEXTURES: " + TextureFactory.getTextures().size());
				}
			};
			new Thread(r).start();
			break;
			
		case OPEN:
			fc = new JFileChooser(ResourceManager.getDirectory("maps"));
			fc.setFileFilter(new MapFilter());
			int r1 = fc.showOpenDialog(this);
			if (r1 == JFileChooser.APPROVE_OPTION) {
				try {
					BufferedReader in = new BufferedReader(new FileReader(fc.getSelectedFile()));
					addMap(new RenderableMap(Map.load(in)));
				} catch (Exception ex) {
					ex.printStackTrace();
					System.exit(-1);
				}
			}
			break;
		
		case SAVE:	
		case SAVEAS:
			fc = new JFileChooser(ResourceManager.getDirectory("maps"));
			fc.setFileFilter(new MapFilter());
			int r2 = fc.showSaveDialog(this);
			if (r2 == JFileChooser.APPROVE_OPTION) {
				try {
					FileWriter out = new FileWriter(fc.getSelectedFile());
					out.write(getSelectedMapViewer().getMap().save());
					out.flush();
				} catch (Exception ex) {
					ex.printStackTrace();
					System.exit(-1);
				}
			}
			break;

		case SAVEALL:
		case REVERT:
			break;
			
		case LAYER1:
			mv = getSelectedMapViewer();
			mv.setCurrentLayer(0);
			break;
			
		case LAYER2:
			mv = getSelectedMapViewer();
			mv.setCurrentLayer(1);
			break;
			
		case LAYER3:
			mv = getSelectedMapViewer();
			mv.setCurrentLayer(2);
			break;
			
		case LAYER4:
			mv = getSelectedMapViewer();
			mv.setCurrentLayer(3);
			break;
			
		case PENCIL:
			drawMode = DrawMode.PENCIL;
			break;

		case RECTANGLE:
			drawMode = DrawMode.RECTANGLE;
			break;
		
		case ELLIPSE:
			drawMode = DrawMode.ELLIPSE;
			break;
		
		case FILL:
			drawMode = DrawMode.FILL;
			break;

		case SELECTION:
			drawMode = DrawMode.SELECTION;
			break;
			
		case SCALE_100:
			mv = getSelectedMapViewer();
			mv.getMap().setZoom(1);
			break;
			
		case SCALE_50:
			mv = getSelectedMapViewer();
			mv.getMap().setZoom(.5);
			break;
			
		case SCALE_25:
			mv = getSelectedMapViewer();
			mv.getMap().setZoom(.25);
			break;
			
		case PALETTE_EDITOR:
			PaletteEditor pe = new PaletteEditor(this, palette);
			pe.setVisible(true);
			remove(palette);
			palette = pe.getPalette();
			add(palette, BorderLayout.LINE_START);
			pack();
			repaint();
			//validate();
			break;
			
		case CLOSE:
		case EXIT:
		case ABOUT:
		}

		
	}
	
	private EditorMapViewer getSelectedMapViewer() {
		return (EditorMapViewer)((JScrollPane)mapWindows.getSelectedComponent()).getViewport().getView();
	}
	
	private class DrawHandler implements MouseInputListener {

		public void mouseClicked(MouseEvent e) {
			// TODO Auto-generated method stub
			
		}

		public void mousePressed(MouseEvent e) {
			EditorMapViewer mv = (EditorMapViewer)((JScrollPane)mapWindows.getSelectedComponent()).getViewport().getView();
			RenderableMap map = mv.getMap();
			int x = e.getX() / (int)(Texture.TILESIZE * map.getZoom());
			int y = e.getY() / (int)(Texture.TILESIZE * map.getZoom());

			switch (drawMode) {
			case PENCIL:
			case RECTANGLE:
			case ELLIPSE:
				Tile t = map.getTile(x, y);
				if (t == null)
					return;
				Texture tex = palette.getSelectedTexture();
				t.setTexture(tex, mv.getCurrentLayer());
				Graphics2D g = (Graphics2D)mv.getGraphics();
				map.getLayer(mv.getCurrentLayer()).drawNearbyTextures(new Point(x, y), g);
				g.dispose();
				break;
			case FILL:
			case SELECTION:
			}
			
		}

		public void mouseReleased(MouseEvent e) {
			
			
		}

		public void mouseEntered(MouseEvent e) {
			// TODO Auto-generated method stub
			
		}

		public void mouseExited(MouseEvent e) {
			// TODO Auto-generated method stub
			
		}

		public void mouseDragged(MouseEvent e) {
			switch (drawMode) {
			case PENCIL:
				mousePressed(e);
				mouseMoved(e);
				break;
			case RECTANGLE:
			case ELLIPSE:
			case FILL:
			case SELECTION:
			}
		}

		public void mouseMoved(MouseEvent e) {
			EditorMapViewer mv = (EditorMapViewer)((JScrollPane)mapWindows.getSelectedComponent()).getViewport().getView();
			RenderableMap map = mv.getMap();
			int x = e.getX() / (int)(Texture.TILESIZE * map.getZoom());
			int y = e.getY() / (int)(Texture.TILESIZE * map.getZoom());
			mv.highlight(new Point(x, y));			
		}
		
	}

}
