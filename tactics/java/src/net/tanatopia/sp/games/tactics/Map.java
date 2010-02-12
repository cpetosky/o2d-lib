package net.tanatopia.sp.games.tactics;

import net.tanatopia.gen.arrays.ArrayKit;
import javax.imageio.ImageIO;
import javax.swing.JLayeredPane;
import javax.swing.JMenu;
import javax.swing.JMenuItem;
import javax.swing.JOptionPane;
import javax.swing.JPopupMenu;
import javax.swing.JScrollPane;
import javax.swing.JButton;
import java.awt.Dimension;
import java.awt.Insets;
import java.awt.Point;
import java.awt.event.KeyEvent;
import java.awt.event.MouseEvent;
import java.awt.event.KeyListener;
import java.awt.event.MouseListener;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.image.BufferedImage;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;

public class Map extends JScrollPane implements KeyListener, MouseListener, ActionListener {

	public static final int STATE_DEPLOY = 1;
	public static final int STATE_WAITING = 2;
	public static final int STATE_AT = 3;
	public static final int STATE_MOVING = 4;

	private JLayeredPane lPane;
	private JScrollPane scrollPane;
	private JButton oButton1;

	private Tile[][] oTiles;
	private String[] sTextures;
	private BufferedImage[] oTextures;
	private int ntWidth;
	private int ntHeight;

	private TileCursor oCursor;
	private boolean bKeyActive;
	private int nCursorX;
	private int nCursorY;
	private boolean bMouseActive;

	private int nDeployedAvatars;

	private int nState;

	public Map(int nXSize, int nYSize) {
		super();
		setMinimumSize(new Dimension(nXSize, nYSize));
		setMaximumSize(new Dimension(nXSize, nYSize));
		setPreferredSize(new Dimension(nXSize, nYSize));

		oCursor = new TileCursor("images/textures/cursor.png");
		oButton1 = new JButton();
		lPane = new JLayeredPane();
		lPane.setOpaque(true);
		lPane.setVisible(true);
		//setViewportView(lPane);

	}

	public void setButtonEvents(ActionListener al) {
		oButton1.addActionListener(al);
	}


	public void clear() {
		oTiles = null;
		sTextures = null;
		oTextures = null;
		ntWidth = 0;
		ntHeight = 0;
		nDeployedAvatars = 0;
		lPane.removeAll();
	}

	public void prepareDeploy(int nTeam) {
		for (int x = 0; x < oTiles.length; x++)
			for (int y = 0; y < oTiles.length; y++)
				if (!oTiles[x][y].isDeployForTeam(nTeam))
					oTiles[x][y].setVisible(false);

		nState = STATE_DEPLOY;

	}

	public void prepareWaiting() {
		nState = STATE_WAITING;
		assignActiveAvatar();
	}

	public void prepareAT() {
		nState = STATE_AT;
		assignActiveAvatar();
	}

	private void assignActiveAvatar() {
		for (int x = 0; x < oTiles.length; x++)
		for (int y = 0; y < oTiles[x].length; y++)
			if (oTiles[x][y].hasAvatar())
				if (oTiles[x][y].getAvatar().hasAT()) {
					Game.oActiveAvatar = oTiles[x][y].getAvatar();
					System.out.println("Active Avatar: " + Game.oActiveAvatar);
					return;
				}
	}


