package net.tanatopia.o2d.editor;

import java.awt.event.ActionListener;
import java.awt.event.KeyEvent;

import javax.swing.ButtonGroup;
import javax.swing.JMenu;
import javax.swing.JMenuBar;
import javax.swing.JMenuItem;
import javax.swing.JRadioButtonMenuItem;
import javax.swing.KeyStroke;


/**
 * <p><code>EditorMenuBar</code> is a standard <code>JMenuBar</code>
 * which automatically configures itself with the needed menus for
 * the editor, complete with hotkeys.</p>
 * @author Cory Petosky
 */
public class EditorMenuBar extends JMenuBar 
{	
	/**
	 * Holds a list of identifiers for configured menus.
	 */
	public enum MenuOption 
	{
		NEW_MAP,
		OPEN,
		SAVE,
		SAVEAS,
		SAVEALL,
		REVERT,
		LAYER1,
		LAYER2,
		LAYER3,
		LAYER4,
		PENCIL, 
		RECTANGLE, 
		ELLIPSE, 
		FILL, 
		SELECTION,
		SCALE_100,
		SCALE_50,
		SCALE_25,
		PALETTE_EDITOR,
		CLOSE,
		EXIT,
		ABOUT;
	}

	/**
	 * Constructor creates the JMenuBar and adds to it all the
	 * menus needed for this class.
	 * 
	 * @param al A reference to a listener object.  All menus will be
	 *		configured to notify this listener upon events.
	 */
	public EditorMenuBar(ActionListener al) 
	{
		super();

		JMenu oMenu = new JMenu("File");

		JMenuItem oMenuItem = new JMenuItem("New Map...");
		oMenuItem.setMnemonic(KeyEvent.VK_M);
		oMenuItem.setAccelerator(KeyStroke.getKeyStroke("control N"));
		oMenuItem.setActionCommand(MenuOption.NEW_MAP.toString());
		oMenuItem.addActionListener(al);
		//oMenuItem.setEnabled(false);
		oMenu.add(oMenuItem);

		oMenuItem = new JMenuItem("Open...");
		oMenuItem.setMnemonic(KeyEvent.VK_L);
		oMenuItem.setAccelerator(KeyStroke.getKeyStroke("control L"));
		oMenuItem.setActionCommand(MenuOption.OPEN.toString());
		oMenuItem.addActionListener(al);
		oMenuItem.setEnabled(true);
		oMenu.add(oMenuItem);
		
		oMenu.addSeparator();

		oMenuItem = new JMenuItem("Save");
		oMenuItem.setMnemonic(KeyEvent.VK_S);
		oMenuItem.setAccelerator(KeyStroke.getKeyStroke("control S"));
		oMenuItem.setActionCommand(MenuOption.SAVE.toString());
		oMenuItem.addActionListener(al);
		oMenuItem.setEnabled(true);
		oMenu.add(oMenuItem);
		
		oMenuItem = new JMenuItem("Save As...");
		oMenuItem.setActionCommand(MenuOption.SAVEAS.toString());
		oMenuItem.addActionListener(al);
		oMenuItem.setEnabled(true);
		oMenu.add(oMenuItem);
		
		oMenuItem = new JMenuItem("Save All");
		oMenuItem.setAccelerator(KeyStroke.getKeyStroke("control shift S"));
		oMenuItem.setActionCommand(MenuOption.SAVEALL.toString());
		oMenuItem.addActionListener(al);
		oMenuItem.setEnabled(false);
		oMenu.add(oMenuItem);
		
		oMenuItem = new JMenuItem("Revert");
		oMenuItem.setActionCommand(MenuOption.REVERT.toString());
		oMenuItem.addActionListener(al);
		oMenuItem.setEnabled(false);
		oMenu.add(oMenuItem);
		
		oMenu.addSeparator();
		
		oMenuItem = new JMenuItem("Close");
		oMenuItem.setMnemonic(KeyEvent.VK_W);
		oMenuItem.setAccelerator(KeyStroke.getKeyStroke("control W"));
		oMenuItem.setActionCommand(MenuOption.CLOSE.toString());
		oMenuItem.addActionListener(al);
		oMenuItem.setEnabled(false);
		oMenu.add(oMenuItem);

		oMenuItem = new JMenuItem("Exit");
		oMenuItem.setMnemonic(KeyEvent.VK_X);
		oMenuItem.setAccelerator(KeyStroke.getKeyStroke("alt F4"));
		oMenuItem.setActionCommand(MenuOption.EXIT.toString());
		oMenuItem.addActionListener(al);
		oMenuItem.setEnabled(false);
		oMenu.add(oMenuItem);

		add(oMenu);
				
		oMenu = new JMenu("View");
		oMenu.setEnabled(false);
		
		add(oMenu);
		
		oMenu = new JMenu("Draw");
		ButtonGroup drawGroup = new ButtonGroup();
		
		oMenuItem = new JRadioButtonMenuItem("Pencil");
		oMenuItem.setActionCommand(MenuOption.PENCIL.toString());
		oMenuItem.addActionListener(al);
		drawGroup.add(oMenuItem);
		drawGroup.setSelected(oMenuItem.getModel(), true);
		oMenu.add(oMenuItem);
		
		oMenuItem = new JRadioButtonMenuItem("Rectangle");
		oMenuItem.setActionCommand(MenuOption.RECTANGLE.toString());
		oMenuItem.addActionListener(al);
		drawGroup.add(oMenuItem);
		oMenuItem.setEnabled(false);
		oMenu.add(oMenuItem);
		
		oMenuItem = new JRadioButtonMenuItem("Ellipse");
		oMenuItem.setActionCommand(MenuOption.ELLIPSE.toString());
		oMenuItem.addActionListener(al);
		drawGroup.add(oMenuItem);
		oMenuItem.setEnabled(false);
		oMenu.add(oMenuItem);
		
		oMenuItem = new JRadioButtonMenuItem("Fill");
		oMenuItem.setActionCommand(MenuOption.FILL.toString());
		oMenuItem.addActionListener(al);
		drawGroup.add(oMenuItem);
		oMenuItem.setEnabled(false);
		oMenu.add(oMenuItem);
		
		oMenuItem = new JRadioButtonMenuItem("Selection");
		oMenuItem.setActionCommand(MenuOption.SELECTION.toString());
		oMenuItem.addActionListener(al);
		drawGroup.add(oMenuItem);
		oMenuItem.setEnabled(false);
		oMenu.add(oMenuItem);
		
		add(oMenu);
		
		oMenu = new JMenu("Scale");
		ButtonGroup scaleGroup = new ButtonGroup();
		
		oMenuItem = new JRadioButtonMenuItem("1/1");
		oMenuItem.setActionCommand(MenuOption.SCALE_100.toString());
		oMenuItem.addActionListener(al);
		scaleGroup.add(oMenuItem);
		scaleGroup.setSelected(oMenuItem.getModel(), true);
		oMenu.add(oMenuItem);
		
		oMenuItem = new JRadioButtonMenuItem("1/2");
		oMenuItem.setActionCommand(MenuOption.SCALE_50.toString());
		oMenuItem.addActionListener(al);
		scaleGroup.add(oMenuItem);
		oMenu.add(oMenuItem);

		oMenuItem = new JRadioButtonMenuItem("1/4");
		oMenuItem.setActionCommand(MenuOption.SCALE_25.toString());
		oMenuItem.addActionListener(al);
		scaleGroup.add(oMenuItem);
		oMenu.add(oMenuItem);

		add(oMenu);
		
		oMenu = new JMenu("Tools");

		oMenuItem = new JMenuItem("Palette Editor...");
		oMenuItem.setMnemonic(KeyEvent.VK_P);
		oMenuItem.setActionCommand(MenuOption.PALETTE_EDITOR.toString());
		oMenuItem.addActionListener(al);
		oMenu.add(oMenuItem);
		
		add(oMenu);

		oMenu = new JMenu("Help");

		oMenuItem = new JMenuItem("About o2d Editor...");
		oMenuItem.setMnemonic(KeyEvent.VK_A);
		oMenuItem.setActionCommand(MenuOption.ABOUT.toString());
		oMenuItem.addActionListener(al);
		oMenuItem.setEnabled(false);
		oMenu.add(oMenuItem);

		add(oMenu);
	}
}