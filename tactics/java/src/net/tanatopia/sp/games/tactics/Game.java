package net.tanatopia.sp.games.tactics;

import javax.swing.*;
import java.awt.*;
import java.awt.event.*;
import java.io.*;
import java.net.UnknownHostException;
import java.util.LinkedList;
import java.util.ListIterator;
import java.util.Random;

public class Game implements ActionListener, WindowListener, Runnable {

	public static final String DEFAULT_MAP_DIRECTORY = "maps/";

	// Abstract GUI
	private Rectangle scrBounds;

	// GUI
	public static JFrame frame;
	public static PartyPanel panParty;
	public static Map oMap;
	public static ChatPanel panChat;
	public static JPanel panStatus;
	public static JLabel lblStatus1;
	public static JLabel lblStatus2;
	public static JLabel lblStatus3;

	// Threads
	private Thread tConn;
	private Thread tMain;

	// Net
	public static SocketManager oConn;
	// Game
	public static Party oParty;
	public static Party oOpponentParty;
	public static Avatar oActiveAvatar;
	private Avatar[] listChar;
	private LinkedList listAT;
	public static Random oRandom;

	// Flow Control
	private boolean bDeployed;
	private boolean bOpponentDeployed;
	private int iChar;
	private boolean bMyAT;

	//--------------------------------createAndShowGUI-----------------------------
	public static void createAndShowGUI() {
		Game thisGame = new Game();
		try {
			UIManager.setLookAndFeel(
            	UIManager.getSystemLookAndFeelClassName());
		}
		catch (Exception e) {}
		JFrame.setDefaultLookAndFeelDecorated(true);
		thisGame.frame = new JFrame("Tactics");
		thisGame.oConn = new SocketManager();
		thisGame.scrBounds = thisGame.frame.getGraphicsConfiguration().getBounds();
		thisGame.frame.setDefaultCloseOperation(WindowConstants.DO_NOTHING_ON_CLOSE);
		thisGame.frame.setDefaultLookAndFeelDecorated(true);
		thisGame.frame.addWindowListener(thisGame);
		thisGame.frame.setVisible(true);
	}


	//--------------------------------exit---------------------------------------
	public void exit(int nCondition) {
		actionDisconnect();
		System.exit(nCondition);
	}
	//====ActionListener Interface:==============================================
	//--------------------------------actionPerformed----------------------------
	public void actionPerformed(ActionEvent e) {
		if (e.getActionCommand().equals("connect"))
			actionConnect();
		else if (e.getActionCommand().equals("host"))
			actionHost();
		else if (e.getActionCommand().equals("disconnect"))
			actionDisconnect();
		else if (e.getActionCommand().equals("quit"))
			actionQuit();
		else if (e.getActionCommand().equals("form party"))
			actionFormParty();
		else if (e.getActionCommand().equals("open map"))
			actionOpenMap();
		else if (e.getActionCommand().equals("preplay"))
			actionPrePlay();
		else if (e.getActionCommand().equals("move"))
			actionMove();

	}


	//--------------------------------actionConnect------------------------------
	private void actionConnect() {
		if (oParty == null) {
			JOptionPane.showMessageDialog(frame, "Make a party before trying to connect.");
			return;
		}

		String[] oResults = (String[])DialogManager.show(DialogManager.CONNECT, frame);

		if(oResults[DialogManager.RETURN_IP].equals("cancel"))
			return;

		lblStatus3.setText("Connecting...");
		try {
			oConn.connect(
				oResults[DialogManager.RETURN_IP],
				Integer.parseInt(oResults[DialogManager.RETURN_PORT]));
		} catch (UnknownHostException e) {
			JOptionPane.showMessageDialog(
				frame,
				"The IP of the host cannot be determined.",
				"Unknown Host Exception",
				JOptionPane.ERROR_MESSAGE);
			frame.repaint();
			return;
		} catch (IOException e) {
			JOptionPane.showMessageDialog(
				frame,
				e.getMessage(),
				"Input/Output Exception",
				JOptionPane.ERROR_MESSAGE);
			frame.repaint();
			return;
		}
		echo("Connected to opponent!");

		tConn = new Thread(oConn, "conn");
		tConn.start();
		tMain = new Thread(this, "main");
		tMain.start();

	}

