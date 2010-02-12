package net.tanatopia.sp.games.tactics;

// StatusPanel
import net.tanatopia.sp.games.tactics.*;
import javax.swing.*;
import java.awt.*;

public class StatusPanel extends JTabbedPane {
	AvatarInfoPanel panInfo;

	//=============Constructors:==============================================
	public StatusPanel(Avatar newAvatar) {
		super();
		panInfo = new AvatarInfoPanel(newAvatar);
		add(panInfo, "Status");
	}

	public void setAvatar(Avatar newAvatar) {
		panInfo.setAvatar(newAvatar);
		repaint();
	}
	public void save() { panInfo.save(); }
	public static void main(String[] args) {
		Game.main(args);
	}
	//===============Subclasses:==============================================

}





