package net.tanatopia.sp.games.tactics;

import java.io.Serializable;
import java.io.IOException;

public class Job implements Serializable {
	public static final int NUM_OF_JOBS =		20;
	public static final int JOB_SQUIRE =		0;
	public static final int JOB_CHEMIST =		1;
	public static final int JOB_KNIGHT =		2;
	public static final int JOB_ARCHER =		3;
	public static final int JOB_MONK =			4;
	public static final int JOB_PRIEST =		5;
	public static final int JOB_WIZARD =		6;
	public static final int JOB_TIMEMAGE =		7;
	public static final int JOB_SUMMONER =		8;
	public static final int JOB_THIEF =			9;
	public static final int JOB_MEDIATOR =		10;
	public static final int JOB_ORACLE =		11;
	public static final int JOB_GEOMANCER =		12;
	public static final int JOB_LANCER =		13;
	public static final int JOB_SAMURAI =		14;
	public static final int JOB_NINJA =			15;
	public static final int JOB_CALCULATOR =	16;
	public static final int JOB_BARD =			17;
	public static final int JOB_DANCER =		18;
	public static final int JOB_MIME =			19;

	protected int nID;
	protected int nTotalJP;
	protected int nSpendableJP;

	protected transient int nHPC; // Hidden Job nRawHP modifier
	protected transient int nMPC; // Hidden Job nRawMP modifier
	protected transient int nPAC; // Hidden Job nRawPA modifier
	protected transient int nMAC; // Hidden Job nRawMA modifier
	protected transient int nSpC; // Hidden Job nRawSp modifier

	protected transient int classHPMult; // Job HP Modifier
	protected transient int classMPMult; // Job MP Modifier
	protected transient int classPAMult; // Job Physical Attack Modifier
	protected transient int classMAMult; // Job Magical Attack Modifier
	protected transient int classSpMult; // Job Speed Modifier

	protected transient int moveBase;
	protected transient int jumpBase;
	protected transient int evadeBase;

	protected transient String sName;


	public Job(int newJob) {
		System.out.println("Creating new job:" + getJobName(newJob));
		nID = newJob;
		nTotalJP = nSpendableJP = 100 + (int)Math.floor((Math.random() * 100));
		resetStats();
	}

	private void readObject(java.io.ObjectInputStream in)
							throws IOException, ClassNotFoundException {
		in.defaultReadObject();
		resetStats();
	}

	public String getName() { return sName; }
	public int getID() { return nID; }
	public int getMove() { return moveBase; }
	public int getJump() { return jumpBase; }
	public int getEvade() { return evadeBase; }

	public int getMult(String sStat) {
		sStat = sStat.toUpperCase();
		if (sStat.equals("HP"))
			return classHPMult;
		else if (sStat.equals("MP"))
			return classMPMult;
		else if (sStat.equals("PA"))
			return classPAMult;
		else if (sStat.equals("MA"))
			return classMAMult;
		else if (sStat.equals("SP"))
			return classSpMult;
		else
			return -1;
	}

	public int getC(String sStat) {
		sStat = sStat.toUpperCase();
		if (sStat.equals("HP"))
			return nHPC;
		else if (sStat.equals("MP"))
			return nMPC;
		else if (sStat.equals("PA"))
			return nPAC;
		else if (sStat.equals("MA"))
			return nMAC;
		else if (sStat.equals("SP"))
			return nSpC;
		else
			return -1;
	}

