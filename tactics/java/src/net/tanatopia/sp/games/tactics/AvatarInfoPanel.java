package net.tanatopia.sp.games.tactics;

import javax.swing.*;
import java.awt.*;
import java.awt.image.BufferedImage;

public class AvatarInfoPanel extends JPanel {
	final static int BIG_LABEL_WIDTH = 45;
	final static int BIG_SPACING = 5;
	final static int BIG_FIELD_WIDTH = 100;
	final static int SPACING = 20;
	final static int SMALL_LABEL_WIDTH = 40;
	final static int SMALL_SPACING = 5;
	final static int SMALL_FIELD_WIDTH = 30;
	final static int SMALL_ELEMENT_SPACING = 20;

	private Avatar oAvatar;

	private JLabel lblName;
	private JTextField txtName;
	private JLabel lblJob;
	private JLabel txtJob;
	private JLabel lblGender;
	private JLabel txtGender;
	private JLabel lblZodiac;
	private JLabel txtZodiac;

	private JLabel lblHP;
	private JLabel txtHP;
	private JLabel lblMP;
	private JLabel txtMP;
	private JLabel lblPA;
	private JLabel txtPA;
	private JLabel lblMA;
	private JLabel txtMA;
	private JLabel lblSpeed;
	private JLabel txtSpeed;
	private JLabel lblEvade;
	private JLabel txtEvade;
	private JLabel lblBrave;
	private JLabel txtBrave;
	private JLabel lblFaith;
	private JLabel txtFaith;



	public AvatarInfoPanel(Avatar newAvatar) {
		super();
		setLayout(null);
		oAvatar = newAvatar;
		setPreferredSize(new Dimension(480, 330));
		setMaximumSize(new Dimension(480, 330));
		setMinimumSize(new Dimension(480, 330));

		Insets inDim = getInsets();
		Dimension oSize;
		int nX = inDim.left + 126;
		int nY = inDim.top + 10;

		lblName = new JLabel("Name:");
		txtName = new JTextField(oAvatar.getName());
		lblJob = new JLabel("Job:");
		txtJob = new JLabel(oAvatar.getJobName());
		lblGender = new JLabel("Gender:");
		txtGender = new JLabel(oAvatar.getGenderString());
		lblZodiac = new JLabel("Zodiac:");
		txtZodiac = new JLabel(oAvatar.getZodiacString());

		lblHP = new JLabel("HP:");
		txtHP = new JLabel("" + oAvatar.getHP());
		lblMP = new JLabel("MP:");
		txtMP = new JLabel("" + oAvatar.getMP());
		lblPA = new JLabel("PA:");
		txtPA = new JLabel("" + oAvatar.getPA());
		lblMA = new JLabel("MA:");
		txtMA = new JLabel("" + oAvatar.getMA());
		lblSpeed = new JLabel("Speed:");
		txtSpeed = new JLabel("" + oAvatar.getSpeed());
		lblEvade = new JLabel("Evade:");
		txtEvade = new JLabel("" + oAvatar.getEvade());
		lblBrave = new JLabel("Brave:");
		txtBrave = new JLabel("" + oAvatar.getBrave());
		lblFaith = new JLabel("Faith:");
		txtFaith = new JLabel("" + oAvatar.getFaith());

		lblName.setLabelFor(txtName);

		add(lblName);
		add(lblJob);
		add(lblGender);
		add(lblZodiac);
		add(lblHP);
		add(lblMP);
		add(lblPA);
		add(lblMA);
		add(lblSpeed);
		add(lblEvade);
		add(lblBrave);
		add(lblFaith);
		add(txtName);
		add(txtJob);
		add(txtGender);
		add(txtZodiac);
		add(txtHP);
		add(txtMP);
		add(txtPA);
		add(txtMA);
		add(txtSpeed);
		add(txtEvade);
		add(txtBrave);
		add(txtFaith);


		// Row 1
		oSize = lblName.getPreferredSize();
		lblName.setBounds(nX, nY, BIG_LABEL_WIDTH, oSize.height);
		nX += BIG_LABEL_WIDTH + BIG_SPACING;
		txtName.setBounds(nX, nY, BIG_FIELD_WIDTH, oSize.height);
		nX += BIG_FIELD_WIDTH + SPACING;

		lblHP.setBounds(nX, nY, SMALL_LABEL_WIDTH, oSize.height);
		nX += SMALL_LABEL_WIDTH + SMALL_SPACING;
		txtHP.setBounds(nX, nY, SMALL_FIELD_WIDTH, oSize.height);
		nX += SMALL_FIELD_WIDTH + SMALL_ELEMENT_SPACING;
		lblMP.setBounds(nX, nY, SMALL_LABEL_WIDTH, oSize.height);
		nX += SMALL_LABEL_WIDTH + SMALL_SPACING;
		txtMP.setBounds(nX, nY, SMALL_FIELD_WIDTH, oSize.height);

		nX = inDim.left + 126;
		nY += oSize.height + 15;


		// Row 2
		lblJob.setBounds(nX, nY, BIG_LABEL_WIDTH, oSize.height);
		nX += BIG_LABEL_WIDTH + BIG_SPACING;
		txtJob.setBounds(nX, nY, BIG_FIELD_WIDTH, oSize.height);
		nX += BIG_FIELD_WIDTH + SPACING;

		lblPA.setBounds(nX, nY, SMALL_LABEL_WIDTH, oSize.height);
		nX += SMALL_LABEL_WIDTH + SMALL_SPACING;
		txtPA.setBounds(nX, nY, SMALL_FIELD_WIDTH, oSize.height);
		nX += SMALL_FIELD_WIDTH + SMALL_ELEMENT_SPACING;
		lblMA.setBounds(nX, nY, SMALL_LABEL_WIDTH, oSize.height);
		nX += SMALL_LABEL_WIDTH + SMALL_SPACING;
		txtMA.setBounds(nX, nY, SMALL_FIELD_WIDTH, oSize.height);

		nX = inDim.left + 126;
		nY += oSize.height + 15;

		// Row 3
		lblGender.setBounds(nX, nY, BIG_LABEL_WIDTH, oSize.height);
		nX += BIG_LABEL_WIDTH + BIG_SPACING;
		txtGender.setBounds(nX, nY, BIG_FIELD_WIDTH, oSize.height);
		nX += BIG_FIELD_WIDTH + SPACING;

		lblSpeed.setBounds(nX, nY, SMALL_LABEL_WIDTH, oSize.height);
		nX += SMALL_LABEL_WIDTH + SMALL_SPACING;
		txtSpeed.setBounds(nX, nY, SMALL_FIELD_WIDTH, oSize.height);
		nX += SMALL_FIELD_WIDTH + SMALL_ELEMENT_SPACING;
		lblEvade.setBounds(nX, nY, SMALL_LABEL_WIDTH, oSize.height);
		nX += SMALL_LABEL_WIDTH + SMALL_SPACING;
		txtEvade.setBounds(nX, nY, SMALL_FIELD_WIDTH, oSize.height);

		nX = inDim.left + 126;
		nY += oSize.height + 15;

		// Row 4
		lblZodiac.setBounds(nX, nY, BIG_LABEL_WIDTH, oSize.height);
		nX += BIG_LABEL_WIDTH + BIG_SPACING;
		txtZodiac.setBounds(nX, nY, BIG_FIELD_WIDTH, oSize.height);
		nX += BIG_FIELD_WIDTH + SPACING;

		lblBrave.setBounds(nX, nY, SMALL_LABEL_WIDTH, oSize.height);
		nX += SMALL_LABEL_WIDTH + SMALL_SPACING;
		txtBrave.setBounds(nX, nY, SMALL_FIELD_WIDTH, oSize.height);
		nX += SMALL_FIELD_WIDTH + SMALL_ELEMENT_SPACING;
		lblFaith.setBounds(nX, nY, SMALL_LABEL_WIDTH, oSize.height);
		nX += SMALL_LABEL_WIDTH + SMALL_SPACING;
		txtFaith.setBounds(nX, nY, SMALL_FIELD_WIDTH, oSize.height);

		nX = inDim.left + 126;
		nY += oSize.height + 15;

		updateLabels();
		validate();
		setVisible(true);
	}