	public boolean loadMap(File oFile) throws FileNotFoundException {
		clear();

		// Set up map
		BufferedReader fIn = new BufferedReader(new FileReader(oFile));

		try {
			// Get width and height, and tilesizes of map
			String[] sData = fIn.readLine().split(" ");
			ntWidth = Integer.parseInt(sData[0]);
			ntHeight = Integer.parseInt(sData[1]);
			int npCoreY = Integer.parseInt(sData[2]) * Tile.HEIGHT_OFFSET;

			oTiles = new Tile[ntWidth][ntHeight];

			// Set up images used
			sTextures = fIn.readLine().split(" ");
			ArrayKit.sort(sTextures);

			oTextures = new BufferedImage[sTextures.length];

			String sFileName = null;
			try {
				for (int i = 0; i < oTextures.length; i++) {
					sFileName = "images/textures/" + sTextures[i] + ".png";
					oTextures[i] = ImageIO.read(new File(sFileName));
				}
			}
			catch (Exception e) {
				JOptionPane.showMessageDialog(
					null,
					e.getMessage() + "\n" + sFileName,
					"Error!",
					JOptionPane.ERROR_MESSAGE);
				System.exit(-1);
			}

			int npBaseX;
			int npBaseY;
			int npRealX;
			int npRealY;
			int nLayer = 0;

			npCoreY += (oTiles[0].length * (Tile.TILE_HEIGHT / 2)) + 25;

			// Parse map data
			for (int x = 0; x < oTiles.length; x++) {
				nLayer += oTiles[x].length + 1;
				npBaseX = x * (Tile.TILE_WIDTH / 2);
				npBaseY = npCoreY + (x * (Tile.TILE_HEIGHT / 2));
				for (int y = 0; y < oTiles[x].length; y++) {
					npRealX = npBaseX;
					npRealY = npBaseY - (Tile.HEIGHT_OFFSET * ntHeight) + npCoreY;
					nLayer--;
					oTiles[x][y] = parseLine1(fIn.readLine());
					parseLine2(fIn.readLine(), oTiles[x][y]);
					parseLine3(fIn.readLine(), oTiles[x][y]);
					parseLine4(fIn.readLine(), oTiles[x][y]);

					Insets insets = getInsets();
					int nHeightModifier = oTiles[x][y].getZ() * Tile.HEIGHT_OFFSET;
					oTiles[x][y].setX(x);
					oTiles[x][y].setY(y);
					oTiles[x][y].setLocation(insets.left + npRealX, insets.top + npRealY - Tile.TILE_HEIGHT - nHeightModifier);
					oTiles[x][y].addMouseListener(this);
					lPane.add(oTiles[x][y], new Integer(nLayer));

					npBaseX += (Tile.TILE_WIDTH / 2);
					npBaseY -= (Tile.TILE_HEIGHT / 2);

				}
			}
		}
		catch (Exception e) {
			e.printStackTrace();
			System.exit(-1);
		}

		lPane.repaint();

		lPane.add(oCursor, new Integer(oTiles[0].length), 0);

		nCursorX = nCursorY = 0;
		setTileCursorLocation(0, 0);
		bKeyActive = true;

		Dimension size = new Dimension();
		size.width = oTiles[oTiles.length - 1][oTiles[0].length - 1].getLocation().x;
		size.width += Tile.TILE_WIDTH;
		size.height = oTiles[oTiles.length - 1][0].getLocation().y;
		size.height += Tile.TILE_HEIGHT;
		size.height += oTiles[oTiles.length - 1][0].getZ() * Tile.HEIGHT_OFFSET;
		lPane.setPreferredSize(size);
		setViewportView(lPane);

		return true;
	}

	/**
	 Parses the first line of a map data file foursome, and creates a
	 new Tile object from the information parsed.
	 <p>
	 The format of this line is
	 <code>height {passable/jumpable/obstacle} [A/B]</code>

	 @param		sLine	the string to be parsed
	 @return	the tile created
	 @throws	FileFormatException	If line is not in specified format
	*/
	private Tile parseLine1(String sLine) throws FileFormatException {
		String[] sData = sLine.split(" ");
		if (sData.length < 2 || sData.length > 3)
			throw new FileFormatException("\"" + sData + "\" is not in the proper format!");

		boolean bPassable;
		boolean bJumpable;

		if (sData[1].equals("jumpable")) {
			bPassable = false;
			bJumpable = true;
		}
		else if (sData[1].equals("obstacle")) {
			bPassable = false;
			bJumpable = false;
		}
		else {
			bPassable = true;
			bJumpable = true;
		}

		Tile oTile = new Tile(Integer.parseInt(sData[0]), bJumpable, bPassable);

		if (sData.length == 3)
			oTile.setDeployPoint(sData[2]);

		return oTile;
	}

	/**
	 Parses the second line of a map data file foursome, and modifies a
	 new Tile object with the information parsed.
	 <p>
	 The format of this line is
	 <code>toptexturename[,toptextureframe2[,...]]</code>

	 @param		sLine	the string to be parsed
	 @param		oTile	the tile to be modified
	 @throws	MissingTextureException	If one or more textures are not loaded
	*/
	private void parseLine2(String sLine, Tile oTile) throws MissingTextureException{
		if (sLine.equals(""))
			return;
		String[] sTops = sLine.split(",");

		// Animations NOT IMPLEMENTED yet!  So just use first filename.
		int nIndex = ArrayKit.search(sTextures, sTops[0]);
		if (nIndex == -1)
			throw new MissingTextureException(
				"\"" + sTops[0] + "\" not found!");
		oTile.setTopTexture(oTextures[nIndex]);
	}

