package net.petosky.dungeon.maze {
	import flash.utils.ByteArray;	
	
	/**
	 * @author Cory Petosky
	 */
	public class StairsDownObject extends CellObject {
		
		private var _floorID:uint;
		private var _cellX:int;
		private var _cellY:int;
		
		public function StairsDownObject(floorID:uint, cellX:int = -1, cellY:int = -1) {
			super("stairsDown");
			
			_floorID = floorID;
			_cellX = cellX;
			_cellY = cellY;
		}
		
		override public function serialize():ByteArray {
			var bytes:ByteArray = new ByteArray();
			
			bytes.writeUTF(type);
			bytes.writeUnsignedInt(_floorID);
			bytes.writeInt(_cellX);
			bytes.writeInt(_cellY);
			
			return bytes;
		}
		
		
		
		public function get floorID():uint {
			return _floorID;
		}
		
		
		
		public function get cellX():int {
			return _cellX;
		}
		
		
		
		public function get cellY():int {
			return _cellY;
		}
	}
}
