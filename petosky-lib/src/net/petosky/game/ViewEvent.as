package net.petosky.game {
	import flash.events.Event;	
	
	/**
	 * @author Cory
	 */
	public class ViewEvent extends Event {
		public static const HIDDEN:String = "hidden";
		
		public function ViewEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
		}
	}
}
