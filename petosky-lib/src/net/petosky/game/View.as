package net.petosky.game {
	import flash.display.Sprite;	
	
	/**
	 * @author Cory
	 */
	public class View extends Sprite {
		public function hide():void {
			dispatchEvent(new ViewEvent(ViewEvent.HIDDEN));
		}
	}
}
