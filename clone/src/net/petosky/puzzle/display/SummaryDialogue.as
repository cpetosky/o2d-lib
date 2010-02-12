package net.petosky.puzzle.display {
	import net.petosky.puzzle.Views;	
	import net.petosky.game.NavigationEvent;	
	
	import flash.events.MouseEvent;	
	
	import net.petosky.game.TextDisplay;	
	import net.petosky.game.Dialogue;	
	
	/**
	 * @author Cory
	 */
	public class SummaryDialogue extends Dialogue {
		public function SummaryDialogue(width:uint, height:uint, level:uint, score:uint) {
			super(width, height);
			
			var label:TextDisplay = new TextDisplay(Main.TechFont, 24, width - 10, "Game Over"
			);

			label.x = 5;
			label.y = 5;
			addChild(label);
						
			var levelDisplay:TextDisplay = new TextDisplay(Main.TechFont, 18, width - 10, "Level: " + level
			);
			
			levelDisplay.x = label.x;
			levelDisplay.y = label.y + label.height;
			addChild(levelDisplay);
			
			var scoreDisplay:TextDisplay = new TextDisplay(Main.TechFont, 18, width - 10, "Score: " + score
			);
			
			scoreDisplay.x = label.x;
			scoreDisplay.y = levelDisplay.y + levelDisplay.height;
			addChild(scoreDisplay);
			
			var menu:TextDisplay = new TextDisplay(Main.TechFont, 22, width - 10, "Back to Menu"
			);
			
			menu.x = label.x;
			menu.y = height - menu.height - 5;
			menu.addEventListener(MouseEvent.CLICK, menuListener, false, 0, true);
			addChild(menu);		
		}
		
		private function menuListener(event:MouseEvent):void {
			dispatchEvent(new NavigationEvent(null, Views.MENU));
		}
	}
}
