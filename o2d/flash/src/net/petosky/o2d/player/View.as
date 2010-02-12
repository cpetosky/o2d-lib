package net.petosky.o2d.player {

	/**
	 * @author Cory Petosky
	 */
	public class View {
		public var x:int;
		public var y:int;
		public var width:int;
		public var height:int;
		public var screenX:int;
		public var screenY:int;
	
		public function View(x:int, y:int, width:int, height:int, screenX:int, screenY:int) {
			this.x = x;
			this.y = y;
			this.width = width;
			this.height = height;
			this.screenX = screenX;
			this.screenY = screenY;
		}
	}
}