	/**
	 Parses the third line of a map data file foursome, and modified a
	 Tile object with the information parsed.
	 <p>
	 The format of this line is
	 <code>lefttex1[,lefttex1frame2[,...]][;lefttex2[,lefttex2frame2[,...]][;...]]</code>

	 @param		sLine	the string to be parsed
	 @param		oTile	the tile to be modified
	 @throws	MissingTextureException	If one or more textures are not loaded
	*/
	private void parseLine3(String sLine, Tile oTile) throws MissingTextureException{
		if (sLine.equals(""))
			return;

		String[] sLeftTemps = sLine.split(";");
		String[][] sLefts = new String[sLeftTemps.length][1];

		for (int i = 0; i < sLefts.length; i++)
			sLefts[i] = sLeftTemps[i].split(",");

		// Animation NOT IMPLEMENTED!  So just use one image per block

		int nIndex;
		for (int x = 0; x < sLefts.length; x++) {
			nIndex = ArrayKit.search(sTextures, sLefts[x][0]);
			if (nIndex == -1)
				throw new MissingTextureException(
					"\"" + sLefts[x][0] + "\" not found!");

			oTile.addLeftTexture(oTextures[nIndex]);
		}
	}

	/**
	 Parses the fourth line of a map data file foursome, and modifies a
	 Tile object with the information parsed.
	 <p>
	 The format of this line is
	 <code>righttex1[,righttex1frame2[,...]][;righttex2[,righttex2frame2[,...]][;...]]</code>

	 @param		sLine	the string to be parsed
	 @param		oTile	the tile to be modified
	 @throws	MissingTextureException	If one or more textures are not loaded
	*/
	private void parseLine4(String sLine, Tile oTile) throws MissingTextureException{
		if (sLine.equals(""))
			return;

		String[] sRightTemps = sLine.split(";");
		String[][] sRights = new String[sRightTemps.length][1];

		for (int i = 0; i < sRights.length; i++)
			sRights[i] = sRightTemps[i].split(",");

		// Animation NOT IMPLEMENTED!  So just use one image per block

		int nIndex;
		for (int x = 0; x < sRights.length; x++) {
			nIndex = ArrayKit.search(sTextures, sRights[x][0]);
			if (nIndex == -1)
				throw new MissingTextureException(
					"\"" + sRights[x][0] + "\" not found!");

			oTile.addRightTexture(oTextures[nIndex]);
		}
	}

	public void setTileCursorLocation(int nX, int nY) {
		if (nX < 0 || nX >= oTiles.length || nY < 0 || nY >= oTiles.length)
			return;

		Point pLoc = oTiles[nX][nY].getLocation();
		pLoc.y -= TileCursor.HEIGHT_OFFSET;
		oCursor.setLocation(pLoc);

		nCursorX = nX;
		nCursorY = nY;
		lPane.setLayer(oCursor, oTiles[0].length + nX - nY, 0);
		String sText = Game.lblStatus3.getText();
		int nIndex = sText.indexOf("  Cursor: ");
		if (nIndex > 0)
			sText = sText.substring(0, nIndex);
		Game.lblStatus3.setText(sText + "  Cursor: " + nX + "," + nY);
	}

	public void moveCursorToAT() {
		for (int x = 0; x < oTiles.length; x++)
		for (int y = 0; y < oTiles[x].length; y++)
			if (oTiles[x][y].hasAvatar())
				if (oTiles[x][y].getAvatar().hasAT())
					setTileCursorLocation(oTiles[x][y].getMapX(),
						oTiles[x][y].getMapY());
	}

	public void deployAvatar(Tile oTile) {
		if (oTile.getAvatar() != null)
			return;

		if (oTile.isVisible()) {
			Avatar oAvatar = Game.oParty.getAvatar(nDeployedAvatars++);
			setAvatarLocation(oAvatar, oTile);
			lPane.add(oAvatar, new Integer(lPane.getLayer(oTile)), 0);
		}
		if (nDeployedAvatars == Party.PARTY_SIZE) {
			oButton1.setActionCommand("preplay");
			oButton1.doClick();
		}
	}

	private void setAvatarLocation(Avatar oAvatar, Tile oTile) {
		if (oAvatar.getTileX() >= 0 && oAvatar.getTileY() >= 0)
			oTiles[oAvatar.getTileX()][oAvatar.getTileY()].removeAvatar();
		Point pLoc = oTile.getLocation();
		oAvatar.setImage(Sprite.FRONT_UNARMED);
		oAvatar.setScale(2);

		pLoc.x += ((oTile.getWidth() - oAvatar.getWidth()) / 2);
		pLoc.y -= oAvatar.getHeight();
		pLoc.y += (Tile.TILE_HEIGHT / 2) + 4;
		oAvatar.setLocation(pLoc);
		oAvatar.setTileLocation(oTile.getMapX(), oTile.getMapY());
		oTile.setAvatar(oAvatar);
	}


