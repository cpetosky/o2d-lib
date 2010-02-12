package net.tanatopia.sp.games.tactics;

import net.tanatopia.sp.games.tactics.*;

public class GameAction {

	public static final int TYPE_PHYSICAL =		1;
	public static final int TYPE_MAGICAL =		2;
	public static final int TYPE_NEUTRAL =		3;

	public static final int ELEM_FIRE =			1;
	public static final int ELEM_ICE =			2;
	public static final int ELEM_LIGHTNING =	3;
	public static final int ELEM_AIR =			4;
	public static final int ELEM_WATER =		5;
	public static final int ELEM_EARTH =		6;
	public static final int ELEM_HOLY =			7;
	public static final int ELEM_DARK =			8;
	public static final int ELEM_WEAPON =		9;
	public static final int ELEM_NEUTRAL =		10;

	public static final int MOD_ATTACK =		1;

	private Avatar avaOwner;
	private Avatar avaTarget;

	private String sName;
	private int nDamage;
	private int nHit;  // Hit %
	private int nXA;   // Determining Damage
	private int nType; // Physical/Magical/Neutral
	private int nElemental;
	private boolean bReflect; // Reflectable
	private boolean bCalculate; // Calculatable
	private boolean bCGrasp; // Countergraspable
	private boolean bCMagic; // Countermagicable
	private boolean bCFlood; // Counterfloodable
	private boolean bEvade; // Evadable
	private int nMPCost;
	private int nCTR;
	private int nMod;
	private int nRangeXY;
	private int nRangeZ;
	private int nEffectXY;
	private int nEffectZ;

	public GameAction(Avatar avaOwner,
					  String sName,
					  int nHit,
					  int nXA,
					  int nType,
					  int nElemental,
					  boolean bReflect,
					  boolean bCalculate,
					  boolean bCGrasp,
					  boolean bCMagic,
					  boolean bCFlood,
					  boolean bEvade,
					  int nMPCost,
					  int nCTR,
					  int nMod,
					  int nRangeXY,
					  int nRangeZ,
					  int nEffectXY,
					  int nEffectZ) {
		this.avaOwner = avaOwner;
		this.sName = sName;
		this.nHit = nHit;
		this.nXA = nXA;
		this.nType = nType;
		this.nElemental = nElemental;
		this.bReflect = bReflect;
		this.bCalculate = bCalculate;
		this.bCGrasp = bCGrasp;
		this.bCMagic = bCMagic;
		this.bCFlood = bCFlood;
		this.bEvade = bEvade;
		this.nMPCost = nMPCost;
		this.nCTR = nCTR;
		this.nMod = nMod;
		this.nRangeXY = nRangeXY;
		this.nRangeZ = nRangeZ;
		this.nEffectXY = nEffectXY;
		this.nEffectZ = nEffectZ;
	}

	public void tick() {
		nCTR--;
	}

	public void fire() {

	}

	public boolean isReady() { return nCTR <= 0 ? true : false; }

}