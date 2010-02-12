package net.petosky.events {
	import flash.events.Event;
	
	public class FunctionalityEvent extends Event {
		
		public static const FUNCTION_AVAILABLE:String = "functionAvailable";
		public static const FUNCTION_UNAVAILABLE:String = "functionUnavailable";
		
		private var _functionID:String;
		
		public function FunctionalityEvent(type:String, functionID:String) {
			super(type);
			_functionID = functionID;
		}
		
		override public function clone():Event {
			return new FunctionalityEvent(type, functionID);
		}
		
		public function get functionID():String {
			return _functionID;
		}
	}
}