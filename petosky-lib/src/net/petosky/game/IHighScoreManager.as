package net.petosky.game {
	import flash.events.IEventDispatcher;	

	/**
	 * @author Cory
	 */
	public interface IHighScoreManager extends IEventDispatcher {
		function submitScore(score:uint):void;
		function submitScoreAndUsername(username:String, password:String, score:uint):void;
		
		function get loggedIn():Boolean;
		function get highScores():Array;
	}
}
