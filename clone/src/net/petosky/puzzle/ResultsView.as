package net.petosky.puzzle {
	import flash.display.DisplayObject;	
	
	import net.petosky.puzzle.display.MenuBackground;	
	import net.petosky.puzzle.display.SelectionTab;	
	
	import com.kongregate.as3.client.KongregateAPI;	
	
	import net.petosky.game.IHighScoreManager;	
	
	import flash.events.Event;	
	
	import net.petosky.game.View;

	/**
	 * @author Cory
	 */
	public class ResultsView extends View {
		
		private var _summary:SelectionTab;

		private var _mode:Mode;
		private var _level:uint;
		private var _score:uint;

		private var _scoreManager:IHighScoreManager;
		private var _levelManager:IHighScoreManager;
		
		private var _bg:DisplayObject;

		public function ResultsView(options:Object) {
			_mode = options.mode;
			_level = options.level;
			_score = options.score;

			_bg = new MenuBackground();
			_bg.x = (Session.instance.width - _bg.width) >> 1;
			_bg.y = (Session.instance.height - _bg.height) >> 1;
			addChild(_bg);
			
			_summary = new SelectionTab("GAME OVER", "LEVEL: " + _level + "\nSCORE: " + _score, Views.MENU, {});
			
			_summary.x = 115;
			_summary.y = 205;
						
			addChild(_summary);
			
			_scoreManager = Session.instance.getScoreManager(_mode.score);
			_levelManager = Session.instance.getScoreManager(_mode.level);
			
			if (_scoreManager.loggedIn) {
				addScore();
				submitStats();
			}
		}
		
		private function addScore(event:Event = null):void {
			_scoreManager.submitScore(_score);
			_levelManager.submitScore(_level);
		}
		
		private function submitStats():void {
			KongregateAPI.getInstance().stats.submitArray([
				{name: _mode.score, value: _score},
				{name: _mode.level, value: _level},
				{name: "HighScoreAllModes", value: _score},
				{name: "HighLevelAllModes", value: _level},
				{name: "TotalPoints", value: _score},
				{name: "TotalPlays", value: 1}
			]);
		}
	}
}
