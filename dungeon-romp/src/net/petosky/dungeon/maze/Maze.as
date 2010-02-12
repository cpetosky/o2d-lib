package net.petosky.dungeon.maze {
	import net.petosky.dungeon.Directions;	
	import net.petosky.util.NumberUtils;	
	import net.petosky.util.ByteArrayUtils;	
	
	import flash.utils.ByteArray;	
	
	import net.petosky.dungeon.maze.Floor;

	import flash.events.EventDispatcher;
	import net.petosky.geom.GridPoint;	
	
	/**
	 * @author Cory Petosky
	 */
	public class Maze extends EventDispatcher {
		private static const ROOM_SCORE:uint = 10000;
		private static const HALL_SCORE:uint = 3;
		private static const DOOR_SCORE:uint = 1;
		
		private var _floors:Array = new Array();
		
		private static const FILE_VERSION:uint = 7;
		private static const SAVE_VERSION:uint = 7;
		
		public function serialize():ByteArray {
			var bytes:ByteArray = new ByteArray();
			
			bytes.writeUnsignedInt(SAVE_VERSION);
			
			bytes.writeInt(_floors.length);
			
			for each (var floor:Floor in _floors) {
				ByteArrayUtils.writeByteArray(floor.serialize(), bytes);
			}
			
			return bytes;
		}

		public static function deserialize(bytes:ByteArray):Maze {
			if (bytes.readUnsignedInt() != FILE_VERSION)
				return null;
				
			var maze:Maze = new Maze();
			
			var floors:int = bytes.readInt();
			
			for (var i:uint = 0; i < floors; ++i) {
				var floor:Floor = Floor.deserialize(ByteArrayUtils.readByteArray(bytes));
				maze._floors[floor.id] = floor;
			}
				
			return maze;
		}
		
		public function getFloor(id:uint):Floor {
			return _floors[id];
		}

		
//		
//		public function nextFloor():void {
//			++_currentFloorIndex;
//			if (_currentFloorIndex == _floors.length)
//				generateRandomFloor({width: 20, height: 20, trim: false});
//		}
//		
//		public function previousFloor():void {
//			if (_currentFloorIndex > 0) {
//				--_currentFloorIndex;
//			}
//		}

		public function generateBlankFloor():void {
			var cells:Vector.<Vector.<Cell>> = new Vector.<Vector.<Cell>>();
			var height:uint = 20, width:uint = 20;
			
			for (var i:uint = 0; i < width; ++i) {
				var column:Vector.<Cell> = new Vector.<Cell>;
				for (var j:uint = 0; j < height; ++j)
					column.push(new Cell());
				cells.push(column);
			}
			
			var floor:Floor = new Floor(_floors.length, new GridPoint(), cells);
			floor._groundColor = 0xFF00FF00;
			floor._skyColor = 0xFF6666FF; 
			
			_floors.push(floor);
		}

		public function generateRandomFloor(options:Object = null):void {
			options ||= {};
				
			var width:uint = options.width ? options.width : NumberUtils.normalRandomInt(10, 30);
			var height:uint = options.height ? options.height : NumberUtils.normalRandomInt(5, 25);
			
			var area:uint = (width + height);
			var halfArea:uint = area >> 1;
			
			var randomness:uint = options.randomness ? options.randomness : NumberUtils.normalRandomInt(0, 100);
			var sparseness:uint = options.sparseness ? options.sparseness : NumberUtils.normalRandomInt(0, halfArea);
			var deadendsRemoved:uint = options.deadendsRemoved ? options.deadendsRemoved : NumberUtils.normalRandomInt(50, 100);
			
			var minRoomWidth:uint = options.minRoomWidth ? options.minRoomWidth : 2;
			var maxRoomWidth:uint = options.maxRoomWidth ? options.maxRoomWidth : NumberUtils.normalRandomInt(3, 7);
			var minRoomHeight:uint = options.minRoomHeight ? options.minRoomHeight : 2;
			var maxRoomHeight:uint = options.maxRoomHeight ? options.maxRoomHeight : NumberUtils.normalRandomInt(3, 7);
			
			var averageRoomArea:uint = (minRoomWidth + maxRoomWidth + minRoomHeight + maxRoomHeight) >> 1;
			var maxRooms:Number = halfArea * 8.0 / averageRoomArea;
			var minRooms:Number = maxRooms / 2;
			
			var roomCount:uint = options.roomCount ? options.roomCount : NumberUtils.normalRandomInt(minRooms, maxRooms);
			
			var doTrim:Boolean = options.trim != undefined ? options.trim : true;

			var i:uint;
			var j:uint;
			
			var cells:Vector.<Vector.<Cell>> = new Vector.<Vector.<Cell>>();
			
			for (i = 0; i < width; ++i) {
				var column:Vector.<Cell> = new Vector.<Cell>;
				for (j = 0; j < height; ++j)
					column.push(new Cell());
				cells.push(column);
			}
			
			var currentCell:GridPoint = new GridPoint(
				NumberUtils.randomUint(width),
				NumberUtils.randomUint(height)
			);
			
			var lastPassage:LastPassage = new LastPassage();
			
			var remaining:uint = width * height - 1;
			
			while (remaining > 0) {
				while (!drawPassage(cells, currentCell, randomness, lastPassage, true)) {
					do {
						currentCell.x = NumberUtils.randomUint(width);
						currentCell.y = NumberUtils.randomUint(height);
					} while(cells[currentCell.x][currentCell.y].walls == Directions.NONE);
				}
				--remaining;
			}
			
			sparsify(cells, sparseness);
			removeDeadends(cells, deadendsRemoved, randomness);
			if (doTrim)
				trim(cells);
			addRooms(cells, minRoomWidth, maxRoomWidth, minRoomHeight, maxRoomHeight, roomCount);
			
			// Reset width and height, as trim may have changed them
			width = cells.length;
			height = cells[0].length;
			
			// Choose valid starting cell
			var start:GridPoint = new GridPoint();
			
			do {
				start.x = NumberUtils.randomUint(width);
				start.y = NumberUtils.randomUint(height);
			} while (cells[start.x][start.y].walls == Directions.NONE);
			
			var stairs:GridPoint = new GridPoint();
			
			do {
				stairs.x = NumberUtils.randomUint(width);
				stairs.y = NumberUtils.randomUint(height);
			} while (
				cells[stairs.x][stairs.y].walls == Directions.NONE ||
				(stairs.x == start.x && stairs.y == start.y)
			);
			
			
			var floor:Floor = new Floor(_floors.length, start, cells);
			floor._groundColor = 0xFF222222;
			floor._skyColor = 0xFF000000; 
			
			floor.getCell(stairs.x, stairs.y).object = new StairsDownObject(floor.id + 1);
			
			
			_floors.push(floor);
		}
		
		/**
		 * Attempts to add a single new passage to a cells array using a
		 * Hunt-and-Kill algorithm.
		 * 
		 * @param cells The cells array to modify.
		 * @param currentCell The cell to work from.
		 * @param randomness Percentage (0-100) chance to change direction
		 *    last successful passage.
		 * @param lastPassage Struct containing the last direction moved and
		 *    the number of times the passage has gone in a single direction.
		 * @param noLoops If true, will never draw a passage that connects to
		 *    an already-visted cell.
		 */
		private static function drawPassage(
			cells:Vector.<Vector.<Cell>>,
			currentCell:GridPoint,
			randomness:uint,
			lastPassage:LastPassage,
			noLoops:Boolean
		):Boolean {
			var directions:uint = cells[currentCell.x][currentCell.y].walls;
			if (directions == Directions.ALL)
				return false;
				
			var direction:uint;
			
			if (currentCell.x < 1) directions |= Directions.WEST;
			if (currentCell.x + 1 >= cells.length) directions |= Directions.EAST;
			if (currentCell.y < 1) directions |= Directions.NORTH;
			if (currentCell.y + 1 >= cells[0].length) directions |= Directions.SOUTH;

			if (NumberUtils.randomUint(100) < randomness ||
				!canGoStraight(cells, currentCell, lastPassage, noLoops)
			) {
				lastPassage.straightStretch = 0;
				direction = selectRandomDirection(cells, currentCell, directions, noLoops);
			} else {
				++lastPassage.straightStretch;
				direction = lastPassage.lastDirection;
			}

			if (direction == Directions.NONE)
				return false;
		
			lastPassage.lastDirection = direction;
			cells[currentCell.x][currentCell.y].walls |= direction;
			
			switch (direction) {
				case Directions.NORTH: --currentCell.y; direction = Directions.SOUTH; break;
				case Directions.SOUTH: ++currentCell.y; direction = Directions.NORTH; break;
				case Directions.WEST: --currentCell.x; direction = Directions.EAST; break;
				case Directions.EAST: ++currentCell.x; direction = Directions.WEST; break;
			}
			
			cells[currentCell.x][currentCell.y].walls |= direction;
			return true;
		}
		
		
		
		/**
		 * Returns true if the next cell in the current direction is unvisited.
		 */
		private static function canGoStraight(
			cells:Vector.<Vector.<Cell>>,
			currentCell:GridPoint,
			lastPassage:LastPassage,
			noLoops:Boolean
		):Boolean {
			var x:uint = currentCell.x;
			var y:uint = currentCell.y;
			
			switch (lastPassage.lastDirection) {
				case Directions.NORTH:
					return (
						(lastPassage.straightStretch < (y >> 1)) && 
						(y > 0) && 
						!(noLoops && cells[x][y - 1].walls != Directions.NONE)
					);
				break;
				case Directions.SOUTH:
					return (
						(lastPassage.straightStretch < (y >> 1)) &&
						(y + 1 < cells[0].length) &&
						!(noLoops && cells[x][y + 1].walls != Directions.NONE)
					);
				break;
				case Directions.WEST:
					return (
						(lastPassage.straightStretch < (x >> 1)) &&
						(x > 0) &&
						!(noLoops && cells[x - 1][y].walls != Directions.NONE)
					);
				break;
				case Directions.EAST:
					return (
						(lastPassage.straightStretch < (x >> 1)) &&
						(x + 1 < cells.length) && 
						!(noLoops && cells[x + 1][y].walls != Directions.NONE)
					);
				break;
				default:
					return false;
			}
		} 
		
		private static function selectRandomDirection(
			cells:Vector.<Vector.<Cell>>,
			currentCell:GridPoint,
			directions:uint,
			avoidRooms:Boolean = false
		):uint {
			var direction:uint = Directions.NONE;
			var x:uint = currentCell.x;
			var y:uint = currentCell.y;
			
			while ((direction == Directions.NONE) || ((directions & direction) != 0)) {
				var tx:uint = x;
				var ty:uint = y;
				
				switch(NumberUtils.randomUint(4)) {
					case 0: 
						if (y > 0) {
							direction = Directions.NORTH;
							--ty;
						} else {
							directions |= Directions.NORTH;
						}
					break;
					case 1:
						if (y + 1 < cells[0].length) {
							direction = Directions.SOUTH;
							++ty;
						} else {
							directions |= Directions.SOUTH;
						}
					break;
					case 2:
						if (x > 0) {
							direction = Directions.WEST;
							--tx;
						} else {
							directions |= Directions.WEST;
						}
					break;
					case 3:
						if (x + 1 < cells.length) {
							direction = Directions.EAST;
							++tx;
						} else {
							directions |= Directions.EAST;
						}
					break;
				}
				
				if (avoidRooms && cells[tx][ty].walls != Directions.NONE) {
					directions |= direction;
					if (directions == Directions.ALL)
						return Directions.NONE;
					
					direction = Directions.NONE;
				}
			}
			
			return direction;
		}

		private static function sparsify(cells:Vector.<Vector.<Cell>>, sparseness:uint):void {
			for (; sparseness > 0; --sparseness) {
				for (var i:uint = 0; i < cells.length; ++i) {
					for (var j:uint = 0; j < cells[i].length; ++j) {
						switch (cells[i][j].walls) {
							case Directions.NORTH:
								cells[i][j].walls = Directions.NONE;
								cells[i][j - 1].walls ^= Directions.SOUTH;
							break;
							case Directions.EAST:
								cells[i][j].walls = Directions.NONE;
								cells[i + 1][j].walls ^= Directions.WEST;
							break;
							case Directions.SOUTH:
								cells[i][j].walls = Directions.NONE;
								cells[i][j + 1].walls ^= Directions.NORTH;
							break;
							case Directions.WEST:
								cells[i][j].walls = Directions.NONE;
								cells[i - 1][j].walls ^= Directions.EAST;
							break;
						}
					} // for j
				} // for i
			} // for sparseness
		} // function
		
		private static function removeDeadends(cells:Vector.<Vector.<Cell>>, deadendsRemoved:uint, randomness:uint):void {
			for (var i:uint = 0; i < cells.length; ++i) {
				for (var j:uint = 0; j < cells[i].length; ++j) {
					var cell:Cell = cells[i][j];
					if (
						Directions.isSingular(cell.walls) &&
						NumberUtils.randomUint(100) < deadendsRemoved
					) {
						var currentCell:GridPoint = new GridPoint(i, j);
						var lastPassage:LastPassage = new LastPassage();
						while (Directions.isSingular(cells[currentCell.x][currentCell.y].walls)) {
							while (!drawPassage(cells, currentCell, randomness, lastPassage, false)) {
								do {
									currentCell.x = NumberUtils.randomUint(cells.length);
									currentCell.y = NumberUtils.randomUint(cells[i].length);
								} while(cells[currentCell.x][currentCell.y].walls == Directions.NONE);
							}
						}						
					}
				}
			}
		}
		
		private static function trim(cells:Vector.<Vector.<Cell>>):void {
			var b:Boolean = true;
			var lastIndex:uint;
			var i:uint;
			
			// Remove first row
			while (b) {			
				for (i = 0; i < cells.length; ++i) {
					if (cells[i][0].walls != Directions.NONE) {
						b = false;
						break;
					}
				}
				
				if (b)
					for (i = 0; i < cells.length; ++i)
						cells[i].shift();
			}
			
			b = true;
			
			// Remove last row
			while (b) {
				lastIndex = cells[0].length - 1;	
				for (i = 0; i < cells.length; ++i) {
					if (cells[i][lastIndex].walls != Directions.NONE) {
						b = false;
						break;
					}
				}
				
				if (b)
					for (i = 0; i < cells.length; ++i)
						cells[i].pop();
			}
			
			b = true;
			
			// Remove first column
			while (b) {			
				for (i = 0; i < cells[0].length; ++i) {
					if (cells[0][i].walls != Directions.NONE) {
						b = false;
						break;
					}
				}
				
				if (b)
					cells.shift();
			}
			
			b = true;
			
			// Remove last column
			while (b) {
				lastIndex = cells.length - 1;	
				for (i = 0; i < cells[0].length; ++i) {
					if (cells[lastIndex][i].walls != Directions.NONE) {
						b = false;
						break;
					}
				}
				
				if (b)
					cells.pop();
			}
		}
		
		private static function addRooms(
			cells:Vector.<Vector.<Cell>>,
			minRoomWidth:uint,
			maxRoomWidth:uint,
			minRoomHeight:uint,
			maxRoomHeight:uint,
			roomCount:uint
		):void {
			for (var r:uint = 0; r < roomCount; ++r) {
				var roomWidth:uint = NumberUtils.randomUint(minRoomWidth, maxRoomWidth, true);
				var roomHeight:uint = NumberUtils.randomUint(minRoomHeight, maxRoomHeight, true);
				
				var bestScore:uint = uint.MAX_VALUE;
				var bestX:uint = 0;
				var bestY:uint = 0;
				
				for (var i:uint = 0; i <= cells.length - roomWidth; ++i) {
					for (var j:uint = 0; j <= cells[i].length - roomHeight; ++j) {
						var score:uint = 0;
						
						for (var x:uint = 0; x < roomWidth; ++x) {
							for (var y:uint = 0; y < roomHeight; ++y) {
								var cellX:uint = i + x;
								var cellY:uint = j + y;
								var cell:Cell = cells[cellX][cellY];
								
								if (cell.room)
									score += ROOM_SCORE;
								else if (!cell.empty)
									score += HALL_SCORE;
								else if (
									((cellX - 1) >= 0 && !cells[cellX - 1][cellY].empty) ||
									(((cellX + 1) < cells.length) && !cells[cellX + 1][cellY].empty) ||
									((cellY - 1) >= 0 && !cells[cellX][cellY - 1].empty) ||
									(((cellY + 1) < cells[i].length) && !cells[cellX][cellY + 1].empty)
								)
									score += DOOR_SCORE;
							}
						} // End loop through all room cells
						
						if (score > 0 && score < bestScore) {
							bestX = i;
							bestY = j;
							bestScore = score;
						}
					}
				} // End loop through all room positions
				
				for (var rX:uint = bestX; rX < bestX + roomWidth; ++rX) {
					for (var rY:uint = bestY; rY < bestY + roomHeight; ++rY) {
						var roomCell:Cell = cells[rX][rY];
						roomCell.room = true;
						if ((rX - 1) >= 0 && !cells[rX - 1][rY].empty) {
							cells[rX - 1][rY].walls |= Directions.EAST;
							roomCell.walls |= Directions.WEST;
						}
							
						if (((rX + 1) < cells.length) && !cells[rX + 1][rY].empty) {
							cells[rX + 1][rY].walls |= Directions.WEST;
							roomCell.walls |= Directions.EAST;
						}
						
						if (((rY - 1) >= 0 && !cells[rX][rY - 1].empty)) {
							cells[rX][rY - 1].walls |= Directions.SOUTH;
							roomCell.walls |= Directions.NORTH;
						}
						
						if (((rY + 1) < cells[i].length) && !cells[rX][rY + 1].empty) {
							cells[rX][rY + 1].walls |= Directions.NORTH;
							roomCell.walls |= Directions.SOUTH;
						}				
					}
				} // End room-setting loop
			} // End room generation loop
		}

	}
}

class LastPassage {
	public var lastDirection:uint;
	public var straightStretch:uint;
}