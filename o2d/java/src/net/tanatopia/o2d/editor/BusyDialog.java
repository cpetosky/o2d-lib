package net.tanatopia.o2d.editor;

import java.awt.Dialog;
import java.awt.Frame;

import javax.swing.JDialog;
import javax.swing.JLabel;
import javax.swing.JProgressBar;

public class BusyDialog extends JDialog {
	public BusyDialog(Dialog owner, String message) {
		super(owner, message, true);
		init(message);
	}
	
	public BusyDialog(Frame owner, String message) {
		super(owner, message, true);
		init(message);
	}
	
	private void init(String message) {
		JProgressBar bar = new JProgressBar();
		bar.setIndeterminate(true);
		JLabel label = new JLabel(message);
		add(label);
		add(bar);
		pack();
	}
	
	public void display() {
		// TODO Auto-generated method stub
		SwingWorker x = new SwingWorker() {
			public Object construct() {
				setVisible(true);
				return null;
			}
		};
		
		x.start();
	}
}
