package net.tanatopia.sp.games.tactics;

public class ItemFactory {
	public static Item createItem(int nID) {
		int nTempID;
		String sName;
		int nType;
		int nSubType;
		int nStat1; // WP for weapons, HP+ for armor, PEv for mantle/shield
		int nStat2; // Ev for weapons, MP+ for armor, MEv for mantle/shield
		int nPrice;

		nType = nID / 10000;
		nTempID = nID - (nType * 10000);
		nSubType = (nTempID / 100);

		switch (nID) {
			case Item.DAGGER_DAGGER:
				sName = "Dagger";
				nStat1 = 3;
				nStat2 = 0;
				nPrice = 100;
				break;
			case Item.SWORD_BROADSWORD:
				sName = "Broad Sword";
				nStat1 = 4;
				nStat2 = 5;
				nPrice = 200;
				break;
			case Item.ROD_ROD:
				sName = "Rod";
				nStat1 = 3;
				nStat2 = 20;
				nPrice = 200;
				break;
			case Item.STAFF_OAKSTAFF:
				sName = "Oak Staff";
				nStat1 = 3;
				nStat2 = 15;
				nPrice = 120;
				break;
			default:
				sName = "ERROR";
				nStat1 = 0;
				nStat2 = 0;
				nPrice = 1;
		}

		return new Item(sName, nID, nType, nSubType, nStat1, nStat2, nPrice);
	}
}