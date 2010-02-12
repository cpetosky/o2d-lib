package net.petosky.puzzle {
	import net.petosky.puzzle.display.MenuBackground;	
	import net.petosky.puzzle.display.StandardSelectionTab;	
	import net.petosky.puzzle.display.SelectionTab;	
	
	import flash.display.DisplayObject;	
	
	import net.petosky.game.View;	
	
	/**
	 * @author Cory
	 */
	public class MenuView extends View {
		private var _bg:DisplayObject;

		public function MenuView(options:Object) {
			_bg = new MenuBackground();
			_bg.x = (Session.instance.width - _bg.width) >> 1;
			_bg.y = (Session.instance.height - _bg.height) >> 1;
			addChild(_bg);
			
			var s:SelectionTab;
			
			s = new StandardSelectionTab("EASY", "FIVE DEFECTS", Views.GAME, {blockCount: 5, mode: Mode.EASY}, 5);
			s.x = 115;
			s.y = 205;
			addChild(s);
			
			s = new StandardSelectionTab("MEDIUM", "SIX DEFECTS", Views.GAME, {blockCount: 6, mode: Mode.MEDIUM}, 6);
			s.x = 115;
			s.y = 274;
			addChild(s);
		}			
	}
}
