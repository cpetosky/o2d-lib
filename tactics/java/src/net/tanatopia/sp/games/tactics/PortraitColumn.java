package net.tanatopia.sp.games.tactics;

import net.tanatopia.sp.games.tactics.*;
import javax.swing.*;
import java.awt.*;

public class PortraitColumn extends JComponent  {
	Party oParty;

	public PortraitColumn(Party newParty, int nX, int nY) {
		oParty = newParty;
		setPreferredSize(new Dimension(nX, nY));
		setMaximumSize(new Dimension(nX, nY));
		setMinimumSize(new Dimension(nX, nY));
		setLayout(null);
		setOpaque(true);
		setVisible(true);
		validate();
	}

	public void setParty(Party newParty) { oParty = newParty; repaint(); }

	protected void paintComponent(Graphics g) {
		if (oParty != null) {
			Graphics2D g2d = (Graphics2D)g.create();
			Insets inDim = getInsets();
			int nX = inDim.left;
			int nY = inDim.top;
			for (int i = 0; i < oParty.getSize(); i++) {
				g2d.drawImage(oParty.getAvatar(i).getPortrait(), nX, nY, this);
				nY += 96;
			}


			g2d.dispose();
		}
	}

}
