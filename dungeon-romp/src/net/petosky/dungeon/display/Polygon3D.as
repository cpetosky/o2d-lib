package net.petosky.dungeon.display {
	import net.petosky.geom.GridPoint;	
	
	import flash.display.BitmapData;	
	
	/**
	 * @author Cory Petosky
	 */
	public class Polygon3D {
		public var texture:BitmapData;
		public var points:Vector.<GridPoint3D>;
		
		public function Polygon3D(texture:BitmapData, ...points) {
			this.texture = texture;
			
			this.points = Vector.<GridPoint3D>(points);
		}
		
		public function project(perspective:int, width:int, height:int):Polygon {
			var polygon:Polygon = new Polygon(texture);
			
			for each (var point3D:GridPoint3D in points) {
				var point:GridPoint = point3D.convertToScreenPoint(perspective);
				point.x += width >> 1;
				point.y += height >> 1;
				polygon.points.push(point);
			}
			
			polygon.recalc();
			
			return polygon;
		}
	}
}
