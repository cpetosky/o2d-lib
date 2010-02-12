package net.tanatopia.sp.games.tactics;

// PartyFormDialog.java

import net.tanatopia.sp.games.tactics.*;
import java.awt.*;
import java.awt.image.*;
import java.awt.event.*;
import javax.swing.*;
import javax.imageio.*;
import java.io.*;

public class PartyFormDialog extends JDialog implements ActionListener, MouseListener {


	final static int MAX_JOBS = 30;

	final static int PARTY_SIZE = 5;
	private JFrame frame;
	private StatusPanel panStatus;
	private PortraitColumn comPortraits;
	private BufferedImage[][] oPortraits; // [Charnum][jobnum]
	private Avatar[] oAvatars;
	private Avatar chrSelected;
	private int[] nJobs;
	private String[] sJobs;
	private JComboBox[] cmbJobs;
	private Party oParty;


	//======================================Constructors=======================
	public PartyFormDialog(JFrame newFrame) {
		super(newFrame, "Form Your Party", true);
		frame = newFrame;
		oParty = new Party();
		BufferedReader dJobFile = null;
		String sFileName = "data/jobs.txt";

		// Get information from files
		try {
			dJobFile = new BufferedReader(new FileReader("data/jobs.txt"));
			nJobs = new int[MAX_JOBS];
			int nCount = 0;

			// Create array of Jobs
			String sTemp;
			sTemp = dJobFile.readLine();
			while (sTemp != null) {
				nJobs[nCount] = Integer.parseInt(sTemp);
				nCount++;
				sTemp = dJobFile.readLine();
			}
			dJobFile.close();

			int[] nTemp = new int[nCount];
			for (int i = 0; i < nCount; i++)
				nTemp[i] = nJobs[i];

			nJobs = nTemp;

			// Create array of job names
			sJobs = new String[nJobs.length];
			for (int i = 0; i < sJobs.length; i++)
				sJobs[i] = Job.getJobName(nJobs[i]);

			// Create map of portraits
			oPortraits = new BufferedImage[PARTY_SIZE][nJobs.length];

			for (int i = 0; i < PARTY_SIZE; i++) {
				BufferedImage[] oImages = new BufferedImage[nJobs.length];
				for (int j = 0; j < oImages.length; j++) {
					sFileName = "images/characters/" + nJobs[j] + "/portraits/" + (i + 1) + ".gif";
					oImages[j] = ImageIO.read(new File(sFileName));
				}

				oPortraits[i] = oImages;
			}
		}
		catch (Exception e) {
			e.printStackTrace();
			System.exit(-1);
		}

		// Create array of default characters
		for (int i = 0; i < Party.PARTY_SIZE; i++) {
			oParty.addAvatar(new Avatar('m', nJobs[i]));
			oParty.getAvatar(i).setColor(i + 1);
		}

		// Set top character to "selected"
		chrSelected = oParty.getAvatar(0);
		comPortraits = new PortraitColumn(oParty, 64, 480);
		comPortraits.addMouseListener(this);

		// Create Job Select Panel
		JPanel panJobs = new JPanel();
		panJobs.setLayout(new BoxLayout(panJobs, BoxLayout.PAGE_AXIS));
		panJobs.setPreferredSize(new Dimension(96, 480));
		panJobs.setMaximumSize(new Dimension(128, 480));
		panJobs.setOpaque(true);

		panJobs.add(Box.createRigidArea(new Dimension(0,32)));
		cmbJobs = new JComboBox[nJobs.length];
		for (int i = 0; i < cmbJobs.length; i++) {
			cmbJobs[i] = new JComboBox(sJobs);
			cmbJobs[i].setSelectedIndex(getJobNumber(oParty.getAvatar(i).getJobID()));
			cmbJobs[i].setName("" + i);
			cmbJobs[i].addActionListener(this);
			cmbJobs[i].setMaximumSize(cmbJobs[i].getPreferredSize());
			panJobs.add(cmbJobs[i]);
			panJobs.add(Box.createRigidArea(new Dimension(0, 72)));
		}

		panStatus = new StatusPanel(chrSelected);

		String sInstructions = "Click on a portrait to the left to choose a character.\n";
		sInstructions += "Use the combo boxes to change the character's class.\n";
		sInstructions += "Once you have chosen the job of the character, type his name.\n";
		sInstructions += "Finally, hit Save at the bottom to save your party.";
		JTextArea txtInstructions = new JTextArea(sInstructions);
		txtInstructions.setBackground(getBackground());
		txtInstructions.setEditable(false);

		JButton butSave = new JButton("Save");
		butSave.setName("Save");
		butSave.addActionListener(this);

		JButton butCancel = new JButton("Cancel");
		butCancel.setName("Cancel");
		butCancel.addActionListener(this);

		// Set up pane
		GridBagLayout oLayout = new GridBagLayout();
		GridBagConstraints oCon = new GridBagConstraints();
		getContentPane().setLayout(oLayout);
		oCon.gridheight = 3;
		oLayout.setConstraints(comPortraits, oCon);
		oLayout.setConstraints(panJobs, oCon);
		oCon.gridwidth = GridBagConstraints.REMAINDER;
		oCon.gridheight = 1;
		oLayout.setConstraints(txtInstructions, oCon);
		oLayout.setConstraints(panStatus, oCon);
		oCon.anchor = GridBagConstraints.CENTER;
		oCon.gridwidth = GridBagConstraints.RELATIVE;
		oLayout.setConstraints(butSave, oCon);
		oCon.gridwidth = GridBagConstraints.REMAINDER;
		oLayout.setConstraints(butCancel, oCon);

		getContentPane().add(comPortraits);
		getContentPane().add(panJobs);
		getContentPane().add(txtInstructions);
		getContentPane().add(panStatus);
		getContentPane().add(butSave);
		getContentPane().add(butCancel);
		pack();
		repaint();
	}