	public void prepareForPlay() {
		nState = STATE_WAITING;
		for (int x = 0; x < oTiles.length; x++)
			for (int y = 0; y < oTiles.length; y++)
					oTiles[x][y].setVisible(true);
	}

	/**
	 Invoked when a key has been pressed.  This handles moving the cursor
	 from tile to tile.
	*/
	public void keyPressed(KeyEvent e) {
		if (!bKeyActive)
			return;

		switch (e.getKeyCode()) {
		case KeyEvent.VK_UP:
		case KeyEvent.VK_KP_UP:
			setTileCursorLocation(nCursorX - 1, nCursorY);
			break;
		case KeyEvent.VK_DOWN:
		case KeyEvent.VK_KP_DOWN:
			setTileCursorLocation(nCursorX + 1, nCursorY);
			break;
		case KeyEvent.VK_LEFT:
		case KeyEvent.VK_KP_LEFT:
			setTileCursorLocation(nCursorX, nCursorY - 1);
			break;
		case KeyEvent.VK_RIGHT:
		case KeyEvent.VK_KP_RIGHT:
			setTileCursorLocation(nCursorX, nCursorY + 1);
			break;
		case KeyEvent.VK_ENTER:
			switch (nState) {
			case STATE_DEPLOY:
				deployAvatar(oTiles[nCursorX][nCursorY]);
				break;
			case STATE_AT:
				if (!oTiles[nCursorX][nCursorY].hasAvatar()) {
					moveCursorToAT();
					showATMenu();
				} else if (oTiles[nCursorX][nCursorY].getAvatar().hasAT())
					showATMenu();
				break;
			case STATE_MOVING:
				if (oTiles[nCursorX][nCursorY].isMovePath())
					performMove(oTiles[nCursorX][nCursorY]);
				break;
			}
			break;
		}
	}

	public void showATMenu() {
		Point pLoc = oCursor.getLocation();
		pLoc.y += TileCursor.HEIGHT_OFFSET;
		pLoc.x += Tile.TILE_WIDTH;

		ATPopup oATMenu = new ATPopup(this, Game.oActiveAvatar);

		oATMenu.show(lPane, pLoc.x, pLoc.y);
	}

	public void keyReleased(KeyEvent e) {}
	public void keyTyped(KeyEvent e) {}

	public void mouseClicked(MouseEvent e) {}

	public void mouseEntered(MouseEvent e) {
		Tile oTile = (Tile)e.getSource();
		setTileCursorLocation(oTile.getMapX(), oTile.getMapY());
		requestFocus();
	}

	public void mouseExited(MouseEvent e) {}

	public void mousePressed(MouseEvent e) {
		switch (nState) {
		case STATE_DEPLOY:
			deployAvatar((Tile)e.getSource());
			break;
		case STATE_AT:
			switch (e.getButton()) {
			case MouseEvent.BUTTON1:
			case MouseEvent.BUTTON2:
				if (!((Tile)e.getSource()).hasAvatar()) {
					moveCursorToAT();
					showATMenu();
				} else if (((Tile)e.getSource()).getAvatar().hasAT())
					showATMenu();
				break;
			}
			break;
		case STATE_MOVING:
			switch (e.getButton()) {
			case MouseEvent.BUTTON1:
				if (((Tile)e.getSource()).isMovePath())
					performMove((Tile)e.getSource());
				break;
			}
			break;

		}
	}

	public void performMove(Tile oTile)	{

		moveATAvatar(oTile);
		resetTiles();
		prepareAT();
		oButton1.setActionCommand("move");
		oButton1.doClick();
	}

	public void mouseReleased(MouseEvent e) {}

