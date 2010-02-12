package net.petosky.o2d {
	import flash.display.BitmapData;	
	
	/**
	 * @author Cory
	 */
	public class TileInfo {
		public var _id:int;
		public var _name:String;
		public var _priority:int;
		public var _access:uint;
		public var _texture:BitmapData;
	
		public function TileInfo(id:int, name:String, priority:int, access:uint, texture:BitmapData = null) {
			_id = id;
			_name = name;
			_priority = priority;
			_access = access;
			_texture = texture;
		}
	
		public function get blank():Boolean {
			return _name == "{!BLANK!}";
		}
	
		public function get frames():int {
			if (_texture.height > Tile.SIZE) // Dynamic Texture
				return _texture.width / (Tile.SIZE * 3);
			else // Static Texture
				return _texture.width / Tile.SIZE;
		}
	
		public function get type():uint {
			if (blank)
				return TileType.BLANK;
			if (_texture.height > Tile.SIZE) // Dynamic Texture
				if (frames == 1)
					return TileType.DYNAMIC;
				else
					return TileType.DYNAMIC_ANIMATED;
			else // Static Texture
				if (frames == 1)
					return TileType.STATIC;
				else
					return TileType.STATIC_ANIMATED;
		}
	}
}
