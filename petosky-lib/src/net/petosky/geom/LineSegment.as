package net.petosky.geom {
	import com.trycatchgames.common.util.NumberUtils;	
	
	import flash.geom.Point;	
	
	/**
	 * @author cory
	 */
	public class LineSegment {
		private var _start:GridPoint;
		private var _end:GridPoint;
		
		public function LineSegment(start:GridPoint, end:GridPoint) {
			var compare:int = start.compareTo(end);
			if (compare == 0)
				throw new ArgumentError("[LineSegment] A line segment must have distinct endpoints.");
			else if (compare < 0) {
				_start = start;
				_end = end;
			} else {
				_start = end;
				_end = start;
			}
		}
		
		public function intersects(s:LineSegment):Point {

			var intersection:Point = new Point();
			
			var a1:Number = _end.y - _start.y;
			var b1:Number = _start.x - _end.x;
			var c1:Number = _end.x * _start.y - _start.x * _end.y;
			
			var a2:Number = s._end.y - s._start.y;
			var b2:Number = s._start.x - s._end.x;
			var c2:Number = s._end.x * s._start.y - s._start.x * s._end.y;
			
			var denom:Number = a1 * b2 - a2 * b1;
			
			if (denom == 0)
				return null;
				
			intersection.x = (b1 * c2 - b2 * c1) / denom;
			intersection.y = (a2 * c1 - a1 * c2) / denom;
			
			if (inBoundingBox(intersection) && s.inBoundingBox(intersection))
				return intersection;
			else
				return null;
		}
		
		public function inBoundingBox(point:Point):Boolean {
			return (
				NumberUtils.isBetween(point.x, _start.x, _end.x) &&
				NumberUtils.isBetween(point.y, _start.y, _end.y));
		}	
	}
}
