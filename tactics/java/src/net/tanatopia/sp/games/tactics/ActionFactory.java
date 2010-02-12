package net.tanatopia.sp.games.tactics;

public class ActionFactory {
	public static final int ATTACK =					0;

	public static GameAction createAction(String sID, Avatar avaOwner) {
		return createAction(Integer.parseInt(sID), avaOwner);
	}

	public static GameAction createAction(int nID, Avatar avaOwner) {
		String sName = "Invalid";
		int nDamage = 0;
		int nXA = 0;
		int nHit = 0;
		int nType = 0;
		boolean bReflect = false;
		boolean bCalculate = false;
		int nElemental = 0;
		boolean bCGrasp = false;
		boolean bCMagic = false;
		boolean bCFlood = false;
		boolean bEvade = false;
		int nMPCost = 0;
		int nCTR = 0;
		int nMod = 0;
		int nRangeXY = 0;
		int nRangeZ = 0;
		int nEffectXY = 0;
		int nEffectZ = 0;

		switch (nID) {

			case ATTACK:
				Item oWeapon = avaOwner.getWeapon();
				if (oWeapon == null) {
					nXA = (avaOwner.getPA() * avaOwner.getBrave()) / 100;
					nRangeXY = 1;
					nRangeZ = 2;
					nEffectXY = 1;
					nEffectZ = 0;
				} else {
					switch (oWeapon.getSubType()) {
						case Item.SUBTYPE_DAGGER:
						case Item.SUBTYPE_NINJASWORD:
							nXA = (avaOwner.getPA() + avaOwner.getSpeed()) / 2;
							nRangeXY = 1;
							nRangeZ = 2;
							nEffectXY = 1;
							nEffectZ = 0;
							break;
						case Item.SUBTYPE_SWORD:
						case Item.SUBTYPE_ROD:
							nXA = avaOwner.getPA();
							nRangeXY = 1;
							nRangeZ = 2;
							nEffectXY = 1;
							nEffectZ = 0;
							break;
						case Item.SUBTYPE_KNIGHTSWORD:
						case Item.SUBTYPE_KATANA:
							nXA = (avaOwner.getPA() * avaOwner.getBrave()) / 100;
							nRangeXY = 1;
							nRangeZ = 2;
							nEffectXY = 1;
							nEffectZ = 0;
							break;
						case Item.SUBTYPE_STAFF:
							nXA = avaOwner.getMA();
							nRangeXY = 1;
							nRangeZ = 2;
							nEffectXY = 1;
							nEffectZ = 0;
							break;
						case Item.SUBTYPE_AXE:
						case Item.SUBTYPE_FLAIL:
							nXA = 1 + Game.oRandom.nextInt(avaOwner.getPA());
							nRangeXY = 1;
							nRangeZ = 2;
							nEffectXY = 1;
							nEffectZ = 0;
							break;
						default:
							nXA = avaOwner.getPA();
							nRangeXY = 1;
							nRangeZ = 2;
							nEffectXY = 1;
							nEffectZ = 0;
					}
				}

				nHit = 100;
				sName = "Attack";
				nType = GameAction.TYPE_PHYSICAL;
				nElemental = GameAction.ELEM_WEAPON;
				bReflect = false;
				bCalculate = false;
				bCGrasp = true;
				bCMagic = false;
				bCFlood = false;
				bEvade = true;
				nMPCost = 0;
				nCTR = 0;
				nMod = GameAction.MOD_ATTACK;
				break;
		}

		return new GameAction(avaOwner, sName, nHit, nXA, nType, nElemental,
			bReflect, bCalculate, bCGrasp, bCMagic, bCFlood, bEvade, nMPCost,
			nCTR, nMod, nRangeXY, nRangeZ, nEffectXY, nEffectZ);

	}

}