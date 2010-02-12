package net.tanatopia.o2d.editor;

import javax.swing.ButtonGroup;
import javax.swing.JLabel;
import javax.swing.JToggleButton;
import javax.swing.JToolBar;

import net.tanatopia.o2d.editor.EditorMenuBar.MenuOption;

/**
 * <p>This class acts as a toolbox for the editor maintaining a set of
 * tools, one of which can be selected at a given time.</p>
 * 
 * @author Cory Petosky
 * 
 */
public class EditorToolbar extends JToolBar {
	private JLabel layer;
	private JToggleButton layer1;
	private JToggleButton layer2;
	private JToggleButton layer3;
	private JToggleButton layer4;
			
	/**
	 * Creates a toolbox which displays as a JToolBar with the default
	 * set of buttons.  
	 * 
	 * @param alignment A constant, JToolBar.VERTICAL or JToolBar.HORIZONTAL
	 */
	public EditorToolbar(Editor editor, int alignment)
	{
		super(alignment);
		
		setFloatable(false);
		setRollover(true);
		setVisible(true);
		
		// Make and add components
		layer = new JLabel("Layer: ");
		
		add(layer);
		
		layer1 = new JToggleButton("1");
		layer1.setActionCommand(MenuOption.LAYER1.toString());
		layer1.addActionListener(editor);
		add(layer1);
		layer2 = new JToggleButton("2");
		layer2.setActionCommand(MenuOption.LAYER2.toString());
		layer2.addActionListener(editor);
		add(layer2);
		layer3 = new JToggleButton("3");
		layer3.setActionCommand(MenuOption.LAYER3.toString());
		layer3.addActionListener(editor);
		add(layer3);
		layer4 = new JToggleButton("4");
		layer4.setActionCommand(MenuOption.LAYER4.toString());
		layer4.addActionListener(editor);
		add(layer4);
		
		ButtonGroup layerGroup = new ButtonGroup();
		layerGroup.add(layer1);
		layerGroup.add(layer2);
		layerGroup.add(layer3);
		layerGroup.add(layer4);
		
	}
				
}
