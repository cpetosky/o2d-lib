package net.petosky.dungeon.maze {
	import net.petosky.util.ByteArrayUtils;	
	
	import flash.utils.ByteArray;	
	
	import net.petosky.dungeon.maze.Cell;
	import net.petosky.dungeon.maze.CellType;
	import flash.display.BitmapData;	
	
	import net.petosky.geom.GridPoint;	
	import net.petosky.util.NumberUtils;
	import net.petosky.dungeon.Directions;

	/**
	 * @author Cory
	 */
	public class Floor {
		private var _id:uint;
		
		private var _cells:Vector.<Vector.<Cell>>;
		private var _start:GridPoint;
		
		private var _wallSeed:uint;
		private var _wallChannels:uint;
		private var _wallTexture:BitmapData;
		
		internal var _skyColor:uint;
		internal var _groundColor:uint;
		
		private var _encounterRate:Number = 0.07;

		public function Floor(id:uint, start:GridPoint, cells:Vector.<Vector.<Cell>>) {
			_id = id;
			_cells = cells;
			_start = start;
			
			_wallSeed = Math.random() * 1000000;
			_wallChannels = 1 + Math.random() * 7;
			regenerateTextures();
		}
		
		public function regenerateTextures():void {
			_wallTexture = new BitmapData(200, 200);
			_wallTexture.perlinNoise(200, 200, 16, _wallSeed, true, true, _wallChannels);			
		}
		
		public function serialize():ByteArray {
			var bytes:ByteArray = new ByteArray();
			
			bytes.writeUnsignedInt(_id);
			bytes.writeInt(width);
			bytes.writeInt(height);
			
			bytes.writeUnsignedInt(_wallSeed);
			bytes.writeUnsignedInt(_wallChannels);
			bytes.writeUnsignedInt(_skyColor);
			bytes.writeUnsignedInt(_groundColor);
			bytes.writeDouble(_encounterRate);
			
			bytes.writeInt(_start.x);
			bytes.writeInt(_start.y);
			
			for (var i:uint = 0; i < width; ++i) {
				for (var j:uint = 0; j < height; ++j) {
					ByteArrayUtils.writeByteArray(getCell(i, j).serialize(), bytes);
				}
			}
			
			return bytes;
		}
		
		public static function deserialize(bytes:ByteArray):Floor {
			var id:uint = bytes.readUnsignedInt();
			var width:int = bytes.readInt();
			var height:int = bytes.readInt();
			
			var wallSeed:uint = bytes.readUnsignedInt();
			var wallChannels:uint = bytes.readUnsignedInt();
			var skyColor:uint = bytes.readUnsignedInt();
			var groundColor:uint = bytes.readUnsignedInt();
			var encounterRate:Number = bytes.readDouble();
			
			var start:GridPoint = new GridPoint(bytes.readInt(), bytes.readInt());
			
			var cells:Vector.<Vector.<Cell>> = new Vector.<Vector.<Cell>>();
			
			for (var i:uint = 0; i < width; ++i) {
				var column:Vector.<Cell> = new Vector.<Cell>();
				for (var j:uint = 0; j < height; ++j) {
					column.push(Cell.deserialize(ByteArrayUtils.readByteArray(bytes), id));
				}
				cells.push(column);
			}
			
			var floor:Floor = new Floor(id, start, cells);
			floor._wallSeed = wallSeed;
			floor._wallChannels = wallChannels;
			floor._skyColor = skyColor;
			floor._groundColor = groundColor;
			floor._encounterRate = encounterRate;
			floor.regenerateTextures();
			
			return floor;
		}
		
		public function toggleWall(cellX:int, cellY:int, direction:uint):void {
			var cell:Cell = getCell(cellX, cellY);
			var nextCell:Cell = new CellPointer(this, cellX, cellY).moveDirection(direction).cell;
			
			if (cell && nextCell) {
				cell.walls ^= direction;
				nextCell.walls ^= Directions.opposite(direction);
			}
		}

		
		
		public function get cells():Vector.<Vector.<Cell>> {
			return _cells;
		}
		
		public function get startingCell():Cell {
			return _cells[_start.x][_start.y];
		}
		
		public function getCell(i:int, j:int):Cell {
			if (i > -1 && j > -1 && i < width && j < height)
				return _cells[i][j];
			return null;
		}
		
		public function findCellLocation(type:String):GridPoint {
			for (var i:uint = 0; i < width; ++i)
				for (var j:uint = 0; j < height; ++j)
					if (_cells[i][j].object && _cells[i][j].object.type == type)
						return new GridPoint(i, j);
						
			return null;
		}
		
		public function get width():uint {
			return _cells[0].length;
		}
		
		public function get height():uint {
			return _cells.length;
		}
		
		
		public function get start():GridPoint {
			return _start;
		}
		
		
		
		public function get wallTexture():BitmapData {
			return _wallTexture;
		}
		
		
		
		public function get encounterRate():Number {
			return _encounterRate;
		}
		public function set encounterRate(value:Number):void {
			_encounterRate = value;
		}
		
		
		
		public function get skyColor():uint {
			return _skyColor;
		}
		public function set skyColor(value:uint):void {
			_skyColor = value;
		}
		
		
		
		public function get groundColor():uint {
			return _groundColor;
		}
		public function set groundColor(value:uint):void {
			_groundColor = value;
		}
		
		
		
		public function get id():uint {
			return _id;
		}
	}
}
