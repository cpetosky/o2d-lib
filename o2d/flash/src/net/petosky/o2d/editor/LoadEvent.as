package net.petosky.o2d.editor {
	import flash.events.Event;
	
	import net.petosky.o2d.Game;
	
	public class LoadEvent extends Event {
		public static const LOAD_COMPLETE:String = "loadComplete";
		public static const LOAD_FAILED:String = "loadFailed";
		
		private var _game:Game;
		
		public function LoadEvent(type:String, game:Game = null) {
			super(type);
			_game = game;
		}
		
		override public function clone():Event {
			return new LoadEvent(type, _game);
		}
		
		public function get game():Game {
			return _game;
		}
	}
}