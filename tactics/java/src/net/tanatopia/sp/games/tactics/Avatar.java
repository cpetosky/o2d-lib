package net.tanatopia.sp.games.tactics;

// Avatar.java
// Base Class for Avatar Types
// http://www.fftactics.net/fftmech/fftmech60.txt
import java.awt.Graphics;
import java.awt.Insets;
import java.awt.Dimension;
import java.awt.image.*;
import javax.imageio.*;
import java.io.*;
import javax.swing.*;

public class Avatar extends JComponent implements Serializable {
	static final long serialVersionUID = 2L; // File Version
	public static int WIDTH = 21;
	public static int HEIGHT = 37;

	protected int nRawHP; // Hidden HP modifier
	protected int nRawMP; // Hidden MP modifier
	protected int nRawPA; // Hidden Physical Attack modifier
	protected int nRawMA; // Hidden Magical Attack modifier
	protected int nRawSp; // Hidden Speed modifier

	protected Job[] oJobs;
	protected int nJob;

	protected Item oRightHand;
	protected Item oLeftHand;
	protected Item oHat;
	protected Item oBody;
	protected Item oAccessory;

	protected int move;
	protected int jump;
	protected int evade;
	protected int HPBase;
	protected int HP;
	protected int MPBase;
	protected int MP;
	protected int PABase;
	protected int PA;
	protected int MABase;
	protected int MA;
	protected int SpBase;
	protected int Sp;
	protected int braveBase;
	protected int brave;
	protected int faithBase;
	protected int faith;

	protected char cGender; // Either 'm' or 'f'

	protected String sName;
	protected int nZodiac;

	protected int nTileX;
	protected int nTileY;

	protected int CT;
	protected boolean AT;
	protected boolean bMoved;
	protected boolean bActed;

	protected int nColor;
	protected int nScalar;
	protected transient BufferedImage imgPortrait;
	protected transient Sprite imgSprite;
	protected transient BufferedImage imgDisplay;
	protected transient BufferedImage[] imgAnim;

	//============Constructors:===============================================

	public Avatar(char newGender, int newJob) {
		super();
		setLayout(null);
		setOpaque(false);
		setVisible(true);
		setSize(HEIGHT, WIDTH);

		cGender = newGender;

		nRawSp = 98304;
		braveBase = brave = 45 + (int)(Math.random() * 29);
		faithBase = faith = 45 + (int)(Math.random() * 29);

		if (cGender == 'm') {
			nRawPA = 81920;
			nRawMA = 65536;
			nRawHP = 491520 + (int)(Math.random() * 32767);
			nRawMP = 229376 + (int)(Math.random() * 16383);
		}
		else {
			nRawPA = 65536;
			nRawMA = 81920;
			nRawHP = 458752 + (int)(Math.random() * 32767);
			nRawMP = 245760 + (int)(Math.random() * 16383);
		}

		nZodiac = 1 + (int)(Math.random() * 11);

		CT = 0;
		AT = false;
		nTileX = -1;
		nTileY = -1;

		oJobs = new Job[Job.NUM_OF_JOBS];
		// Set up job array
		for (int i = 0; i < Job.NUM_OF_JOBS; i++)
			oJobs[i] = new Job(i);

		oRightHand = Job.getDefaultItem(nJob, Item.TYPE_WEAPON);


		// Set up class modifiers
		setJob(newJob);


	}
	//---------------------------setJob---------------------------------------
	public void setJob(int newJob) {
		nJob = newJob;

		resetBaseStats();
		resetStats();
	}
	//-----------------------resetBaseStats---------------------------------------
	public void resetBaseStats() {
		HPBase = (nRawHP * oJobs[nJob].getMult("HP")) / 1638400;
		MPBase = (nRawMP * oJobs[nJob].getMult("MP")) / 1638400;
		SpBase = (nRawSp * oJobs[nJob].getMult("Sp")) / 1638400;
		PABase = (nRawPA * oJobs[nJob].getMult("PA")) / 1638400;
		MABase = (nRawMA * oJobs[nJob].getMult("MA")) / 1683400;
	}

	//-----------------------resetStats-------------------------------------------
	public void resetStats() {
		HP = HPBase;
		MP = MPBase;
		Sp = SpBase;
		PA = PABase;
		MA = MABase;
		move = oJobs[nJob].getMove();
		jump = oJobs[nJob].getJump();
		evade = oJobs[nJob].getEvade();
		faith = faithBase;
		brave = braveBase;
	}

	public void incrementCT() {
		CT += Sp;
	}

	public boolean isATReady() {
		return CT >= 100;
	}

	public boolean hasAT() {
		return AT;
	}

	public void giveAT() {
		// Should give a blink animation here
		AT = true;
	}

	public void resetAT() {
		CT -= 60;
		if (bMoved)
			CT -= 20;
		if (bActed)
			CT -= 20;
		if (CT > 60)
			CT = 60;
		bMoved = bActed = AT = false;
	}

	//==========Accessors:====================================================

