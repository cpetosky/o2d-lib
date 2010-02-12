package net.tanatopia.sp.games.tactics;

import net.tanatopia.sp.games.tactics.*;
import javax.swing.JMenuBar;
import javax.swing.JMenu;
import javax.swing.JMenuItem;
import javax.swing.KeyStroke;
import java.awt.event.KeyEvent;
import java.awt.event.ActionListener;

public class GameMenuBar extends JMenuBar {
	public GameMenuBar(ActionListener al) {
		super();

		JMenu oMenu = new JMenu("File");

		JMenuItem oMenuItem = new JMenuItem("Connect...");
		oMenuItem.setMnemonic(KeyEvent.VK_C);
		oMenuItem.setAccelerator(KeyStroke.getKeyStroke("F2"));
		oMenuItem.setActionCommand("connect");
		oMenuItem.addActionListener(al);
		oMenu.add(oMenuItem);

		oMenuItem = new JMenuItem("Host...");
		oMenuItem.setMnemonic(KeyEvent.VK_H);
		oMenuItem.setAccelerator(KeyStroke.getKeyStroke("F3"));
		oMenuItem.setActionCommand("host");
		oMenuItem.addActionListener(al);
		oMenu.add(oMenuItem);

		oMenu.addSeparator();

		oMenuItem = new JMenuItem("Save Party");
		oMenuItem.setMnemonic(KeyEvent.VK_S);
		oMenuItem.setAccelerator(KeyStroke.getKeyStroke("control S"));
		oMenuItem.setActionCommand("save party");
		oMenuItem.addActionListener(al);
		oMenu.add(oMenuItem);

		oMenuItem = new JMenuItem("Load Party");
		oMenuItem.setMnemonic(KeyEvent.VK_L);
		oMenuItem.setAccelerator(KeyStroke.getKeyStroke("control L"));
		oMenuItem.setActionCommand("load party");
		oMenuItem.addActionListener(al);
		oMenu.add(oMenuItem);

		oMenu.addSeparator();

		oMenuItem = new JMenuItem("Disconnect");
		oMenuItem.setMnemonic(KeyEvent.VK_D);
		oMenuItem.setAccelerator(KeyStroke.getKeyStroke("control D"));
		oMenuItem.setActionCommand("disconnect");
		oMenuItem.addActionListener(al);
		oMenu.add(oMenuItem);

		oMenuItem = new JMenuItem("Quit");
		oMenuItem.setMnemonic(KeyEvent.VK_Q);
		oMenuItem.setAccelerator(KeyStroke.getKeyStroke("alt F4"));
		oMenuItem.setActionCommand("quit");
		oMenuItem.addActionListener(al);
		oMenu.add(oMenuItem);

		add(oMenu);

		oMenu = new JMenu("Map");

		oMenuItem = new JMenuItem("Open Map...");
		oMenuItem.setMnemonic(KeyEvent.VK_O);
		oMenuItem.setAccelerator(KeyStroke.getKeyStroke("control O"));
		oMenuItem.setActionCommand("open map");
		oMenuItem.addActionListener(al);
		oMenu.add(oMenuItem);

		add(oMenu);

		oMenu = new JMenu("Party");

		oMenuItem = new JMenuItem("Form New Party...");
		oMenuItem.setMnemonic(KeyEvent.VK_F);
		oMenuItem.setAccelerator(KeyStroke.getKeyStroke("control N"));
		oMenuItem.setActionCommand("form party");
		oMenuItem.addActionListener(al);
		oMenu.add(oMenuItem);

		oMenuItem = new JMenuItem("Edit Party Lineup...");
		oMenuItem.setMnemonic(KeyEvent.VK_E);
		oMenuItem.setAccelerator(KeyStroke.getKeyStroke("control E"));
		oMenuItem.setActionCommand("edit party");
		oMenuItem.addActionListener(al);
		oMenu.add(oMenuItem);

		oMenu.addSeparator();

		oMenuItem = new JMenuItem("View Party Details...");
		oMenuItem.setMnemonic(KeyEvent.VK_V);
		oMenuItem.setAccelerator(KeyStroke.getKeyStroke("control V"));
		oMenuItem.setActionCommand("view party");
		oMenuItem.addActionListener(al);
		oMenu.add(oMenuItem);

		oMenuItem = new JMenuItem("View Character Pool...");
		oMenuItem.setMnemonic(KeyEvent.VK_P);
		oMenuItem.setAccelerator(KeyStroke.getKeyStroke("control P"));
		oMenuItem.setActionCommand("view pool");
		oMenuItem.addActionListener(al);
		oMenu.add(oMenuItem);

		add(oMenu);
	}

}