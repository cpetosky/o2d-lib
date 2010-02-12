package net.petosky.dungeon.display {
	import net.petosky.util.NumberUtils;	
	
	import flash.geom.Point;	
	
	import net.petosky.geom.LineSegment;	
	import net.petosky.geom.GridPoint;	
	
	import flash.display.BitmapData;	
	
	/**
	 * @author Cory Petosky
	 */
	public class Polygon {
		public var texture:BitmapData;
		public var points:Vector.<GridPoint> = new Vector.<GridPoint>();
		
		private var _dirty:Boolean = true;
		
		private var _width:int;
		private var _height:int;
		
		private var _x:int;
		private var _y:int;
		
		public function Polygon(texture:BitmapData) {
			this.texture = texture;
		}
		
		public function recalc():void {
			if (!_dirty)
				return;
			_dirty = false;
			
			var minX:int = 100000, maxX:int = -100000, minY:int = 1000000, maxY:int = -100000;
			
			for each (var point:GridPoint in points) {
				minX = minX < point.x ? minX : point.x;
				maxX = maxX > point.x ? maxX : point.x;
				minY = minY < point.y ? minY : point.y;
				maxY = maxY > point.y ? maxY : point.y;
			}
			
			_width = maxX - minX;
			_height = maxY - minY;
			_x = minX;
			_y = minY;
		}
		
		public function truncate(minX:int, maxX:int, minY:int, maxY:int):Boolean {
			var ul:GridPoint = new GridPoint(minX, minY);
			var ur:GridPoint = new GridPoint(maxX, minY);
			var bl:GridPoint = new GridPoint(minX, maxY);
			var br:GridPoint = new GridPoint(maxX, maxY);
			
			try {
				var top:LineSegment = new LineSegment(ul, ur);
				var left:LineSegment = new LineSegment(ul, bl);
				var right:LineSegment = new LineSegment(ur, br);
				var bottom:LineSegment = new LineSegment(bl, br);
			
				var borderSegments:Vector.<LineSegment> = Vector.<LineSegment>([top, left, right, bottom]);
				
				var newPoints:Vector.<GridPoint> = new Vector.<GridPoint>();
				
				for (var i:uint = 0; i < points.length; ++i) {
					var start:GridPoint = points[i].clone();
					var end:GridPoint = points[(i + 1) % points.length];
					newPoints.push(start);
					
					var segment:LineSegment = new LineSegment(start, end);
					
					for each (var borderSegment:LineSegment in borderSegments) {
						var ip:Point = borderSegment.intersects(segment);
						if (ip) {
							var intersection:GridPoint = new GridPoint(ip.x, ip.y);
							newPoints.push(intersection);
						}
					}
					
					start.x = NumberUtils.clamp(minX, start.x, maxX);
					start.y = NumberUtils.clamp(minY, start.y, maxY);
					
				}
				
				points = newPoints;
			} catch (error:Error) {
				return false;
			}
			
			return true;
		}
	
		
		
		public function get width():int {
			recalc();
			return _width;
		}
		
		
		
		public function get height():int {
			recalc();
			return _height;
		}
		
		
		
		public function get x():int {
			recalc();
			return _x;
		}
		
		
		
		public function get y():int {
			recalc();
			return _y;
		}
	}
}
