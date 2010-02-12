package net.petosky.events {
	import flash.events.Event;
	
	public class StatusChangeEvent extends Event {
		public static const STATUS_CHANGE:String = "statusChange";
		
		private var _text:String;
		
		public function StatusChangeEvent(text:String) {
			super(STATUS_CHANGE);
			_text = text;
		}
		
		public function get text():String {
			return _text;
		}
		
		override public function clone():Event {
			return new StatusChangeEvent(_text);
		}

	}
}