	private void resetStats() {
		switch (nID) {
			case JOB_SQUIRE:
				sName = "Squire";
				nHPC = 11;
				nMPC = 15;
				nPAC = 60;
				nMAC = 50;
				nSpC = 100;
				classHPMult = 100;
				classMPMult = 75;
				classPAMult = 90;
				classMAMult = 80;
				classSpMult = 100;
				moveBase = 4;
				jumpBase = 3;
				evadeBase = 5;
				break;
			case JOB_CHEMIST:
				sName = "Chemist";
				nHPC = 12;
				nMPC = 16;
				nPAC = 75;
				nMAC = 50;
				nSpC = 100;
				classHPMult = 80;
				classMPMult = 75;
				classPAMult = 75;
				classMAMult = 80;
				classSpMult = 100;
				moveBase = 3;
				jumpBase = 3;
				evadeBase = 5;
				break;
			case JOB_KNIGHT:
				sName = "Knight";
				nHPC = 10;
				nMPC = 15;
				nPAC = 40;
				nMAC = 50;
				nSpC = 100;
				classHPMult = 120;
				classMPMult = 80;
				classPAMult = 120;
				classMAMult = 80;
				classSpMult = 100;
				moveBase = 3;
				jumpBase = 3;
				evadeBase = 10;
				break;
			case JOB_ARCHER:
				sName = "Archer";
				nHPC = 11;
				nMPC = 16;
				nPAC = 45;
				nMAC = 50;
				nSpC = 100;
				classHPMult = 100;
				classMPMult = 65;
				classPAMult = 110;
				classMAMult = 80;
				classSpMult = 100;
				moveBase = 3;
				jumpBase = 3;
				evadeBase = 10;
				break;
			case JOB_MONK:
				sName = "Monk";
				nHPC = 9;
				nMPC = 13;
				nPAC = 48;
				nMAC = 50;
				nSpC = 100;
				classHPMult = 135;
				classMPMult = 80;
				classPAMult = 129;
				classMAMult = 80;
				classSpMult = 110;
				moveBase = 3;
				jumpBase = 4;
				evadeBase = 20;
				break;
			case JOB_PRIEST:
				sName = "Priest";
				nHPC = 10;
				nMPC = 10;
				nPAC = 50;
				nMAC = 50;
				nSpC = 100;
				classHPMult = 80;
				classMPMult = 120;
				classPAMult = 90;
				classMAMult = 110;
				classSpMult = 110;
				moveBase = 4;
				jumpBase = 3;
				evadeBase = 5;
				break;
			case JOB_WIZARD:
				sName = "Wizard";
				nHPC = 12;
				nMPC = 9;
				nPAC = 60;
				nMAC = 50;
				nSpC = 100;
				classHPMult = 75;
				classMPMult = 120;
				classPAMult = 60;
				classMAMult = 150;
				classSpMult = 100;
				moveBase = 3;
				jumpBase = 3;
				evadeBase = 5;
				break;
			case JOB_TIMEMAGE:
				sName = "Time Mage";
				nHPC = 12;
				nMPC = 10;
				nPAC = 65;
				nMAC = 50;
				nSpC = 100;
				classHPMult = 75;
				classMPMult = 120;
				classPAMult = 50;
				classMAMult = 130;
				classSpMult = 100;
				moveBase = 3;
				jumpBase = 3;
				evadeBase = 5;
				break;
			case JOB_SUMMONER:
				sName = "Summoner";
				nHPC = 13;
				nMPC = 8;
				nPAC = 70;
				nMAC = 50;
				nSpC = 100;
				classHPMult = 70;
				classMPMult = 125;
				classPAMult = 50;
				classMAMult = 125;
				classSpMult = 90;
				moveBase = 3;
				jumpBase = 3;
				evadeBase = 5;
				break;
			case JOB_THIEF:
				sName = "Thief";
				nHPC = 11;
				nMPC = 16;
				nPAC = 50;
				nMAC = 50;
				nSpC = 90;
				classHPMult = 90;
				classMPMult = 50;
				classPAMult = 100;
				classMAMult = 60;
				classSpMult = 110;
				moveBase = 4;
				jumpBase = 4;
				evadeBase = 25;
				break;
			case JOB_MEDIATOR:
				sName = "Mediator";
				nHPC = 11;
				nMPC = 18;
				nPAC = 55;
				nMAC = 50;
				nSpC = 100;
				classHPMult = 80;
				classMPMult = 70;
				classPAMult = 75;
				classMAMult = 75;
				classSpMult = 100;
				moveBase = 3;
				jumpBase = 3;
				evadeBase = 5;
				break;
			case JOB_ORACLE:
				sName = "Oracle";
				nHPC = 12;
				nMPC = 10;
				nPAC = 60;
				nMAC = 50;
				nSpC = 100;
				classHPMult = 75;
				classMPMult = 110;
				classPAMult = 50;
				classMAMult = 120;
				classSpMult = 100;
				moveBase = 3;
				jumpBase = 3;
				evadeBase = 5;
				break;
			case JOB_GEOMANCER:
				sName = "Geomancer";
				nHPC = 10;
				nMPC = 11;
				nPAC = 45;
				nMAC = 50;
				nSpC = 100;
				classHPMult = 110;
				classMPMult = 95;
				classPAMult = 110;
				classMAMult = 105;
				classSpMult = 100;
				moveBase = 4;
				jumpBase = 3;
				evadeBase = 10;
				break;
			case JOB_LANCER:
				sName = "Lancer";
				nHPC = 10;
				nMPC = 15;
				nPAC = 40;
				nMAC = 50;
				nSpC = 100;
				classHPMult = 120;
				classMPMult = 75;
				classPAMult = 120;
				classMAMult = 50;
				classSpMult = 100;
				moveBase = 4;
				jumpBase = 3;
				evadeBase = 15;
				break;
			case JOB_SAMURAI:
				sName = "Samurai";
				nHPC = 12;
				nMPC = 14;
				nPAC = 45;
				nMAC = 50;
				nSpC = 100;
				classHPMult = 75;
				classMPMult = 75;
				classPAMult = 128;
				classMAMult = 90;
				classSpMult = 100;
				moveBase = 3;
				jumpBase = 3;
				evadeBase = 20;
				break;
			case JOB_NINJA:
				sName = "Ninja";
				nHPC = 12;
				nMPC = 13;
				nPAC = 43;
				nMAC = 50;
				nSpC = 80;
				classHPMult = 70;
				classMPMult = 50;
				classPAMult = 120;
				classMAMult = 75;
				classSpMult = 120;
				moveBase = 4;
				jumpBase = 4;
				evadeBase = 30;
				break;
			case JOB_CALCULATOR:
				sName = "Calculator";
				nHPC = 14;
				nMPC = 10;
				nPAC = 70;
				nMAC = 50;
				nSpC = 100;
				classHPMult = 65;
				classMPMult = 80;
				classPAMult = 50;
				classMAMult = 70;
				classSpMult = 50;
				moveBase = 3;
				jumpBase = 3;
				evadeBase = 5;
				break;
			case JOB_BARD:
				sName = "Bard";
				nHPC = 20;
				nMPC = 20;
				nPAC = 80;
				nMAC = 50;
				nSpC = 100;
				classHPMult = 55;
				classMPMult = 50;
				classPAMult = 30;
				classMAMult = 70;
				classSpMult = 50;
				moveBase = 3;
				jumpBase = 3;
				evadeBase = 5;
				break;
			case JOB_DANCER:
				sName = "Dancer";
				nHPC = 20;
				nMPC = 20;
				nPAC = 50;
				nMAC = 50;
				nSpC = 100;
				classHPMult = 60;
				classMPMult = 50;
				classPAMult = 110;
				classMAMult = 95;
				classSpMult = 100;
				moveBase = 3;
				jumpBase = 3;
				evadeBase = 5;
				break;
			case JOB_MIME:
				sName = "Mime";
				nHPC = 6;
				nMPC = 30;
				nPAC = 35;
				nMAC = 40;
				nSpC = 100;
				classHPMult = 140;
				classMPMult = 50;
				classPAMult = 120;
				classMAMult = 115;
				classSpMult = 120;
				moveBase = 4;
				jumpBase = 4;
				evadeBase = 5;
				break;
			default:
				System.out.println("ERROR in Job Constructor:  Job " + nID + " does not exist!");
				System.exit(-1);
		}
	}