	public int getHP()				{ return HP; }
	public int getMP()				{ return MP; }
	public int getPA()				{ return PA; }
	public int getMA()				{ return MA; }
	public int getSpeed()			{ return Sp; }
	public int getEvade()			{ return evade; }
	public int getBrave()			{ return brave; }
	public int getFaith()			{ return faith; }
	public int getMove()			{ return move; }
	public int getJump()			{ return jump; }

	public Item getWeapon()			{ return oRightHand; }

	public String getJobName()		{ return oJobs[nJob].getName(); }
	public int getJobID()			{ return nJob; }
	public String getName()			{ return sName; }
	public char getGender()			{ return cGender; }
	public String getGenderString() {
		if (cGender == 'f')
			return "Female";
		else
			return "Male";
	}
	public int getZodiac()			{ return nZodiac; }
	public String getZodiacString() {
		switch (nZodiac) {
			case 1: return "Aries";
			case 2: return "Taurus";
			case 3: return "Gemini";
			case 4: return "Cancer";
			case 5: return "Leo";
			case 6: return "Virgo";
			case 7: return "Libra";
			case 8: return "Scorpio";
			case 9: return "Sagittarius";
			case 10: return "Capricorn";
			case 11: return "Aquarius";
			case 12: return "Pisces ";
			default: return "Serpentarius";
		}
	}

	public int getTileX() { return nTileX; }
	public int getTileY() { return nTileY; }

	public boolean getMoved() { return bMoved; }

	//===========Mutators=====================================================
	public void setName(String newName)				{ sName = newName; }

	public void setTileLocation(int nTileX, int nTileY) {
		this.nTileX = nTileX;
		this.nTileY = nTileY;
	}

	public void setMoved(boolean bMoved) {
		this.bMoved = bMoved;
	}

	public void setColor(int nColor) {
		this.nColor = nColor;
		setPortrait();
		setSprite();
		setImage(Sprite.FRONT_UNARMED);
	}

	public void resetImages() {
		setColor(nColor);
	}

	private void readObject(java.io.ObjectInputStream in)
							throws IOException, ClassNotFoundException {
		in.defaultReadObject();
		resetImages();
	}

	private void setSprite() {
		String sFileName = null;
		try {
			sFileName = "images/characters/" + nJob + "/sprites/" + (nColor) + ".gif";
			imgSprite = new Sprite(ImageIO.read(new File(sFileName)));
		}
		catch (Exception e) {
			e.printStackTrace();
			System.exit(-1);
		}

	}

	private void setPortrait() {
		String sFileName = null;
		try {
			sFileName = "images/characters/" + nJob + "/portraits/" + (nColor) + ".gif";
			imgPortrait = ImageIO.read(new File(sFileName));
		}
		catch (Exception e) {
			e.printStackTrace();
			System.exit(-1);
		}
	}

	public BufferedImage getPortrait() { return imgPortrait; }
	public Sprite getSprite() { return imgSprite; }

	public void setImage(int nType) {
		imgDisplay = imgSprite.getImage(nType);
		resize();
	}

	public void setScale(int nScalar) {
		this.nScalar = nScalar;
		resize();
	}

	private void resize() {
		Dimension size = new Dimension(imgDisplay.getWidth() * nScalar, imgDisplay.getHeight() * nScalar);
		setSize(size);
		setPreferredSize(size);

	}

	protected JMenu getActionMenu() {
		JMenu oActionMenu = new JMenu("Actions");
		JMenuItem oMenuItem = new JMenuItem("Attack");
		oMenuItem.setActionCommand("attack");
		oActionMenu.add(oMenuItem);

		return oActionMenu;
	}

	protected void paintComponent(Graphics g) {
		Insets insets = getInsets();

		if (imgSprite != null)
			g.drawImage(imgDisplay,
				insets.left,
				insets.top,
				imgDisplay.getWidth() * nScalar,
				imgDisplay.getHeight() * nScalar,
				this);

	}

	public String toString() {
		String sOutput = "";
		sOutput += "Name: " + sName + "\n";
		sOutput += "Job: " + oJobs[nJob].getName() + "\n";
		sOutput += "HP: " + HP + "/" + HPBase + "\n";
		sOutput += "MP: " + MP + "/" + MPBase + "\n";
		sOutput += "move: " + move + "/" + oJobs[nJob].getMove() + "\n";
		sOutput += "jump: " + jump + "/" + oJobs[nJob].getJump() + "\n";
		sOutput += "evade: " + evade + "/" + oJobs[nJob].getEvade() + "\n";
		sOutput += "PA: " + PA + "/" + PABase + "\n";
		sOutput += "MA: " + MA + "/" + MABase + "\n";
		sOutput += "Sp: " + Sp + "/" + SpBase + "\n";
		sOutput += "brave: " + brave + "/" + braveBase + "\n";
		sOutput += "faith: " + faith + "/" + faithBase + "\n";
		sOutput += "CT: " + CT + "/100" + "\n";

		return sOutput;

	}

	public static void main(String[] args) {
		Game.main(args);
	}
}


