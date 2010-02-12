package net.petosky.dungeon.party {
	import net.petosky.dungeon.maze.Maze;	
	
	import flash.utils.ByteArray;	
	import flash.events.EventDispatcher;	
	import flash.events.Event;	
	
	import net.petosky.dungeon.maze.Cell;	
	import net.petosky.dungeon.maze.Floor;	
	import net.petosky.dungeon.party.Roster;
	import net.petosky.dungeon.party.Character;
	import net.petosky.dungeon.Directions;
	import net.petosky.util.NumberUtils;	
	
	/**
	 * @author Cory Petosky
	 */
	public class Party extends EventDispatcher {
		public static const CHARACTER_ADDED:String = "characterAdded";		
		public static const DOOMED:String = "doomed";

		private var _characters:Vector.<Character> = new Vector.<Character>();
		
		private var _facing:uint = Directions.NORTH;
		private var _x:int;
		private var _z:int;
		
		private var _floor:Floor;
		
		private var _speed:int = 10;
		
		public function Party(floor:Floor) {
			_floor = floor;
		}
		
		public function get currentFloor():Floor {
			return _floor;
		}
		public function set currentFloor(floor:Floor):void {
			_floor = floor;
		}
		
		public function get currentCell():Cell {
			return _floor.getCell(cellX, cellY);
		}

		
		
		public function serialize():ByteArray {
			var bytes:ByteArray = new ByteArray();
			bytes.writeInt(_floor.id);
			
			bytes.writeUnsignedInt(_facing);
			bytes.writeInt(_x);
			bytes.writeInt(_z);
			bytes.writeInt(_speed);
			
			bytes.writeUnsignedInt(_characters.length);
			
			for each (var character:Character in _characters)
				bytes.writeUnsignedInt(character.id);
			
			return bytes;
		}

		public static function deserialize(bytes:ByteArray, roster:Roster, maze:Maze):Party {
			var party:Party = new Party(maze.getFloor(bytes.readUnsignedInt()));
			
			party._facing = bytes.readUnsignedInt();
			party._x = bytes.readInt();
			party._z = bytes.readInt();
			party._speed = bytes.readInt();
			
			var numChars:uint = bytes.readUnsignedInt();
			
			for (var i:uint = 0; i < numChars; ++i) {
				party._characters[i] = roster.getCharacter(bytes.readUnsignedInt());
			}
			
			return party;
		}

		
		
		public function get maxSize():int {
			return 6;
		}
		
		public function get size():int {
			return _characters.length;
		}

		public function removeCharacterByIndex(index:int):void {
			_characters.splice(index, 1);
		}
		
		public function getCharacter(index:int):Character {
			return _characters[index];
		}
		
		
		public function splitXP(totalXP:int):int {
			var share:int = totalXP / size;
			
			// Chance to round up, make things even out in end
			if (NumberUtils.randomUint(size) < int(totalXP % size))
				++share;
				
			for each (var character:Character in _characters)
				character.xp += share;
			
			return share;
		}
		
		public function getAbsoluteDirection(relativeDirection:uint):uint {
			return Directions.getActualDirection(_facing, relativeDirection);
		}

		
		
		public function addCharacter(character:Character):void {
			_characters.push(character);
			dispatchEvent(new Event(CHARACTER_ADDED));
		}


		public function rotateRight():void {
			_facing = getAbsoluteDirection(Directions.EAST);			
		}
		
		public function rotateLeft():void {
			_facing = getAbsoluteDirection(Directions.WEST);
		}
		
		public function walkForward():Boolean {
			return moveDirection(_facing);
		}
		
		public function strafeLeft():Boolean {
			return moveDirection(getAbsoluteDirection(Directions.WEST));
		}
		
		public function strafeRight():Boolean {
			return moveDirection(getAbsoluteDirection(Directions.EAST));
		}
		
		public function walkBackward():Boolean {
			return moveDirection(getAbsoluteDirection(Directions.SOUTH));
		}
		
		public function moveDirection(dir:uint):Boolean {
			var character:Character;
			var oldX:int = _x;
			var oldZ:int = _z;
			var oldCellX:int = cellX;
			var oldCellY:int = cellY;
			
			var oldCell:Cell = _floor.getCell(oldCellX, oldCellY);
			var canCross:Boolean = (oldCell.walls & dir) != 0;
			
			var newCell:Boolean = false;
			
			if (dir == Directions.NORTH) {
				_z -= _speed;
				
				if (oldCellY != cellY) {
					if (canCross) {
						newCell = true;
						for each (character in _characters) {
							character.y = _z / 200;
						}
					} else {
						_z = oldZ - int(oldZ % 200) + 1;
					}
				}
				
			} else if (dir == Directions.EAST) {
				_x += _speed;
				
				if (oldCellX != cellX) {
					if (canCross) {
						newCell = true;
						for each (character in _characters) {
							character.x = _x / 200;
						}
					} else {
						_x = _x - int(_x % 200) - 1;
					}
				}
				
			} else if (dir == Directions.SOUTH) {
				_z += _speed;
				
				if (oldCellY != cellY) {
					if (canCross) {
						newCell = true;
						for each (character in _characters) {
							character.y = _z / 200;
						}
					} else {
						_z = _z - int(_z % 200) - 1;
					}
				}
			} else if (dir == Directions.WEST) {
				_x -= _speed;

				if (oldCellX != cellX) {
					if (canCross) {
						newCell = true;
						for each (character in _characters) {
							character.x = _x / 200;
						}
					} else {
						_x = oldX - int(oldX % 200) + 1;
					}
				}
			}
			
			return newCell;
		}

		public function warp(x:int, y:int):void {
			_x = x * 200 + 100;
			_z = y * 200 + 100;
			for each (var character:Character in _characters) {
				character.x = x;
				character.y = y;
			}
		}
		
		public function get cellX():int {
			return _x / 200 - (_x < 0 ? 1 : 0);
		}
		
		public function get cellY():int {
			return _z / 200 - (_z < 0 ? 1 : 0);
		}
		
		
		
		public function get facing():uint {
			return _facing;
		}
		public function set facing(value:uint):void {
			_facing = value;
		}
		
		
		
		public function get x():int {
			return _x;
		}
		
		
		
		public function get z():int {
			return _z;
		}
		
		
		public function get cameraX():int {
			switch(_facing) {
				case Directions.NORTH:
					return (_x % 200) - 100;
				case Directions.SOUTH:
					return -((_x % 200) - 100);
				case Directions.EAST:
					return (_z % 200) - 100;
				case Directions.WEST:
					return -((_z % 200) - 100);
			}
			
			return 0;
		}
		
		public function get cameraZ():int {
			switch (_facing) {
				case Directions.NORTH:
					return _z % 200;
				case Directions.SOUTH:
					return  200 - (_z % 200);
				case Directions.EAST:
					return 200 - (_x % 200);
				case Directions.WEST:
					return _x % 200;
			}
			return 0;
		}
	}
}