	public void setAvatar(Avatar newAvatar) {
		oAvatar = newAvatar;
		updateLabels();
		repaint();
	}

	private void updateLabels() {
		txtName.setText(oAvatar.getName());
		txtJob.setText(oAvatar.getJobName());
		txtGender.setText(oAvatar.getGenderString());
		txtZodiac.setText(oAvatar.getZodiacString());

		txtHP.setText("" + oAvatar.getHP());
		txtMP.setText("" + oAvatar.getMP());
		txtPA.setText("" + oAvatar.getPA());
		txtMA.setText("" + oAvatar.getMA());
		txtSpeed.setText("" + oAvatar.getSpeed());
		txtEvade.setText("" + oAvatar.getEvade());
		txtBrave.setText("" + oAvatar.getBrave());
		txtFaith.setText("" + oAvatar.getFaith());
	}

	public void save() {
		oAvatar.setName(txtName.getText());
	}

	public static void main(String[] args) {
		Game.main(args);
	}

	protected void paintComponent(Graphics g) {
		Graphics2D g2d = (Graphics2D)g.create();
		Insets inDim = getInsets();
		int nX = inDim.left + 10;
		int nY = inDim.top + 10;

		g2d.drawImage(oAvatar.getPortrait(),
			nX,
			nY,
			96,
			144,
			null);

		g2d.draw(new Rectangle(nX, nY, 96, 144));
		nY += 149;
		BufferedImage img = oAvatar.getSprite().getImage(Sprite.FRONT_UNARMED);
		g2d.drawImage(img,
			nX,
			nY,
			(Sprite.FRONT_UNARMED_WIDTH * 2),
			(Sprite.FRONT_UNARMED_HEIGHT * 2),
//			Sprite.FRONT_UNARMED_X1,
//			Sprite.FRONT_UNARMED_Y1,
//			Sprite.FRONT_UNARMED_X2,
//			Sprite.FRONT_UNARMED_Y2,
			null);

		nX += Sprite.FRONT_UNARMED_WIDTH * 2 + (96 - Sprite.FRONT_UNARMED_WIDTH * 4);
		img = oAvatar.getSprite().getImage(Sprite.BACK_UNARMED);
		g2d.drawImage(img,
			nX,
			nY,
			(Sprite.BACK_UNARMED_WIDTH * 2),
			(Sprite.BACK_UNARMED_HEIGHT * 2),
//			Sprite.BACK_UNARMED_X1,
//			Sprite.BACK_UNARMED_Y1,
//			Sprite.BACK_UNARMED_X2,
//			Sprite.BACK_UNARMED_Y2,
			null);

	}

}