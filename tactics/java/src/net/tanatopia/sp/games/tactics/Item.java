package net.tanatopia.sp.games.tactics;

import java.io.Serializable;
import java.io.IOException;

public class Item implements Serializable {
	public static final int TYPE_WEAPON =				1;
	public static final int TYPE_SHIELD =				2;
	public static final int TYPE_HEADGEAR =				3;
	public static final int TYPE_BODYARMOR =			4;
	public static final int TYPE_ACCESSORY =			5;
	public static final int TYPE_ITEM =					6;

	public static final int SUBTYPE_DAGGER =			1;
	public static final int SUBTYPE_NINJASWORD =		2;
	public static final int SUBTYPE_SWORD =				3;
	public static final int SUBTYPE_KNIGHTSWORD =		4;
	public static final int SUBTYPE_KATANA =			5;
	public static final int SUBTYPE_AXE =				6;
	public static final int SUBTYPE_ROD =				7;
	public static final int SUBTYPE_STAFF =				8;
	public static final int SUBTYPE_FLAIL =				9;

	public static final int DAGGER_DAGGER =				10101;
	public static final int NINJASWORD_HIDDENKNIFE =	10201;
	public static final int SWORD_BROADSWORD =			10301;
	public static final int KNIGHTSWORD_DEFENDER =		10401;
	public static final int KATANA_ASURAKNIFE =			10501;
	public static final int AXE_BATTLEAXE =				10601;
	public static final int ROD_ROD =					10701;
	public static final int STAFF_OAKSTAFF =			10801;
	public static final int FLAIL_FLAIL =				10901;


	private int nID;
	private transient String sName;
	private transient int nType;
	private transient int nSubType;
	private transient int nStat1; // WP for weapons, HP+ for armor, PEv for mantle/shield
	private transient int nStat2; // Ev for weapons, MP+ for armor, MEv for mantle/shield
	private transient int nPrice;

	public Item(String sName, int nID, int nType, int nSubType, int nStat1,
				int nStat2, int nPrice) {
		this.nID = nID;
		this.sName = sName;
		this.nType = nType;
		this.nSubType = nSubType;
		this.nStat1 = nStat1;
		this.nStat2 = nStat2;
		this.nPrice = nPrice;
	}

	private void readObject(java.io.ObjectInputStream in)
		throws IOException, ClassNotFoundException {
		in.defaultReadObject();
		Item oTempItem = ItemFactory.createItem(nID);
		this.sName = oTempItem.sName;
		this.nType = oTempItem.nType;
		this.nSubType = oTempItem.nSubType;
		this.nStat1 = oTempItem.nStat1;
		this.nStat2 = oTempItem.nStat2;
		this.nPrice = oTempItem.nPrice;
	}

	public int getSubType() { return nSubType; }

}