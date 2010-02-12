package net.petosky.dungeon.maze {
	import net.petosky.util.ByteArrayUtils;	
	
	import flash.utils.ByteArray;	
	
	import net.petosky.dungeon.maze.CellType;
	import net.petosky.dungeon.Directions;
	/**
	 * @author Cory
	 */
	public class Cell {
		public static const TILE_WIDTH:uint = 15;
		public static const TILE_HEIGHT:uint = 15;
		
		public static const WALL_WIDTH_HALL:uint = 2;
		public static const WALL_HEIGHT_HALL:uint = 1;
		
		public var walls:uint = Directions.NONE;
		public var visited:Boolean = false;
		
		public var room:Boolean = false;
		
		private var _object:CellObject;

		public function serialize():ByteArray {
			var bytes:ByteArray = new ByteArray();
			
			bytes.writeUnsignedInt(walls);
			if (_object) {
				bytes.writeBoolean(true);
				ByteArrayUtils.writeByteArray(_object.serialize(), bytes);
			} else {
				bytes.writeBoolean(false);
			}
			bytes.writeBoolean(visited);
			bytes.writeBoolean(room);
			
			return bytes;
		}
		
		public static function deserialize(bytes:ByteArray, floorID:uint):Cell {
			var cell:Cell = new Cell();
			
			cell.walls = bytes.readUnsignedInt();
			
			if (bytes.readBoolean())
				cell.object = CellObject.deserialize(ByteArrayUtils.readByteArray(bytes));
			
			cell.visited = bytes.readBoolean();
			cell.room = bytes.readBoolean();
			
			return cell;
		}

		
		
		public function get empty():Boolean {
			return walls == Directions.NONE;
		}
		
		
		
		public function get object():CellObject {
			return _object;
		}
		public function set object(value:CellObject):void {
			_object = value;
		}
	}
}
