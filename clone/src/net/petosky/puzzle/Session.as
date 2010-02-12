package net.petosky.puzzle {
	import net.petosky.game.IHighScoreManager;	
	
	import net.petosky.game.kongregate.HighScoreManager;	
	
	import flash.errors.IllegalOperationError;	
	
	/**
	 * @author Cory
	 */
	public class Session {
		private static var __instance:Session;
		
		public static function get instance():Session {
			if (__instance == null)
				__instance = new Session(new SingletonEnforcer());
			return __instance;
		}
		
		private var _highScores:Object = {};
		
		public function Session(enforcer:SingletonEnforcer) {
			if (enforcer == null)
				throw new IllegalOperationError(
					"[Session] This is a singleton -- you can't instantiate it."
				);
			 
			_highScores[Mode.EASY.score] = new HighScoreManager(Mode.EASY.score, 7);
			_highScores[Mode.MEDIUM.score] = new HighScoreManager(Mode.MEDIUM.score, 7);
			_highScores[Mode.EASY.level] = new HighScoreManager(Mode.EASY.level, 7);
			_highScores[Mode.MEDIUM.level] = new HighScoreManager(Mode.MEDIUM.level, 7);			

		}
		
		public function getScoreManager(mode:String):IHighScoreManager {
			return _highScores[mode];
		}
		
		public function get width():uint {
			return 320;
		}
		
		public function get height():uint {
			return 480;
		}
	}
}

class SingletonEnforcer { }