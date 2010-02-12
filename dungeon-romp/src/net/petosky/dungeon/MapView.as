package net.petosky.dungeon {
	import flash.geom.Point;	
	
	import net.petosky.dungeon.maze.Maze;	
	import net.petosky.metaplay.Renderable;	
	import net.petosky.dungeon.party.Party;
	import net.petosky.dungeon.maze.CellType;
	import net.petosky.dungeon.Directions;
	import net.petosky.dungeon.maze.Cell;
	import net.petosky.dungeon.maze.Floor;
	import flash.geom.Rectangle;	
	import flash.display.BitmapData;	
	
	/**
	 * @author Cory Petosky
	 */
	public class MapView extends Renderable { 
		private var _map:BitmapData;
		
		private var _cellSize:uint;
		private var _wallSize:uint;

		private var _maze:Maze;
		private var _party:Party;

		public function MapView(width:int, height:int, maze:Maze, party:Party, cellSize:uint = 16, wallSize:uint = 3) {
			super(width, height);
			_cellSize = cellSize;
			_wallSize = wallSize;
			
			_maze = maze;
			_party = party;
			
			_map = new BitmapData(width, height, false, 0xFF700000);
		}
		
		override public function update(delta:uint):void {
			var floor:Floor = _party.currentFloor;

			_map.fillRect(new Rectangle(0, 0, width, height), 0xFFFFFFFF);
			if (!floor)
				return;
				
			var rect:Rectangle = new Rectangle();
			
			for (var i:uint = 0; i < floor.width; i++) {
				for (var j:uint = 0; j < floor.height; j++) {
					var cell:Cell= floor.getCell(i, j);
					if (!cell.visited || cell.walls == 0) {
						rect.x = i * _cellSize;
						rect.y = j * _cellSize;
						rect.width = _cellSize;
						rect.height = _cellSize;
						_map.fillRect(rect, 0xFF666666);
					} else {
						if ((cell.walls & Directions.NORTH) == 0) {
							rect.x = i * _cellSize;
							rect.y = j * _cellSize;
							rect.width = _cellSize;
							rect.height = _wallSize;
							_map.fillRect(rect, 0xFF000000);
						}
						if ((cell.walls & Directions.WEST) == 0) {
							rect.x = i * _cellSize;
							rect.y = j * _cellSize;
							rect.width = _wallSize;
							rect.height = _cellSize;
							_map.fillRect(rect, 0xFF000000);
						}
						if ((cell.walls & Directions.EAST) == 0) {
							rect.x = (i + 1) * _cellSize - _wallSize;
							rect.y = j * _cellSize;
							rect.width = _wallSize;
							rect.height = _cellSize;
							_map.fillRect(rect, 0xFF000000);
						}
						if ((cell.walls & Directions.SOUTH) == 0) {
							rect.x = i * _cellSize;
							rect.y = (j + 1) * _cellSize - _wallSize;
							rect.width = _cellSize;
							rect.height = _wallSize;
							_map.fillRect(rect, 0xFF000000);
						}
						if (cell.object && cell.object.type == CellType.STAIRS_DOWN) {
							rect.x = i * _cellSize + (_cellSize >> 2);
							rect.y = j * _cellSize + (_cellSize >> 2);
							rect.width = (_cellSize >> 1);
							rect.height = (_cellSize >> 1);
							_map.fillRect(rect, 0xFF00AA55);
						}
					}
				}
			}
			
			// draw position on minimap
			rect.x = _party.cellX * _cellSize + (_cellSize >> 2);
			rect.y = _party.cellY * _cellSize + (_cellSize >> 2);
			rect.width = (_cellSize >> 1);
			rect.height = (_cellSize >> 1);
			_map.fillRect(rect, 0xFF0000FF);
			
			// draw head
			rect.width >>= 1;
			rect.height >>= 1;
			
			if (_party.facing == Directions.NORTH) {
				rect.x += (_cellSize >> 3);
			} else if (_party.facing == Directions.EAST) {
				rect.x += (_cellSize >> 2);
				rect.y += (_cellSize >> 3);
			} else if (_party.facing == Directions.SOUTH) {
				rect.x += (_cellSize >> 3);
				rect.y += (_cellSize >> 2);
			} else {
				rect.y += (_cellSize >> 3);
			}
			
			_map.fillRect(rect, 0xFFFFFFFF);
		}
		
		override public function draw(target:BitmapData, destPoint:Point):void {
			target.copyPixels(_map, _map.rect, destPoint);
		}
	}
}