	//--------------------------------actionHost---------------------------------
	private void actionHost() {
		if (oParty == null) {
			JOptionPane.showMessageDialog(frame, "Make a party before trying to connect.");
			return;
		}

		JFileChooser oFC = new JFileChooser(DEFAULT_MAP_DIRECTORY);
		int nReturn = oFC.showOpenDialog(frame);

		if (nReturn == JFileChooser.CANCEL_OPTION) {
			return;
		}

		int nPort = Integer.parseInt((String)(DialogManager.show(DialogManager.HOST, frame)));

		JDialog dlgBox = (JDialog)(DialogManager.show(DialogManager.WAITING_FOR_CONN, frame));
		dlgBox.pack();
		try {
			oConn.host(nPort);
		} catch (IOException e) {
			JOptionPane.showMessageDialog(
				frame,
				e.getMessage(),
				"Error!",
				JOptionPane.ERROR_MESSAGE);
			frame.repaint();
			return;
		}
		dlgBox.setVisible(false);
		echo("Connected to opponent!");

		tConn = new Thread(oConn, "conn");
		tConn.start();
		tMain = new Thread(this, "main");
		tMain.start();

		try {
			oMap.loadMap(oFC.getSelectedFile());
			oConn.send("loadmap", oFC.getName(oFC.getSelectedFile()));
		}
		catch (Exception e) {
			e.printStackTrace();
			System.exit(-1);
		}

	}

	//--------------------------------actionDisconnect---------------------------
	private void actionDisconnect() {

		try {
			oConn.disconnect();
			tConn.join(2000);
			tMain.join(2000);
		}
		catch (Exception e) {}
	}

	//--------------------------------actionQuit---------------------------------
	private void actionQuit() {
		int nResult = JOptionPane.showConfirmDialog(
			frame,
			"Are you sure you wish to quit?",
			"Are you sure?",
			JOptionPane.YES_NO_OPTION);

		if (nResult == JOptionPane.YES_OPTION)
			frame.dispose();
	}

	//-------------------------------actionFormParty-----------------------------
	private void actionFormParty() {
		PartyFormDialog oPopup = new PartyFormDialog(frame);
		oPopup.show();
		oParty = oPopup.getParty();
		panParty.setParty(oParty);
		if (oParty != null)
			lblStatus2.setText("Party is ready!");
	}

	//-------------------------------actionOpenMap----------------------------
	private void actionOpenMap() {
		JFileChooser oFC = new JFileChooser(DEFAULT_MAP_DIRECTORY);
		int nReturn = oFC.showOpenDialog(frame);

		if (nReturn == JFileChooser.APPROVE_OPTION) {
			try {oMap.loadMap(oFC.getSelectedFile());}
			catch (Exception e) {}
		}
	}

	//-------------------------------actionPrePlay----------------------------
	private void actionPrePlay() {
		oMap.prepareForPlay();
		lblStatus3.setText("Waiting for opponent to deploy...");
		bDeployed = true;
		oConn.send("deployed", "");
	}

	//-------------------------------actionMove-------------------------------
	private void actionMove() {
		System.out.println("actionMove");
		oConn.send("move", listChar[iChar].getTileX() + ";" + listChar[iChar].getTileY());

		// TEMP
		stateEndTurn();
	}


	//=======WindowListener Interface:===========================================
	public void windowActivated(WindowEvent e) {
		frame.repaint();
	}

	public void windowClosed(WindowEvent e) {
		exit(0);
	}

	public void windowClosing(WindowEvent e) {
		actionQuit();
	}

	public void windowDeactivated(WindowEvent e) {}

	public void windowDeiconified(WindowEvent e) {
		frame.repaint();
	}

	public void windowIconified(WindowEvent e) {}

	public void windowOpened(WindowEvent e) {
		initGUI();
	}

