package net.petosky.puzzle.display {
	import net.petosky.game.TextDisplay;	
	import net.petosky.puzzle.display.SelectionTab;
	
	/**
	 * @author Try-Catch
	 */
	public class SummaryTab extends SelectionTab {
		public function SummaryTab(mainText:String, subText:String, view:String, options:Object) {
			super(mainText, subText, view, options);
			
			var t:TextDisplay = new TextDisplay(Main.TechFont, 18, _bg.width, "BACK TO MENU");
			t.y = 40;
			addChild(t);
		}
	}
}
