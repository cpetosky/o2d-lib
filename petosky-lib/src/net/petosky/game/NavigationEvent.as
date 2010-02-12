package net.petosky.game {
	import flash.events.Event;	
	/**
	 * @author Cory
	 */
	public class NavigationEvent extends Event {
		public static const NAVIGATE:String = "navigate";
		
		private var _source:View;
		private var _destinationID:String;
		private var _options:Object;
		
		public function NavigationEvent(source:View, destinationID:String, options:Object = null) {
			super(NAVIGATE, true);
			
			_source = source;
			_destinationID = destinationID;
			_options = options;
		}

		public function get source():View {
			return _source;
		}
		
		public function get destinationID():String {
			return _destinationID;
		}
		
		public function get options():Object {
			return _options;
		}
	}
}