	//--------------------------------initGUI------------------------------------
	public void initGUI() {
		bDeployed = bOpponentDeployed = false;
		listAT = new LinkedList();

		frame.setJMenuBar(new GameMenuBar(this));
		panParty = new PartyPanel(200, 480);
		panStatus = new JPanel(null);
		oMap = new Map(600, 350);
		panChat = new ChatPanel(600, 200);

		Container contentPane = frame.getContentPane();

		panParty.setOpaque(true);
		panStatus.setOpaque(true);
		panChat.setOpaque(true);

		panStatus.setPreferredSize(new Dimension(200, 70));

		contentPane.add(panStatus);
		contentPane.add(panParty);
		contentPane.add(oMap);
		contentPane.add(panChat);


		SpringLayout oLayout = new SpringLayout();
		contentPane.setLayout(oLayout);

		oLayout.putConstraint(SpringLayout.WEST, panParty,
			0,
			SpringLayout.WEST, contentPane);
		oLayout.putConstraint(SpringLayout.NORTH, panParty,
			0,
			SpringLayout.NORTH, contentPane);
		oLayout.putConstraint(SpringLayout.WEST, panStatus,
			0,
			SpringLayout.WEST, contentPane);
		oLayout.putConstraint(SpringLayout.SOUTH, panStatus,
			0,
			SpringLayout.SOUTH, contentPane);
		oLayout.putConstraint(SpringLayout.EAST, oMap,
			0,
			SpringLayout.EAST, contentPane);
		oLayout.putConstraint(SpringLayout.NORTH, oMap,
			0,
			SpringLayout.NORTH, contentPane);
		oLayout.putConstraint(SpringLayout.WEST, panChat,
			0,
			SpringLayout.EAST, panStatus);
		oLayout.putConstraint(SpringLayout.NORTH, panChat,
			0,
			SpringLayout.SOUTH, oMap);
		oLayout.putConstraint(SpringLayout.EAST, contentPane,
			0,
			SpringLayout.EAST, panChat);
		oLayout.putConstraint(SpringLayout.SOUTH, contentPane,
			0,
			SpringLayout.SOUTH, panChat);


		panChat.validate();
		panChat.setVisible(true);

		Insets oInsets = panStatus.getInsets();
		int nX = oInsets.left + 5;
		int nY = oInsets.top + 5;

		lblStatus1 = new JLabel("Not Connected...");
		lblStatus2 = new JLabel("No Party Formed...");
		lblStatus3 = new JLabel();

		Dimension oSize = lblStatus1.getPreferredSize();

		lblStatus1.setBounds(nX, nY, 180, oSize.height);
		nY += oSize.height + 7;
		lblStatus2.setBounds(nX, nY, 180, oSize.height);
		nY += oSize.height + 7;
		lblStatus3.setBounds(nX, nY, 180, oSize.height);

		panStatus.add(lblStatus1);
		panStatus.add(lblStatus2);
		panStatus.add(lblStatus3);



		frame.pack();
		frame.setResizable(false);
		frame.setLocation(
			((scrBounds.x + scrBounds.width - frame.getWidth()) / 2),
			((scrBounds.y + scrBounds.height - frame.getHeight()) / 2));

		oMap.addKeyListener(oMap);
		oMap.setButtonEvents(this);


	}

	//===================ProgramStates=========================================
	public void stateDeploy(int nTeam) {
		lblStatus1.setText("Deploy Phase");
		oMap.prepareDeploy(nTeam);
	}

	public void stateWaiting() {
		lblStatus2.setText("Opponent's Turn");
		oMap.prepareWaiting();
	}

	public void stateAT() {
		lblStatus2.setText("Your Turn!");
		oMap.prepareAT();
	}

	public void stateEndTurn() {
		listChar[iChar].resetAT();
		phase4();
	}

	// Game Logic
	public void phase1() {
		System.out.println("Phase 1");
		lblStatus1.setText("S+ Phase");
		lblStatus2.setText("Advancing slow actions...");
		lblStatus3.setText("");
		ListIterator iList = listAT.listIterator();
		while (iList.hasNext())
			((GameAction)iList.next()).tick();
		phase2();
	}

	public void phase2() {
		System.out.println("Phase 2");
		lblStatus1.setText("SR Phase");
		lblStatus2.setText("Resolving slow actions...");
		lblStatus3.setText("");
		ListIterator iList = listAT.listIterator();
		while (iList.hasNext()) {
			GameAction oAction = (GameAction)iList.next();
			if (oAction.isReady()) {
				oAction.fire();
				iList.remove();
			}
		}
		phase3();
	}

	public void phase3() {
		System.out.println("Phase 3");
		lblStatus1.setText("C+ Phase");
		lblStatus2.setText("Incrementing CT...");
		lblStatus3.setText("");
		for (int i = 0; i < listChar.length; i++)
			listChar[i].incrementCT();

		iChar = 0;
		phase4();
	}

	public void phase4() {
		System.out.println("Phase 4");
		lblStatus1.setText("Main Phase");
		lblStatus2.setText("Assigning AT...");
		lblStatus3.setText("");
		for (int i = iChar; i < listChar.length; iChar = ++i) {
			System.out.println(listChar[i]);
			if (listChar[i].isATReady()) {
				oActiveAvatar = listChar[i];
				oActiveAvatar.giveAT();
				lblStatus3.setText(oActiveAvatar.getName() + "'s AT");
				if (oParty.contains(oActiveAvatar))
					stateAT();
				else
					stateWaiting();
				return;
			}
		}
		phase1();
	}

