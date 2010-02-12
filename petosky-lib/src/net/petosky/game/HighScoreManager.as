package net.petosky.game {
	import flash.events.ErrorEvent;	
	import flash.events.EventDispatcher;	
	import flash.events.TimerEvent;	
	import flash.utils.Timer;	
	import flash.events.Event;	
	import flash.net.URLLoader;	
	import flash.net.URLRequestMethod;	
	import flash.net.URLVariables;	
	import flash.net.URLRequest;	
	
	import com.adobe.crypto.SHA1;	
	
	/**
	 * @author Cory
	 */
	public class HighScoreManager extends EventDispatcher implements IHighScoreManager {
		private static const URL:String = "http://backend.petosky.net/scores.php";
		
		private var _modeID:uint;
		private var _username:String;
		private var _password:String;
		private var _limit:uint;
		
		private var _highScores:XML;
		private var _highScoresTimer:Timer;

		public function HighScoreManager(modeID:uint, limit:uint = 0, username:String = "", password:String = "") {
			_modeID = modeID;
			_limit = limit;
			_username = username;
			_password = password;
			
			_highScoresTimer = new Timer(1000 * 15, 0);
			_highScoresTimer.addEventListener(TimerEvent.TIMER, fetchHighScores, false, 0, true);
			_highScoresTimer.start();
			
			fetchHighScores();
		}

		public function submitScore(score:uint):void {
			var request:URLRequest = new URLRequest(URL);
			var vars:URLVariables = new URLVariables();
			
			vars.username = _username;
			vars.password = _password;
			vars.modeID = _modeID;
			vars.score = score;
			
			request.method = URLRequestMethod.POST;
			request.data = vars;
			
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, submitScoreCompleteListener);
			loader.load(request);	
		}
		
		public function submitScoreAndUsername(username:String, password:String, score:uint):void {
			_username = username;
			_password = SHA1.hash(password);
			
			submitScore(score);
		}
		
		private function submitScoreCompleteListener(event:Event):void {
			event.target.removeEventListener(Event.COMPLETE, submitScoreCompleteListener);
			var xml:XML = new XML(event.target.data);
			if (xml.name().localName == "error") {
				_username = "";
				_password = "";
				dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, "Username exists with different password."));
			} else {
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		private function fetchHighScores(event:TimerEvent = null):void {
			var query:String = URL + "?modeID=" + _modeID + "&randomString=" + SHA1.hash(Math.random().toString());
			if (_limit > 0)
				query += "&limit=" + _limit.toString();
				
			var request:URLRequest = new URLRequest(query);

			request.method = URLRequestMethod.GET;
						
			var loader:URLLoader = new URLLoader();

			loader.addEventListener(Event.COMPLETE, assignHighScores);
			loader.load(request);				
		}
		
		private function assignHighScores(event:Event):void {
			event.target.removeEventListener(Event.COMPLETE, assignHighScores);
			_highScores = new XML(event.target.data);
		}

		public function get loggedIn():Boolean {
			return _username != "";
		}
		
		public function get highScores():Array {
			var scores:Array = [];
			for each (var score:XML in _highScores.score) {
				scores.push({username: score.@user, score: score});
			}
			
			return scores;
		}
	}
}
