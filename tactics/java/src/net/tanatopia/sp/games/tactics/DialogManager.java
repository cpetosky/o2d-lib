package net.tanatopia.sp.games.tactics;

import net.tanatopia.sp.games.tactics.*;
import javax.swing.*;
import java.awt.*;
import java.awt.event.*;
import java.awt.EventQueue;

public class DialogManager {
	public static final int CONNECT = 0;
	public static final int HOST = 1;
	public static final int WAITING_FOR_CONN = 2;

	public static final int RETURN_PORT = 0;
	public static final int RETURN_IP = 1;

	public static Object show(int nDialog, JFrame oParent)  {
		Object[] oReturn;
		Container conPane;
		Rectangle scrBounds;

		switch (nDialog) {
		//--------------------------------------------------------------------
		case CONNECT:
			final JDialog dlgBox = new JDialog(
				oParent,
				"Enter Connection Information",
				true);

			conPane = dlgBox.getContentPane();

			JLabel lblIP = new JLabel("Enter your opponent's IP address: ");
			final JTextField txtIP = new JTextField(25);
			txtIP.addActionListener(new ActionListener() {
				public void actionPerformed(ActionEvent e) {
					dlgBox.setVisible(false);
				}
			});

			JLabel lblPort = new JLabel("Enter your opponent's port: ");
			JTextField txtPort = new JTextField("" + SocketManager.DEFAULT_PORT, 25);
			txtPort.addActionListener(new ActionListener() {
				public void actionPerformed(ActionEvent e) {
					dlgBox.setVisible(false);
				}
			});

			JButton butOK = new JButton("Connect");
			butOK.addActionListener(new ActionListener() {
				public void actionPerformed(ActionEvent e) {
					dlgBox.setVisible(false);
				}
			});

			JButton butCancel = new JButton("Cancel");
			butCancel.addActionListener(new ActionListener() {
				public void actionPerformed(ActionEvent e) {
					txtIP.setText("cancel");
					dlgBox.setVisible(false);
				}
			});


			conPane.setLayout(new GridLayout(3, 2));

			conPane.add(lblIP);
			conPane.add(txtIP);
			conPane.add(lblPort);
			conPane.add(txtPort);
			conPane.add(butOK);
			conPane.add(butCancel);

			scrBounds = oParent.getGraphicsConfiguration().getBounds();
			dlgBox.pack();
			dlgBox.setLocation(
				((scrBounds.x + scrBounds.width - dlgBox.getWidth()) / 2),
				((scrBounds.y + scrBounds.height - dlgBox.getHeight()) / 2));

			dlgBox.setDefaultCloseOperation(WindowConstants.DO_NOTHING_ON_CLOSE);

			dlgBox.setVisible(true);
			oReturn = new String[2];
			oReturn[RETURN_PORT] = txtPort.getText();
			oReturn[RETURN_IP] = txtIP.getText();
			return oReturn;
		//--------------------------------------------------------------------
		case HOST:
			return JOptionPane.showInputDialog(
				oParent,
				"Enter the port you wish to use:",
				"" + SocketManager.DEFAULT_PORT);

		//--------------------------------------------------------------------
		case WAITING_FOR_CONN:
			final JDialog dlgBox2 = new JDialog(
				oParent,
				"Accepting Connection...",
				false);

			conPane = dlgBox2.getContentPane();

			JLabel lblWait = new JLabel("Waiting for connection...");

			conPane.setLayout(new FlowLayout());

			conPane.add(lblWait);

			scrBounds = oParent.getGraphicsConfiguration().getBounds();

			dlgBox2.pack();
			dlgBox2.setLocation(
				((scrBounds.x + scrBounds.width - dlgBox2.getWidth()) / 2),
				((scrBounds.y + scrBounds.height - dlgBox2.getHeight()) / 2));

			dlgBox2.setDefaultCloseOperation(WindowConstants.DO_NOTHING_ON_CLOSE);
			dlgBox2.setVisible(true);

			return dlgBox2;


		default:
			return null;
		}
	}

	public static void main (String[] args) {
		Game.main(args);
	}
}