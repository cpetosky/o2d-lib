package net.petosky.o2d {

	/**
	 * @author Cory
	 */
	public class LogicalTile {
		private var _tiles:Vector.<Tile>;

		public function LogicalTile(tiles:Vector.<Tile>) {
			_tiles = tiles;
		}
	
		public function get access():uint {
			// Look for tile and return passage of highest tile on lowest priority.
			var first:Boolean = true;
			var passage:uint = TileAccess.NONE;
			var tile:Tile = null;
			for (var layer:int = 0; layer < Map.LAYERS; ++layer) {
				if (_tiles[layer]) {
					if (first) {
						passage = _tiles[layer].access;
						first = false;
					} else {
						if (tile.priority == _tiles[layer].priority)
							passage = _tiles[layer].access;
						else
							passage &= _tiles[layer].access;
					}
					tile = _tiles[layer];
				}
			}
	
			return passage;
		}
	}
}
