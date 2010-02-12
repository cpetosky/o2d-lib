package net.petosky.dungeon.display {
	import net.petosky.geom.GridPoint;	
	
	/**
	 * @author Cory Petosky
	 */
	public class GridPoint3D extends GridPoint {
		private var _z:int;
		
		public function GridPoint3D(x:int = 0, y:int = 0, z:int = 0) {
			super(x, y);
			_z = z;
		}
		
		public function convertToScreenPoint(perspective:int = 1):GridPoint {
			return new GridPoint(
				perspective * x / (z > 0 ? z : 1),
				perspective * y / (z > 0 ? z : 1)
			);
		}

		
		
		public function get z():int {
			return _z;
		}
		public function set z(value:int):void {
			_z = value;
		}
	}
}