	public void actionPerformed(ActionEvent e) {
		if (e.getActionCommand().equals("comboBoxChanged")) {
			int nChar = Integer.parseInt(((JComboBox)e.getSource()).getName());
			String newJob = (String)cmbJobs[nChar].getSelectedItem();
			int nNewJob = getJobNumber(newJob);
			oParty.replaceAvatar(new Avatar('m', nNewJob), nChar);
			oParty.getAvatar(nChar).setColor(nChar + 1);
			chrSelected = oParty.getAvatar(nChar);
			panStatus.setAvatar(chrSelected);
			comPortraits.repaint();
		} else if (e.getActionCommand().equals("Cancel")) {
			oParty = null;
			setVisible(false);
		} else if (e.getActionCommand().equals("Save")) {
			panStatus.save();
			setVisible(false);
		}
	}

	private int getJobNumber(int nJobID) {
		for (int i = 0; i < nJobs.length; i++)
			if (nJobs[i] == nJobID)
				return i;
		return -1;
	}

	private int getJobNumber(String sJobName) {
		for (int i = 0; i < sJobs.length; i++)
			if (sJobs[i].equals(sJobName))
				return i;
		return -1;
	}

	public Party getParty() {
		return oParty;
	}

	public static void main(String[] args) {
		Game.main(args);
	}

	public void mouseClicked(MouseEvent e) {
		Point oPoint = e.getPoint();
		if (oPoint.x >= 0 && oPoint.x <= 64)
			for (int i = 0; i < 96 * oParty.getSize(); i += 96)
				if (oPoint.y >= i && oPoint.y < (i + 96)) {
					panStatus.save();
					chrSelected = oParty.getAvatar(i / 96);
					panStatus.setAvatar(chrSelected);
					repaint();
				}

	}

	public void mouseEntered(MouseEvent e) {}
	public void mouseExited(MouseEvent e) {}
	public void mousePressed(MouseEvent e) {}
	public void mouseReleased(MouseEvent e) {}
}
