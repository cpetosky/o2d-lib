package net.petosky.game {
	import flash.display.Sprite;	
	
	/**
	 * @author Cory
	 */
	public class HighScoreList extends Sprite {
		public function HighScoreList(scores:Array, font:String, fontSize:uint, width:uint) {
			var y:uint = 5;
			for (var i:uint = 0; i < scores.length; ++i) {
				var line:TextDisplay = new TextDisplay(font, fontSize, width - 10, scores[i].username + ": " + scores[i].score);
				line.x = 5;
				line.y = y;
				y += line.height;
				
				addChild(line);
			}
		}
	}
}
