package net.tanatopia.o2d.editor;

import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Graphics;
import java.awt.GridLayout;
import java.awt.Image;
import java.awt.image.BufferedImage;

import javax.swing.BorderFactory;
import javax.swing.ImageIcon;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.border.BevelBorder;

import net.tanatopia.o2d.map.PlainTexture;
import net.tanatopia.o2d.map.Texture;

public class TextureViewer extends JPanel {
	JLabel image, name, status1, status2;
	JPanel rightSide;
	
	public TextureViewer() {
		
	}
	
	public void setTexture(Texture texture) {
		if (texture == null)
			return;
		int scale = Texture.TILESIZE * 2;
		removeAll();
		
		
		BufferedImage i = texture.getImage();
		Image img = createImage(scale, scale);
		Graphics g = img.getGraphics();
		g.drawImage(i, 0, 0, scale, scale, 0, 0, Texture.TILESIZE, Texture.TILESIZE, Color.WHITE, this);
		
		image = new JLabel(new ImageIcon(img));
		image.setBorder(new BevelBorder(BevelBorder.RAISED));
		name = new JLabel(texture.getName());
		if (texture instanceof PlainTexture)
			status1 = new JLabel("Plain texture");
		else
			status1 = new JLabel("Auto-texture");
		if (texture.isAnimated())
			status2 = new JLabel("Animated");
		else
			status2 = new JLabel("Not animated");
		
		rightSide = new JPanel(new GridLayout(3, 1), true);
		rightSide.add(name/*, BorderLayout.NORTH*/);
		rightSide.add(status1/*, BorderLayout.CENTER*/);
		rightSide.add(status2/*, BorderLayout.SOUTH*/);
		rightSide.setBorder(BorderFactory.createEmptyBorder(0, 5, 0, 0));
		
		setLayout(new BorderLayout());
		add(image, BorderLayout.WEST);
		add(rightSide, BorderLayout.CENTER);
		validate();
		repaint();
		setVisible(true);
	}
}
