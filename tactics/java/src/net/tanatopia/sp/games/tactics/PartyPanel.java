package net.tanatopia.sp.games.tactics;

import net.tanatopia.sp.games.tactics.*;
import javax.swing.*;
import java.awt.*;

public class PartyPanel extends JPanel {
	private PortraitColumn comPortraits;


	private Party oParty;
	private int nX, nY;


	public PartyPanel(int nXSize, int nYSize) {
		super(new GridLayout(1,1));
		nX = nXSize;
		nY = nYSize;
		comPortraits = new PortraitColumn(oParty, 64, nY);
		comPortraits.setOpaque(true);
		add(comPortraits);
		setMinimumSize(new Dimension(nX, nY));
		setMaximumSize(new Dimension(nX, nY));
		setPreferredSize(new Dimension(nX, nY));
		validate();
	}
	public void setParty(Party newParty) {
		if (newParty != null) {
			oParty = newParty;
			comPortraits.setParty(oParty);
			comPortraits.setVisible(true);
			comPortraits.repaint();
		}
	}

	protected void paintComponent(Graphics g) {

		Graphics2D g2d = (Graphics2D)g.create();
		g2d.setBackground(Color.GREEN);
		g2d.drawRect(0, 0, 200, 600);

		g2d.dispose();
	}

}