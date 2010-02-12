package net.petosky.puzzle.display {
	import flash.display.DisplayObject;	
	import flash.display.Sprite;	
	
	import net.petosky.game.TextDisplay;	
	
	/**
	 * @author Try-Catch
	 */
	public class StatsDisplay extends Sprite {
		private static const WIDTH:uint = 80;
		private static const INITIAL_RATE:Number = 0.1;
		private static const RATE_ACCELERATION:Number = 1.1;

		private var _level:uint;
		private var _levelText:TextDisplay;
		
		private var _score:uint;
		private var _scoreText:TextDisplay;
		
		[Embed(source="/../gfx/stats_bg.png")]
		private static var Background:Class;
		private var _bg:DisplayObject;

		public function StatsDisplay(startingLevel:uint) {
			_bg = new Background();
			addChild(_bg);
			var label:TextDisplay = new TextDisplay(Main.TechFont, 14, WIDTH, "LEVEL");
			
			addChild(label);

			_levelText = new TextDisplay(Main.TechFont, 20, WIDTH);

			_levelText.y = 12;
			
			addChild(_levelText);
			level = startingLevel;
			
			label = new TextDisplay(Main.TechFont, 14, WIDTH, "SCORE");
			label.y = 40;
			
			addChild(label);

			_scoreText = new TextDisplay(Main.TechFont, 20, WIDTH);

			_scoreText.y = 55;
			
			addChild(_scoreText);

			score = _score;
		}

		public function get score():uint {
			return _score;
		}
		public function set score(value:uint):void {
			_score = value;
			_scoreText.text = _score.toString();
		}

		public function get level():uint {
			return _level;
		}
		public function set level(value:uint):void {
			_level = value;
			_levelText.text = _level.toString();
		}
		
		public function get rate():Number {
			return INITIAL_RATE + (Math.pow(_level, RATE_ACCELERATION) / 100);
		}
	}
}