	public static String getJobName(int nID) {
		switch (nID) {
			case JOB_SQUIRE:
				return "Squire";
			case JOB_CHEMIST:
				return "Chemist";
			case JOB_KNIGHT:
				return "Knight";
			case JOB_ARCHER:
				return "Archer";
			case JOB_MONK:
				return "Monk";
			case JOB_PRIEST:
				return "Priest";
			case JOB_WIZARD:
				return "Wizard";
			case JOB_TIMEMAGE:
				return "Time Mage";
			case JOB_SUMMONER:
				return "Summoner";
			case JOB_THIEF:
				return "Thief";
			case JOB_MEDIATOR:
				return "Mediator";
			case JOB_ORACLE:
				return "Oracle";
			case JOB_GEOMANCER:
				return "Geomancer";
			case JOB_LANCER:
				return "Lancer";
			case JOB_SAMURAI:
				return "Samurai";
			case JOB_NINJA:
				return "Ninja";
			case JOB_CALCULATOR:
				return "Calculator";
			case JOB_BARD:
				return "Bard";
			case JOB_DANCER:
				return "Dancer";
			case JOB_MIME:
				return "Mime";
			default:
				return "INVALID ID: " + nID;
		}
	}

	public static Item getDefaultItem(int nJobID, int nItemTypeID) {
		switch(nItemTypeID) {
			case Item.TYPE_WEAPON:
				switch (nJobID) {
					case JOB_CHEMIST:
					case JOB_THIEF:
					case JOB_NINJA:
					case JOB_MEDIATOR:
					case JOB_DANCER:
						return ItemFactory.createItem(Item.DAGGER_DAGGER);
					case JOB_SQUIRE:
					case JOB_KNIGHT:
					case JOB_GEOMANCER:
						return ItemFactory.createItem(Item.SWORD_BROADSWORD);
					case JOB_WIZARD:
					case JOB_SUMMONER:
					case JOB_ORACLE:
						return ItemFactory.createItem(Item.ROD_ROD);
					case JOB_PRIEST:
					case JOB_TIMEMAGE:
						return ItemFactory.createItem(Item.STAFF_OAKSTAFF);
					case JOB_MONK:
					case JOB_MIME:
					// next five don't belong here
					case JOB_ARCHER:
					case JOB_LANCER:
					case JOB_SAMURAI:
					case JOB_CALCULATOR:
					case JOB_BARD:
					default:
						return null;
				}
		}
		return null;
	}

}