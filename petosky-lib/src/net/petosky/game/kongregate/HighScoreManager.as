package net.petosky.game.kongregate {
	import flash.errors.IllegalOperationError;	
	
	import com.kongregate.as3.client.KongregateAPI;
	
	import net.petosky.game.IHighScoreManager;	
	
	import flash.events.EventDispatcher;	
	
	public class HighScoreManager extends EventDispatcher implements IHighScoreManager {
		private var _mode:String;
		private var _limit:uint;
		private var _kong:KongregateAPI;
				
		public function HighScoreManager(mode:String, limit:uint = 0) {
			_mode = mode;
			_limit = limit;
			_kong = KongregateAPI.getInstance();
			
			if (!_kong.connected) {
				throw new IllegalOperationError(
					"[HighScoreManager] Kongregate API not connected!"
				);
			}
		}
		
		public function submitScore(score:uint):void {
			_kong.scores.submit(score, _mode);
		}

		public function submitScoreAndUsername(username:String, password:String, score:uint):void {
			throw new IllegalOperationError(
				"[HighScoreManager.submitScoreAndUsername] Cannot change users on Kongregate!"
			);
		}

		public function get loggedIn():Boolean {
			return _kong.user.getName() != "Guest";
		}
		
		public function get highScores():Array {
			throw new IllegalOperationError("High scores lists not yet support in Kongregate API!");
		}
	}
}