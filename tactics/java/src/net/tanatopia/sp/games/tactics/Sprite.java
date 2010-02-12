package net.tanatopia.sp.games.tactics;

// Sprite

import net.tanatopia.sp.games.tactics.*;
import java.awt.image.BufferedImage;

public class Sprite {



	public static final int FRONT_UNARMED = 0;

	public static final int FRONT_UNARMED_X1 = 69;
	public static final int FRONT_UNARMED_X2 = 90;
	public static final int FRONT_UNARMED_Y1 = 1;
	public static final int FRONT_UNARMED_Y2 = 38;
	public static final int FRONT_UNARMED_WIDTH = 21;
	public static final int FRONT_UNARMED_HEIGHT = 37;

	public static final int BACK_UNARMED = 1;
	public static final int BACK_UNARMED_X1 = 133;
	public static final int BACK_UNARMED_X2 = 154;
	public static final int BACK_UNARMED_Y1 = 1;
	public static final int BACK_UNARMED_Y2 = 38;
	public static final int BACK_UNARMED_WIDTH = 21;
	public static final int BACK_UNARMED_HEIGHT = 37;

	public static final int SW_WIDTH = 23;

	public static final int SW_HEIGHT = 37;


	public static final int SW_1_X1 = 165;
	public static final int SW_1_X2 = 188;
	public static final int SW_1_Y1 = 1;
	public static final int SW_1_Y2 = 38;

	public static final int SW_2_X1 = 197;
	public static final int SW_2_X2 = 220;
	public static final int SW_2_Y1 = 1;
	public static final int SW_2_Y2 = 38;

	private BufferedImage img;

	public Sprite(BufferedImage img) {
		this.img = img;
	}
	public BufferedImage getImage(int nType) {
		switch (nType) {
		case FRONT_UNARMED:
			return img.getSubimage(
				FRONT_UNARMED_X1,
				FRONT_UNARMED_Y1,
				FRONT_UNARMED_WIDTH,
				FRONT_UNARMED_HEIGHT);
		case BACK_UNARMED:
			return img.getSubimage(
				BACK_UNARMED_X1,
				BACK_UNARMED_Y1,
				BACK_UNARMED_WIDTH,
				BACK_UNARMED_HEIGHT);

		}
		return null;
	}

}

