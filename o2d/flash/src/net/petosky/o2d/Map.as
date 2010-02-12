package net.petosky.o2d {
	import flash.utils.ByteArray;
	import net.petosky.geom.GridPoint3;
	import net.petosky.o2d.player.View;	
	
	import flash.display.BitmapData;	
	
	/**
	 * @author Cory
	 */
	public class Map {
		public static const LAYERS:uint = 3;
		public static const PRIORITIES:uint = 6;

		private var _width:int;
		private var _height:int;

		private var _palette:Palette;

		private var _tiles:Vector.<Vector.<Vector.<Tile>>>; // 3d of Tiles
		private var _neighbors:Vector.<Vector.<Vector.<int>>>; // 3d of ints

		private var _frame:int = 0;
		private var _zoom:Number = 1.0;

		private var _name:String;
		private var _id:int;

		private var _entities:Object = {}; // <uint, Entity>

		private var _frameCounter:int = 0;
		
		private var _dirtyNeighbors:Vector.<GridPoint3> = new Vector.<GridPoint3>();


		public function Map(enforcer:FactoryEnforcer) { }
		
		public function serialize():ByteArray {
			var out:ByteArray = new ByteArray();
			
			out.writeInt(0); // fileversion
			out.writeInt(_id); // id
			out.writeUTF(_name); // Name
			out.writeInt(_width); // width
			out.writeInt(_height); // height
			out.writeInt(_palette.id); // palette
			
			for (var i:int = 0; i < _width; ++i) {
				for (var j:int = 0; j < _height; ++j) {
					for (var l:int = 0; l < LAYERS; ++l) {
						out.writeInt(_tiles[i][j][l] ? _tiles[i][j][l].id : -1);
					}
				}
			}
			
			return out;
		}
		
		public static function deserialize(bytes:ByteArray, project:Project):Map {
			var map:Map = new Map(new FactoryEnforcer());
			
			map.deserialize(bytes, project);
			
			return map;
		}
		
		private function deserialize(bytes:ByteArray, project:Project):void {
			var version:int = bytes.readInt();
			if (version == 0) {
				_id = bytes.readInt();
				_name = bytes.readUTF();
				_width = bytes.readInt();
				_height = bytes.readInt();
				_palette = project.getPalette(bytes.readInt());
				
				_tiles = new Vector.<Vector.<Vector.<Tile>>>();
				for (var i:int = 0; i < _width; ++i) {
					_tiles.push(new Vector.<Vector.<Tile>>());
					for (var j:int = 0; j < _height; ++j) {
						_tiles[i].push(new Vector.<Tile>());
						for (var l:int = 0; l < LAYERS; ++l) {
							var tileID:int = bytes.readInt();
							_tiles[i][j].push(tileID != -1 ? _palette.getTile(tileID) : null);
						}
					}
				}
				
				initializeNeighbors();
			}
		}
		
		public static function create(id:int, palette:Palette, width:int, height:int, name:String):Map {
			var map:Map = new Map(new FactoryEnforcer());
			
			map.create(id, palette, width, height, name);
			
			return map;
		}
		
		private function create(id:int, palette:Palette, width:int, height:int, name:String):void {
			_id = id;
			_palette = palette;
			_width = width;
			_height = height;
			_name = name;

			_tiles = new Vector.<Vector.<Vector.<Tile>>>();
			for (var i:int = 0; i < _width; ++i) {
				_tiles.push(new Vector.<Vector.<Tile>>());
				for (var j:int = 0; j < _height; ++j) {
					_tiles[i].push(new Vector.<Tile>());
					for (var l:int = 0; l < LAYERS; ++l) {
						_tiles[i][j].push(l == 0 ? palette.defaultTile : null);
					}
				}
			}
			
			initializeNeighbors();
		}



		public function initializeNeighbors():void {
			_neighbors = new Vector.<Vector.<Vector.<int>>>();
			for (var i:int = 0; i < _width; ++i) {
				_neighbors.push(new Vector.<Vector.<int>>());
				for (var j:int = 0; j < _height; ++j) {
					_neighbors[i].push(new Vector.<int>());
					for (var l:int = 0; l < LAYERS; ++l) {
						_neighbors[i][j].push(getNeighborProfile(i, j, l));
					}
				}
			}

			_dirtyNeighbors = new Vector.<GridPoint3>();
		}
		
		private function fixDirtyNeighbors():void {
			while (_dirtyNeighbors.length > 0) {
				var point:GridPoint3 = _dirtyNeighbors.pop();
				
				for (var i:int = point.x - 1, n:int = point.x + 1; i <= n; ++i)
					if (i >= 0 && i < _width)
						for (var j:int = point.y - 1, m:int = point.y + 1; j <= m; ++j)
							if (j >= 0 && j < _height)
								_neighbors[i][j][point.z] = getNeighborProfile(i, j, point.z);
			}
		}

		// Indexers
		public function getLogicalTile(i:uint, j:uint):LogicalTile {
			var tiles:Vector.<Tile> = new Vector.<Tile>(LAYERS);
			for (var layer:uint = 0; layer < LAYERS; ++layer)
				tiles[layer] = _tiles[i][j][layer];
			return new LogicalTile(tiles);
		}

		/// <summary>
		/// Get the tile at the location and layer.
		/// </summary>
		/// <param name="i">x-coordinate</param>
		/// <param name="j">y-coordinate</param>
		/// <param name="l">layer</param>
		/// <returns>Tile at this location, or null if location is empty</returns>
		public function getTile(i:int, j:int, layer:int):Tile {
			return _tiles[i][j][layer];
		}
		
		public function setTile(i:int, j:int, layer:int, value:Tile):void {
			_tiles[i][j][layer] = value;
			_dirtyNeighbors.push(new GridPoint3(i, j, layer));
		}

		// Properties

		public function get id():int {
			return _id;
		}

		/// <summary>
		/// The width of the map, in tiles.
		/// </summary>
		public function get width():int {
			return _width;
		}

		/// <summary>
		/// The height of the map, in tiles.
		/// </summary>
		public function get height():int {
			return _height;
		}

		public function get pixelWidth():int {
			return Tile.SIZE * _width;
		}

		public function get pixelHeight():int {
			return Tile.SIZE * height;
		}

		public function get name():String {
			return _name;
		}
		
		public function toString():String {
			return _name;
		}

		public function get zoom():Number {
			return _zoom;
		}
		public function set zoom(value:Number):void {
			_zoom = value;
		}

		public function get palette():Palette {
			return _palette;
		}



		public function passTime(delta:int):void {
			_frameCounter += delta;
			
			while (_frameCounter > 400) {
				_frameCounter -= 400;
				advanceFrame();
			}

			for each (var entity:Entity in _entities) {
				entity.update(delta);
				entity.move(delta);

				// Animation
				if (!entity.animating && entity.moving)
					entity.startAnimation(175);
				else if (entity.animating && !entity.moving)
					entity.stopAnimation();
			}
		}
		
		public function advanceFrame():void {
			_frame = (_frame + 1) % 4;
		}

		public function addEntity(entity:Entity):void {
			_entities[entity.id] = entity;
		}

		public function removeEntity(entity:Entity):void {
			delete _entities[entity.id];
		}


		// Rendering

		public function render(output:BitmapData, view:View):void {
			output.fillRect(output.rect, 0xFFFF00FF);
			
			fixDirtyNeighbors();
				
			for (var priority:int = 0; priority < Map.PRIORITIES; ++priority)
				renderPriority(output, view, priority);
		}
		
		private function renderPriority(output:BitmapData, view:View, priority:int):void {
			var xStart:int = -(view.x % Tile.SIZE);
			var yStart:int = -(view.y % Tile.SIZE);
			var iTileStart:int = view.x / Tile.SIZE;
			var jTileStart:int = view.y / Tile.SIZE;
			
			for (var layer:int = 0; layer < LAYERS; ++layer) {
				var i:int = iTileStart;
				for (var x:int = xStart; x < view.width && i < _width; x += Tile.SIZE) {
					var j:int = jTileStart;
					for (var y:int = yStart; y < view.height && j < _height; y += Tile.SIZE) {
						var tile:Tile = _tiles[i][j][layer]; 
						if (tile && tile.priority == priority) {
							tile.blit(
								output, 
								_neighbors[i][j][layer],
								_frame,
								layer,
								x, y,
								view
							);
						}
						++j;
					}
					++i;
				}
			} 
		 
			// Render entities
			for each (var entity:Entity in _entities) {
				entity.renderPart(output, view, priority);
			}
		}

		private function getNeighborProfile(i:int, j:int, layer:int):int {
			var nearby:Vector.<Tile> = getNearbyTiles(this, i, j, layer);

			var borders:uint = TileBorder.NONE;
			var tile:Tile = _tiles[i][j][layer];
			
			if (nearby[3] == tile)
				borders |= TileBorder.LEFT;

			if (nearby[5] == tile)
				borders |= TileBorder.RIGHT;

			if (nearby[1] == tile)
				borders |= TileBorder.UP;

			if (nearby[7] == tile)
				borders |= TileBorder.DOWN;

			var n:int;
			switch (borders) {
				// No border case -- default tile
				// No inside corner checks
				case TileBorder.NONE:
					return 0;

				// Dead end cases -- corner tile + extra corner tile
				// No inside corner checks.
				case TileBorder.LEFT:
					return 1;

				case TileBorder.RIGHT:
					return 2;

				case TileBorder.UP:
					return 3;

				case TileBorder.DOWN:
					return 4;

				// Elbow cases -- corner tile
				// Gotta check for the inside corner!
				case TileBorder.LEFT | TileBorder.UP:
					if (checkNWCorner(tile, nearby))
						return 6;
					return 5;

				case TileBorder.UP | TileBorder.RIGHT:
					if (checkNECorner(tile, nearby))
						return 8;
					return 7;

				case TileBorder.RIGHT | TileBorder.DOWN:
					if (checkSECorner(tile, nearby))
						return 10;
					return 9;

				case TileBorder.DOWN | TileBorder.LEFT:
					if (checkSWCorner(tile, nearby))
						return 12;
					return 11;

				// Row/column cases -- side + opposite side
				// No inside corner checks.
				case TileBorder.UP | TileBorder.DOWN:
					return 13;

				case TileBorder.LEFT | TileBorder.RIGHT:
					return 14;

				// T cases -- side tile
				// Gotta check for both inside corners!
				case TileBorder.LEFT | TileBorder.UP | TileBorder.RIGHT:
					n = 15;
					if (checkNWCorner(tile, nearby))
						n += 1;
					if (checkNECorner(tile, nearby))
						n += 2;
					return n;

				case TileBorder.UP | TileBorder.RIGHT | TileBorder.DOWN:
					n = 19;
					if (checkNECorner(tile, nearby))
						n += 1;
					if (checkSECorner(tile, nearby))
						n += 2;
					return n;

				case TileBorder.RIGHT | TileBorder.DOWN | TileBorder.LEFT:
					n = 23;
					if (checkSWCorner(tile, nearby))
						n += 1;
					if (checkSECorner(tile, nearby))
						n += 2;
					return n;

				case TileBorder.DOWN | TileBorder.LEFT | TileBorder.UP:
					n = 27;
					if (checkNWCorner(tile, nearby))
						n += 1;
					if (checkSWCorner(tile, nearby))
						n += 2;
					return n;

				// Middle case -- middle tile
				// Gotta check for every inside corner!
				case TileBorder.LEFT | TileBorder.UP | TileBorder.RIGHT | TileBorder.DOWN:
					n = 31;
					if (checkNWCorner(tile, nearby))
						n += 1;
					if (checkNECorner(tile, nearby))
						n += 2;
					if (checkSWCorner(tile, nearby))
						n += 4;
					if (checkSECorner(tile, nearby))
						n += 8;
					return n;
			}
			return 0;
		}

		public static function getNearbyTiles(m:Map, i:int, j:int, layer:int):Vector.<Tile> {
			var nearby:Vector.<Tile> = new Vector.<Tile>(9);
			var count:int = 0;
			for (var y:int = j - 1; y <= j + 1; ++y) {
				for (var x:int = i - 1; x <= i + 1; ++x) {
					if (x >= 0 && y >= 0 && x < m._width && y < m.height)
						nearby[count] = m._tiles[x][y][layer];
					else
						nearby[count] = m._tiles[i][j][layer];
					++count;
				}
			}
			return nearby;
		}

		public static function checkNWCorner(tile:Tile, nearby:Vector.<Tile>):Boolean {
			return nearby[0] != tile;	
		}
		
		public static function checkNECorner(tile:Tile, nearby:Vector.<Tile>):Boolean {
			return nearby[2] != tile;	
		}
		
		public static function checkSWCorner(tile:Tile, nearby:Vector.<Tile>):Boolean {
			return nearby[6] != tile;	
		}

		public static function checkSECorner(tile:Tile, nearby:Vector.<Tile>):Boolean {
			return nearby[8] != tile;		
		}
	}
}

final class FactoryEnforcer {}
