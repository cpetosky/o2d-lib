package net.petosky.puzzle {
	import flash.errors.IllegalOperationError;	
	
	/**
	 * @author Cory
	 */
	public class Mode {
		public static const EASY:Mode = new Mode("Easy (Points)", "Easy (Level)", EnumEnforcer);
		public static const MEDIUM:Mode = new Mode("Medium (Points)", "Medium (Level)", EnumEnforcer);

		private var _scoreMode:String;
		private var _levelMode:String;
		
		public function Mode(scoreMode:String, levelMode:String, enforcer:Class) {
			if (enforcer != EnumEnforcer)
				throw new IllegalOperationError("You cannot instantiate new enum objects.");
			
			_scoreMode = scoreMode;
			_levelMode = levelMode;
		}
		
		public function get score():String {
			return _scoreMode;
		}
		
		public function get level():String {
			return _levelMode;
		}
	}
}

class EnumEnforcer { }