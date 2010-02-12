package net.tanatopia.o2d.editor;

import java.awt.BorderLayout;
import java.awt.Dimension;
import java.awt.Point;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;

import javax.imageio.ImageIO;
import javax.swing.JButton;
import javax.swing.JDialog;
import javax.swing.JFileChooser;
import javax.swing.JFrame;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.border.BevelBorder;

import net.tanatopia.o2d.io.PNGFilter;
import net.tanatopia.o2d.io.ResourceManager;
import net.tanatopia.o2d.io.XMLFilter;
import net.tanatopia.o2d.map.Texture;
import net.tanatopia.o2d.map.TextureFactory;

import org.jdom.Document;
import org.jdom.input.SAXBuilder;
import org.jdom.output.Format;
import org.jdom.output.XMLOutputter;



public class PaletteEditor extends JDialog {
	// GUI Elements
	private Palette palette;
	private JPanel controls;
	private TextureViewer texView;
	private JFileChooser fileChooser;
	private JPanel buttonPanel;
	private JButton bNew;
	private JButton bLoad;
	private JButton bSave;
	private JButton bImport;
	
	public PaletteEditor(JFrame owner, Palette palette) {
		super(owner, "Palette Editor", true);
		this.palette = palette;
		controls = new JPanel(true);
		texView = new TextureViewer();
		texView.setPreferredSize(new Dimension(400, 66));
		fileChooser = new JFileChooser(ResourceManager.getDirectory("textures"));
		fileChooser.setPreferredSize(new Dimension(400, 400));
		fileChooser.setMaximumSize(new Dimension(400, 400));
		fileChooser.addActionListener(new ActionFile());
		fileChooser.setBorder(new BevelBorder(BevelBorder.LOWERED));
		fileChooser.setFileFilter(new PNGFilter());
		buttonPanel = new JPanel(true);
		
		bNew = new JButton("New Palette");
		bNew.addActionListener(new ActionNew());
		bLoad = new JButton("Load Palette");
		bLoad.addActionListener(new ActionLoad());
		bSave = new JButton("Save Palette");
		bSave.addActionListener(new ActionSave());
		bImport = new JButton("Import and tile image...");
		bImport.addActionListener(new ActionImport());
		
		buttonPanel.add(bNew);
		buttonPanel.add(bLoad);
		buttonPanel.add(bSave);
		buttonPanel.add(bImport);
		
		controls.setLayout(new BorderLayout());
		controls.add(texView, BorderLayout.NORTH);
		controls.add(fileChooser, BorderLayout.CENTER);
		controls.add(buttonPanel, BorderLayout.SOUTH);
		
		setLayout(new BorderLayout());
		
		add(palette, BorderLayout.WEST);
		add(controls, BorderLayout.EAST);
		
		pack();
	}
	
	public Palette getPalette() {
		return palette;
	}
	
	private class ActionNew implements ActionListener {
		public void actionPerformed(ActionEvent e) {
			remove(palette);
			palette = new Palette();
			palette.setVisible(true);
			palette.setBorder(new BevelBorder(BevelBorder.LOWERED));
			add(palette, BorderLayout.WEST);
			pack();			
		}		
	}
	
	private class ActionLoad implements ActionListener {
		public void actionPerformed(ActionEvent e) {
			JFileChooser fc = new JFileChooser(ResourceManager.getDirectory("palettes"));
			fc.setFileFilter(new XMLFilter());
			int result = fc.showOpenDialog(PaletteEditor.this);
			if (result == JFileChooser.APPROVE_OPTION) {
				SAXBuilder parser = new SAXBuilder(false);
				Document doc = null;
				
				try {
					doc = parser.build(fc.getSelectedFile());
				} catch (Exception ex) {
					ex.printStackTrace();
					JOptionPane.showMessageDialog(PaletteEditor.this, "Invalid palette data file.",
							"Invalid palette data file.", JOptionPane.ERROR_MESSAGE);
				}

				remove(palette);
				palette = new Palette(doc);
				palette.setVisible(true);
				palette.setBorder(new BevelBorder(BevelBorder.LOWERED));
				add(palette, BorderLayout.WEST);
				pack();
				repaint();
			}		
		}		
	}
	
	private class ActionSave implements ActionListener {
		public void actionPerformed(ActionEvent e) {
			JFileChooser fc = new JFileChooser(ResourceManager.getDirectory("palettes"));
			fc.setFileFilter(new XMLFilter());
			int result = fc.showSaveDialog(PaletteEditor.this);
			if (result == JFileChooser.APPROVE_OPTION) {
				XMLOutputter outputter = new XMLOutputter();
				outputter.setFormat(Format.getPrettyFormat());
				try {
					outputter.output(palette.getXML(), new FileOutputStream(fc.getSelectedFile()));
				} catch (Exception ex) {
					ex.printStackTrace();
					System.exit(-1);
				}

			}
			
		}
		
	}
	
	private class ActionFile implements ActionListener {
		public void actionPerformed(ActionEvent e) {
			if (e.getActionCommand().equals(JFileChooser.APPROVE_SELECTION)) {
				String fileName = fileChooser.getSelectedFile().getAbsolutePath();
				fileName = fileName.substring(fileName.lastIndexOf("textures") + "textures".length() + 1);
				fileName = fileName.substring(0, fileName.lastIndexOf("."));

				Texture tex = TextureFactory.create(fileName);

				texView.setTexture(tex);
				palette.addTexture(tex);
			}	
		}	
	}
	
	private class ActionImport implements ActionListener {
		final BusyDialog busy = new BusyDialog(PaletteEditor.this, "Importing...");
		
		public void actionPerformed(ActionEvent e) {
			SwingWorker sw = new SwingWorker() {
				public Object construct() {
					JFileChooser fc = new JFileChooser();
					fc.setFileFilter(new PNGFilter());
					int result = fc.showOpenDialog(PaletteEditor.this);
					if (result == JFileChooser.APPROVE_OPTION) {
						busy.display();
						File f = fc.getSelectedFile();
						try {
							String imgName = f.getName();
							BufferedImage img = ImageIO.read(f);
							
							// Check if image is in proper proportions
							if (img.getWidth() % Texture.TILESIZE != 0 ||
									img.getHeight() % Texture.TILESIZE != 0)
								return false;
							
							// Make new texture directory
							File textureDir = ResourceManager.getDirectory("textures");
							File dir = new File(textureDir, imgName.substring(0, imgName.lastIndexOf(".")));
							if (!dir.mkdir())
								return false;
							
							// Start looping through file
							int w = img.getWidth() / Texture.TILESIZE;
							int h = img.getHeight() / Texture.TILESIZE;
							int n = 1;
							
							for (int j = 0; j < h; ++j) {
								for (int i = 0; i < w; ++i) {
									BufferedImage temp = img.getSubimage(
											i * Texture.TILESIZE, j * Texture.TILESIZE,
											Texture.TILESIZE, Texture.TILESIZE);
									
									String name = "" + n++;
									while (name.length() < 5)
										name = "0" + name;
									String filename = name + ".png";
									
									// Write to disk, bail on fail
									if (!ImageIO.write(temp, "png", new File(dir, filename)))
										return false;
									System.err.println("Creating texture: " + dir.getName() + "/" + name);
									Texture t = TextureFactory.create(dir.getName() + "/" + name);
									palette.addTexture(t, new Point(i, j));
								}
							}
						} catch (IOException e) {
							e.printStackTrace();
							return false;
						} finally {
							palette.reinitialize();
							busy.setVisible(false);
						}						
					}
					return true;
				}
			};
			
			sw.start();

		}

	}
}
