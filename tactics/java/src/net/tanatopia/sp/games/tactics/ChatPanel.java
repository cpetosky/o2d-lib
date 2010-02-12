package net.tanatopia.sp.games.tactics;

import net.tanatopia.sp.games.tactics.*;
import javax.swing.*;
import java.io.*;
import java.net.*;
import java.awt.*;
import java.awt.event.*;

public class ChatPanel extends JPanel implements ActionListener {
	private JTextArea oText;
	private JTextField oInput;
	private JScrollPane oScroller;
	private JButton oSend;

	//-------------------------Constructor-------------------------------------
	public ChatPanel(int nXSize, int nYSize) {

		setMinimumSize(new Dimension(nXSize, nYSize));
		setMaximumSize(new Dimension(nXSize, nYSize));
		setPreferredSize(new Dimension(nXSize, nYSize));

		GridBagLayout oLayout = new GridBagLayout();
		GridBagConstraints oCon = new GridBagConstraints();
		setLayout(oLayout);
		oText = new JTextArea();
		oText.setText("");

		oScroller = new JScrollPane(oText);
		oScroller.setPreferredSize(new Dimension(nXSize, nYSize - 25));
		oCon.gridwidth = GridBagConstraints.REMAINDER;
		oLayout.setConstraints(oScroller, oCon);
		add(oScroller);

		final JScrollBar vsb = oScroller.getVerticalScrollBar();

		vsb.addAdjustmentListener(new AdjustmentListener() {
			public void adjustmentValueChanged(AdjustmentEvent e) {
				if (!e.getValueIsAdjusting()) {
					vsb.setValue(vsb.getMaximum());
				}
			}
		});

		oInput = new JTextField();
		oInput.setPreferredSize(new Dimension(nXSize - 70, 25));
		oInput.addActionListener(this);
		oCon.gridwidth = GridBagConstraints.RELATIVE;
		oLayout.setConstraints(oInput, oCon);
		add(oInput);

		oSend = new JButton("Send");
		oSend.addActionListener(this);
		oSend.setPreferredSize(new Dimension(70, 25));
		oCon.gridwidth = GridBagConstraints.REMAINDER;
		oLayout.setConstraints(oSend, oCon);
		add(oSend);

		validate();
	}

	//-------------------------------actionPerformed---------------------------
	public void actionPerformed(ActionEvent e) {
		if (oInput.getText().equals(""))
			return;

		if (Game.oConn.isConnected()) {
			Game.oConn.send("chat", oInput.getText());
			System.out.println("panChat sent message: " + oInput.getText());
			oText.append("You> " + oInput.getText() + "\n");
			oInput.setText("");
		}
	}

	public void addChat(String sChat) {
		oText.append("Opponent> " + sChat + "\n");
	}

	//-------------------------------echo--------------------------------------
	public void echo(String sMessage) {
		oText.append(sMessage + "\n");
	}

}