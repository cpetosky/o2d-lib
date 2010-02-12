package net.tanatopia.sp.games.tactics;

import net.tanatopia.sp.games.tactics.*;
import java.awt.image.BufferedImage;
import java.awt.Graphics;
import java.awt.Dimension;
import java.awt.Insets;
import javax.swing.JComponent;
import java.awt.MediaTracker;
import java.util.LinkedList;
import java.util.ListIterator;
import javax.imageio.ImageIO;
import java.io.File;


public class Tile extends JComponent implements Comparable {
	public static final int TILE_WIDTH = 64;
	public static final int TILE_HEIGHT = 32;
	public static final int HEIGHT_OFFSET = 16;
	public static final int SIDE_TILE_WIDTH = 32;
	public static final int SIDE_TILE_HEIGHT = 32;

	private int ntX;
	private int ntY;
	private int nZ;
	private boolean bJumpable;
	private boolean bPassable;
	private int nTeam;

	protected boolean bMovePath;

	private BufferedImage imgTop;
	private transient BufferedImage imgMovePath;
	private LinkedList lLeft;
	private LinkedList lRight;
	private Avatar oAvatar;

	public Tile(BufferedImage imgTop) {
		this.imgTop = imgTop;
		nZ = 1;
		setLayout(null);
		setVisible(true);
		setOpaque(false);
		resize();
	}

	public Tile(int nZ, boolean bJumpable, boolean bPassable) {
		this.nZ = nZ;
		this.bJumpable = bJumpable;
		this.bPassable = bPassable;
		lLeft = new LinkedList();
		lRight = new LinkedList();
		setLayout(null);
		setVisible(true);
		setOpaque(false);
	}

	public Tile(int nZ, boolean bJumpable, boolean bPassable, BufferedImage imgTop) {
		this.imgTop = imgTop;
		this.nZ = nZ;
		this.bJumpable = bJumpable;
		this.bPassable = bPassable;
		lLeft = new LinkedList();
		lRight = new LinkedList();
		setLayout(null);
		setVisible(true);
		setOpaque(false);
		resize();
	}

	public void setAvatar(Avatar oAvatar) {
		this.oAvatar = oAvatar;
	}

	public void removeAvatar() {
		oAvatar = null;
	}

	public Avatar getAvatar() { return oAvatar; }

	public boolean hasAvatar() { return oAvatar != null ? true : false; }

	public void setDeployPoint(String sTeam) {
		if (sTeam.toUpperCase().equals("A"))
			nTeam = 1;
		else if (sTeam.toUpperCase().equals("B"))
			nTeam = 2;
		else
			nTeam = 0;
	}

	public boolean isDeployForTeam(int nTeam) {
		if (this.nTeam == nTeam)
			return true;
		else
			return false;
	}

	public void setTopTexture(BufferedImage imgTexture) {
		imgTop = imgTexture;
		resize();
	}

	public void addLeftTexture(BufferedImage imgTexture) {
		lLeft.addLast(imgTexture);
		resize();
	}

	public void addRightTexture(BufferedImage imgTexture) {
		lRight.addLast(imgTexture);
		resize();
	}

	//=========Moveability====================================================
	public boolean isPassable() {
		return bPassable;
	}

	public boolean isJumpable() {
		return bJumpable;
	}

	public void setMovePath() {
		if (imgMovePath == null)
			try {
				imgMovePath = ImageIO.read(new File("images/textures/move.png"));
			} catch (Exception e) { e.printStackTrace(); System.exit(-1); }

		bMovePath = true;
	}

	public boolean isMovePath() {
		return bMovePath;
	}

	public void resetMovePath() {
		bMovePath = false;
	}


	public int getMapX() { return ntX; }
	public int getMapY() { return ntY; }
	public int getZ() { return nZ; }
	public void setX(int ntX) { this.ntX = ntX; }
	public void setY(int ntY) { this.ntY = ntY; }
	public void setZ(int nZ) { this.nZ = nZ; }

	private void resize() {
		Dimension dSize = new Dimension(TILE_WIDTH, imgTop.getHeight());
		dSize.height +=
			((lLeft.size() > lRight.size()) ? lLeft.size() : lRight.size()) *
			(SIDE_TILE_HEIGHT / 2);
		setSize(dSize);
		repaint();
	}

	public int compareTo(Object oObject) {
		Tile oTile = (Tile)oObject;
		if (nZ == oTile.nZ)
			return 0;
		else if (nZ > oTile.nZ)
			return 1;
		else
			return -1;
	}

	protected void paintComponent(Graphics g) {
		Insets insets = getInsets();
		int npX = insets.left;
		int npY = insets.top;
		if (imgTop != null) {
			if (bMovePath)
				g.drawImage(imgMovePath, npX, npY, this);
			else
				g.drawImage(imgTop, npX, npY, this);
		}
		ListIterator iList = lLeft.listIterator(0);
		BufferedImage imgCurrent;
		npX = insets.left;
		npY = insets.top + imgTop.getHeight() - TILE_HEIGHT / 2;
		while (iList.hasNext()) {
			imgCurrent = (BufferedImage)iList.next();
			g.drawImage(imgCurrent, npX, npY, this);
			npY += SIDE_TILE_HEIGHT / 2;
		}

		npX = insets.left + SIDE_TILE_WIDTH;
		npY = insets.top + imgTop.getHeight() - TILE_HEIGHT / 2;
		iList = lRight.listIterator(0);
		while (iList.hasNext()) {
			imgCurrent = (BufferedImage)iList.next();
			g.drawImage(imgCurrent, npX, npY, this);
			npY += SIDE_TILE_HEIGHT / 2;
		}
	}
}


