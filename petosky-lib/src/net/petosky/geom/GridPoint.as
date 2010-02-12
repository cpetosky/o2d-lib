package net.petosky.geom {
	import flash.geom.Point;	
	
	/**
	 * @author Cory
	 */
	public class GridPoint {
		public var x:int;
		public var y:int;
		
		public function GridPoint(x:int = 0, y:int = 0) {
			this.x = x;
			this.y = y;
		}
		
		public function clone():GridPoint {
			return new GridPoint(x, y);
		}
		
		public function toString():String {
			return "(" + x + "," + y + ")";
		}
		
		public function toAngle():Number {
			return Math.atan2(y, x);
		}
		
		public function angleTo(p:GridPoint):Number {
			return Math.atan2(p.y - y, p.x - x);
		}
		
		public function normalize():Point {
			var len:Number = length;
			return new Point(x / len, y / len); 
		}
		
		public function get length():Number {
			return distance(this, new GridPoint());
		}
		
		public function distanceTo(p:GridPoint):Number {
			return distance(this, p);
		}
		
		public function compareTo(p:GridPoint):int {
			if (x < p.x)
				return -1;
			else if (x > p.x)
				return 1;
			else
				if (y < p.y)
					return -1;
				else if (y > p.y)
					return 1;
				else
					return 0;
		}
		
		public function crossProduct(p:GridPoint):int {
			return (x * p.y) - (p.x * y);
		}
		
		public function dotProduct(p:GridPoint):int {
			return x * p.x + y * p.y;
		}
		
		public function minus(p:GridPoint):GridPoint {
			return new GridPoint(x - p.x, y - p.y);
		}
		
		public static function distance(p1:GridPoint, p2:GridPoint):Number {
			return Math.sqrt((p1.x - p2.x)*(p1.x - p2.x) + (p1.y - p2.y)*(p1.y - p2.y));
		} 
		
		public static function direction(p1:GridPoint, p2:GridPoint, p3:GridPoint):int {
			return p3.minus(p1).crossProduct(p2.minus(p1));
		}
	}
}
