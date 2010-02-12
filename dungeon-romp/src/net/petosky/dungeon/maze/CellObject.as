package net.petosky.dungeon.maze {
	import flash.utils.ByteArray;	
	
	/**
	 * @author Cory Petosky
	 */
	public class CellObject {
		private var _type:String;
		
		public function CellObject(type:String) {
			_type = type;
		}
		
		
		public function serialize():ByteArray {
			var bytes:ByteArray = new ByteArray();
			bytes.writeUTF(_type);
			
			return bytes;
		}

		
		
		public function get type():String {
			return _type;
		}
		
		public static function deserialize(bytes:ByteArray):CellObject {
			var type:String = bytes.readUTF();
			
			if (type == CellType.INN)
				return new InnObject();
			else if (type == CellType.TAVERN)
				return new TavernObject();
			else if (type == CellType.STAIRS_DOWN)
				return new StairsDownObject(bytes.readUnsignedInt(), bytes.readInt(), bytes.readInt());
			
			return null;
		}
	}
}