	public void tradeParties() {
		oConn.sendObject(oParty);
		oOpponentParty = (Party)oConn.readObject();
//		oOpponentParty.resetImages();
		oMap.addOpponentParty();
	}

	public void makeAvatarOrder() {
		int nRand = (int)Math.floor((Math.random() + 1) + 0.5);
		String sOrder = "A,0|B,0|A,1|B,1|A,2|B,2|A,3|B,3|A,4|B,4";
		String sOrder2 = "B,0|A,0|B,1|A,1|B,2|A,2|B,3|A,3|B,4|A,4";
		if (nRand == 1) {
			makeAvatarOrder(sOrder);
			oConn.send("avatar order", sOrder2);
		} else {
			makeAvatarOrder(sOrder2);
			oConn.send("avatar order", sOrder);
		}
	}

	public void makeAvatarOrder(String sOrder) {
		String[] sTemp = sOrder.split("\\|");
		String[] sTemp2;
		listChar = new Avatar[sTemp.length];
		for (int i = 0; i < listChar.length; i++) {
			sTemp2 = sTemp[i].split(",");
			if (sTemp2[0].equals("A"))
				listChar[i] = oParty.getAvatar(Integer.parseInt(sTemp2[1]));
			else
				listChar[i] = oOpponentParty.getAvatar(Integer.parseInt(sTemp2[1]));
		}
	}

	public void run() {
		String[] sData;
		while (oConn.isConnected()) {
			sData = oConn.getData();
			System.out.println("Received \"" + sData[0] + "\" command.");

			if (sData[0].equals("chat"))
				panChat.addChat(sData[1]);
			else if (sData[0].equals("loadmap")) {
				try {
					oMap.loadMap(new File(DEFAULT_MAP_DIRECTORY + sData[1]));
					int nRand = (int)Math.floor((Math.random() + 1) + 0.5);
					stateDeploy(nRand);
					if (nRand == 1)
						nRand = 2;
					else
						nRand = 1;
					oConn.send("deploy","" + nRand);
				} catch (FileNotFoundException e) {
					oConn.send("error","Opponent does not have map.");
					actionDisconnect();
				}
			} else if (sData[0].equals("deploy")) {
				stateDeploy(Integer.parseInt(sData[1]));
			} else if (sData[0].equals("error")) {
				JOptionPane.showMessageDialog(frame, sData[1]);
				actionDisconnect();
			} else if (sData[0].equals("deployed")) {
				bOpponentDeployed = true;
				if (bDeployed) {
					oConn.send("trade parties", "");
					tradeParties();
					makeAvatarOrder();
					long nRandSeed = Math.round((Math.random() * Long.MAX_VALUE));
					oRandom = new Random(nRandSeed);
					oConn.send("random seed", "" + nRandSeed);
					oConn.send("phase", "1");
					phase1();

				}
			} else if (sData[0].equals("trade parties")) {
				tradeParties();
			} else if (sData[0].equals("avatar order")) {
				makeAvatarOrder(sData[1]);
			} else if (sData[0].equals("random seed")) {
				oRandom = new Random(Long.parseLong(sData[1]));
			} else if (sData[0].equals("phase")) {
				switch (Integer.parseInt(sData[1])) {
				case 1:
					phase1();
					break;
				case 2:
					phase2();
					break;
				case 3:
					phase3();
					break;
				case 4:
					iChar = 0;
					bMyAT = false;
					phase4();
					break;
				}
			} else if (sData[0].equals("move")) {
				oMap.moveATAvatar(Integer.parseInt(sData[1]), Integer.parseInt(sData[2]));
				// TEMP
				stateEndTurn();
			}
		}
	}


	//================Generic Methods:===========================================
	//--------------------------------echo---------------------------------------
	private void echo(String sMessage) {
		panChat.echo(sMessage);
	}

	//--------------------------------main---------------------------------------
 	public static void main(String[] args) {
		//Schedule a job for the event-dispatching thread:
		//creating and showing this application's GUI.
		javax.swing.SwingUtilities.invokeLater(new Runnable() {
			public void run() {
				createAndShowGUI();
			}
		});
	}
}
