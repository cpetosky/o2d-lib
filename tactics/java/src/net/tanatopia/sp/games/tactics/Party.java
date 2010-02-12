package net.tanatopia.sp.games.tactics;

import java.io.Serializable;

public class Party implements Serializable {
	static final long serialVersionUID = 1L; // File Version

	public static final int PARTY_SIZE = 5;

	private Avatar[] oAvatars;
	private int nCurrentSize;

	public Party() {

		oAvatars = new Avatar[PARTY_SIZE];
		nCurrentSize = 0;
	}


	public Party(Avatar[] oAvatars) {
		if (oAvatars.length == PARTY_SIZE) {
			this.oAvatars = oAvatars;
			nCurrentSize = PARTY_SIZE;
		}
		else {
			this.oAvatars = new Avatar[PARTY_SIZE];
			for (int i = 0; i < oAvatars.length; i++)
				this.oAvatars[i] = oAvatars[i];
		}
	}

	public Avatar getAvatar(int nIndex) {
		if (nIndex >= nCurrentSize)
			return null;
		else
			return oAvatars[nIndex];
	}

	public void addAvatar(Avatar oAvatar) {
		oAvatars[nCurrentSize++] = oAvatar;
	}

	public Avatar replaceAvatar(Avatar oAvatar, int nIndex) {
		if (nIndex >= nCurrentSize)
			return null;
		else {
			Avatar oldAvatar = oAvatars[nIndex];
			oAvatars[nIndex] = oAvatar;
			return oldAvatar;
		}
	}

	public boolean contains(Avatar oAvatar) {
		for (int i = 0; i < getSize(); i++)
			if (oAvatars[i].equals(oAvatar))
				return true;
		return false;
	}

	public void resetImages() {
		for (int i = 0; i < getSize(); i++)
			oAvatars[i].resetImages();
	}

	public int getSize() {
		return nCurrentSize;
	}

	public String toString() {
		String sOutput = "";
		for (int i = 0; i < getSize(); i++)
			sOutput += "Avatar " + i + ": " + oAvatars[i];
		return sOutput;
	}
}