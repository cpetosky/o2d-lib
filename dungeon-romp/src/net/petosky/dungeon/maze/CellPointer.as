package net.petosky.dungeon.maze {
	import net.petosky.dungeon.Directions;	
	
	/**
	 * @author Cory Petosky
	 */
	public class CellPointer {
		private var _x:int;
		private var _y:int;
		
		private var _floor:Floor;
		
		public function CellPointer(floor:Floor, x:int = 0, y:int = 0) {
			_floor = floor;
			_x = x;
			_y = y;
		}
		
		public function moveDirection(dir:uint):CellPointer {
			if (dir == Directions.NORTH) {
				_y--;
			} else if (dir == Directions.EAST) {
				_x++;
			} else if (dir == Directions.SOUTH) {
				_y++;
			} else if (dir == Directions.WEST) {
				_x--;
			}
			
			return this;
		}



		public function get x():int {
			return _x;
		}
		
		
		
		public function get y():int {
			return _y;
		}
		
		
		
		public function get cell():Cell {
			return _floor.getCell(_x, _y);
		}
	}
}
