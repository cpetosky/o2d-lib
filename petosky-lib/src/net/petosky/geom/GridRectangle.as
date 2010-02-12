package net.petosky.geom {

	/**
	 * @author Cory
	 */
	public class GridRectangle {
		public var x:int;
		public var y:int;
		public var width:uint;
		public var height:uint;
		
		public function GridRectangle(x:int = 0, y:int = 0, width:uint = 0, height:uint = 0) {
			this.x = x;
			this.y = y;
			this.width = width;
			this.height = height;
		}
		
		public function get left():int {
			return x;
		}
		
		public function get right():int {
			return x + width;
		}
		
		public function get top():int {
			return y;
		}
		
		public function get bottom():int {
			return y + height;
		} 
	}
}
