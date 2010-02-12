package net.tanatopia.sp.games.tactics;

import net.tanatopia.sp.games.tactics.*;
import javax.imageio.ImageIO;
import javax.swing.JComponent;
import java.awt.Graphics;
import java.awt.Dimension;
import java.awt.image.BufferedImage;
import java.io.File;


public class TileCursor extends JComponent {


	public static final int HEIGHT_OFFSET = 64;


	private BufferedImage imgCursor;



	public TileCursor(String sFilename) {
		try {
			imgCursor = ImageIO.read(new File(sFilename));
		} catch (Exception e) {
			e.printStackTrace();
			System.exit(-1);
		}
		setLayout(null);
		setVisible(true);
		setOpaque(false);
		setSize(new Dimension(64, 96));
	}

	protected void paintComponent(Graphics g) {
		if (imgCursor == null)
			return;

		g.drawImage(imgCursor, 0, 0, this);
	}
}