	public void actionPerformed(ActionEvent e) {
		String sCommand = e.getActionCommand();
		if (e.getSource().getClass().getName().equals("javax.swing.JMenuItem")) {
			if (sCommand.equals("move")) {
				prepareMove(Game.oActiveAvatar.getTileX() + 1, Game.oActiveAvatar.getTileY(), Game.oActiveAvatar.getTileX(), Game.oActiveAvatar.getTileY(), Game.oActiveAvatar.getMove() - 1);
				prepareMove(Game.oActiveAvatar.getTileX() - 1, Game.oActiveAvatar.getTileY(), Game.oActiveAvatar.getTileX(), Game.oActiveAvatar.getTileY(), Game.oActiveAvatar.getMove() - 1);
				prepareMove(Game.oActiveAvatar.getTileX(), Game.oActiveAvatar.getTileY() + 1, Game.oActiveAvatar.getTileX(), Game.oActiveAvatar.getTileY(), Game.oActiveAvatar.getMove() - 1);
				prepareMove(Game.oActiveAvatar.getTileX(), Game.oActiveAvatar.getTileY() - 1, Game.oActiveAvatar.getTileX(), Game.oActiveAvatar.getTileY(), Game.oActiveAvatar.getMove() - 1);
				nState = STATE_MOVING;
			} else {
				GameAction oAction = ActionFactory.createAction(sCommand, Game.oActiveAvatar);
			}
		} else {
			oButton1.setActionCommand(sCommand);
			oButton1.doClick();
		}
	}

	private void prepareMove(int nX, int nY, int nOldX, int nOldY, int nHopsLeft) {
		setTileCursorLocation(nX, nY);
		if (nX < 0 || nX >= oTiles.length || nY < 0 || nY >= oTiles[0].length) {
			return;
		}

		Tile oTile = oTiles[nX][nY];

		if (oTile.getAvatar() != null) {
			return;
		}

		if (!oTile.isPassable()) {
			System.out.println("At obstacle: nHopsLeft = " + nHopsLeft + " and oTile isJumpable:" + oTile.isJumpable());
			if (nHopsLeft > 0 && oTile.isJumpable()) {
				nX += (nX - nOldX);
				nY += (nY - nOldY);
				nHopsLeft -= 1;
				prepareMove(nX, nY, nOldX, nOldY, nHopsLeft);
				return;
			} else {
				return;
			}
		}


		oTile.setMovePath();
		repaint();
		if (nHopsLeft == 0) {
			return;
		}
		nHopsLeft--;

		// Call for each tile in all four directions
		prepareMove(nX + 1, nY, nX, nY, nHopsLeft);
		prepareMove(nX - 1, nY, nX, nY, nHopsLeft);
		prepareMove(nX, nY + 1, nX, nY, nHopsLeft);
		prepareMove(nX, nY - 1, nX, nY, nHopsLeft);

	}

	private void resetTiles() {
		for (int x = 0; x < oTiles.length; x++)
		for (int y = 0; y < oTiles[x].length; y++)
			oTiles[x][y].resetMovePath();

		lPane.repaint();
	}

	public void moveATAvatar(int nX, int nY) {
		moveATAvatar(oTiles[nX][nY]);
	}

	public void moveATAvatar(Tile oTile) {
		setAvatarLocation(Game.oActiveAvatar, oTile);
		lPane.setLayer(Game.oActiveAvatar, lPane.getLayer(oTile), 0);
		Game.oActiveAvatar.setMoved(true);
	}

	public void addOpponentParty() {
		for (int i = 0; i < Game.oOpponentParty.getSize(); i++) {
			Avatar oAvatar = Game.oOpponentParty.getAvatar(i);
			int nX = oAvatar.getTileX();
			int nY = oAvatar.getTileY();
			oTiles[nX][nY].setAvatar(oAvatar);
			lPane.add(oAvatar, new Integer(lPane.getLayer(oTiles[nX][nY])), 0);
		}
	}

	public static void main(String[] args) {
		Game.main(args);
	}

	private class ATPopup extends JPopupMenu {
		public ATPopup(ActionListener al, Avatar oAvatar) {
			super("AT Menu");
			JMenuItem oMenuItem;
			if (!oAvatar.getMoved()) {
				oMenuItem = new JMenuItem("Move");
				oMenuItem.setActionCommand("move");
				oMenuItem.addActionListener(al);
				add(oMenuItem);
			}

			JMenu oActionMenu = oAvatar.getActionMenu();

			for (int i = 0; i < oActionMenu.getItemCount(); i++) {
				oMenuItem = oActionMenu.getItem(i);
				if (oMenuItem != null) {
					oMenuItem.addActionListener(al);
				}
			}

			add(oActionMenu);
		}
	}

	private class FileFormatException extends Exception {
		public FileFormatException(String message) {
			super(message);
		}
	}

	private class MissingTextureException extends Exception {
		public MissingTextureException(String message) {
			super(message);
		}
	}

}