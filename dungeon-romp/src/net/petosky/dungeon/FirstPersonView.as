package net.petosky.dungeon {
	import net.petosky.dungeon.maze.StairsDownObject;	
	import net.petosky.dungeon.display.Polygon;	
	import net.petosky.dungeon.display.Polygon3D;	
	import net.petosky.metaplay.RenderableContainer;	
	import net.petosky.metaplay.KeyCommand;	
	
	import net.petosky.dungeon.maze.Cell;	
	import net.petosky.dungeon.maze.Maze;	
	
	import flash.ui.Keyboard;	
	
	import net.petosky.dungeon.display.Assets;	
	import net.petosky.dungeon.maze.CellType;	
	
	import flash.geom.Matrix;	
	
	import net.petosky.dungeon.maze.CellPointer;	
	import net.petosky.dungeon.display.GridPoint3D;	
	import net.petosky.dungeon.display.Window;
	import net.petosky.dungeon.party.Party;
	import net.petosky.dungeon.Directions;
	import net.petosky.dungeon.maze.Floor;
	import flash.geom.Rectangle;
	
	import net.petosky.geom.GridPoint;
	import net.petosky.dungeon.maze.TavernObject;
	import net.petosky.dungeon.maze.InnObject;	

	/**
	 * @author Cory Petosky
	 */
	public class FirstPersonView extends Window {
		
		private var _party:Party;
		private var _maze:Maze;
		
		private var _lastPartyX:int = -1;
		private var _lastPartyY:int = -1;
		private var _lastPartyFacing:uint;
		
		private var _cheatMode:Boolean = false;
		private var _editMode:Boolean = false;
		
		private var _editCommands:RenderableContainer = new RenderableContainer(0, 0);
		private var _cheatCommands:RenderableContainer = new RenderableContainer(0, 0);
		

		public function FirstPersonView(width:int, height:int, maze:Maze, party:Party) {
			super(width, height, false);
			
			_maze = maze;
			_party = party;

			var keyCommand:KeyCommand;
			
			keyCommand = new KeyCommand(_party.strafeLeft, Keyboard.LEFT, Keyboard.SHIFT);
			keyCommand.commandGroup = "move";
			keyCommand.requireAllKeys = true;
			attach(keyCommand);
			
			keyCommand = new KeyCommand(_party.strafeRight, Keyboard.RIGHT, Keyboard.SHIFT);
			keyCommand.commandGroup = "move";
			keyCommand.requireAllKeys = true;
			attach(keyCommand);

			keyCommand = new KeyCommand(_party.rotateLeft, Keyboard.LEFT);
			keyCommand.commandGroup = "rotateLeft";
			keyCommand.requireUniquePress = true;
			attach(keyCommand);
					
			keyCommand = new KeyCommand(_party.rotateRight, Keyboard.RIGHT);
			keyCommand.commandGroup = "rotateRight";
			keyCommand.requireUniquePress = true;
			attach(keyCommand);

			keyCommand = new KeyCommand(_party.walkForward, Keyboard.UP);
			keyCommand.commandGroup = "move";
			attach(keyCommand);
			
			keyCommand = new KeyCommand(_party.walkBackward, Keyboard.DOWN);
			keyCommand.commandGroup = "move";
			attach(keyCommand);
			
			keyCommand = new KeyCommand(descendStairs, "D");
			keyCommand.commandGroup = "move";
			keyCommand.requireUniquePress = true;
			attach(keyCommand);
						
			// Edit commands
			keyCommand = new KeyCommand(toggleEditMode, Keyboard.SHIFT, Keyboard.F9);
			keyCommand.commandGroup = "edit";
			keyCommand.requireAllKeys = true;
			keyCommand.requireUniquePress = true;
			attach(keyCommand);

			keyCommand = new KeyCommand(function():void {}, Keyboard.SHIFT);
			keyCommand.commandGroup = "edit";
			_editCommands.attach(keyCommand);
			
			keyCommand = new KeyCommand(toggleForwardWall, Keyboard.SHIFT, Keyboard.UP);
			keyCommand.commandGroup = "edit";
			keyCommand.requireAllKeys = true;
			keyCommand.requireUniquePress = true;
			_editCommands.attach(keyCommand);
			
			keyCommand = new KeyCommand(toggleBackWall, Keyboard.SHIFT, Keyboard.DOWN);
			keyCommand.commandGroup = "edit";
			keyCommand.requireAllKeys = true;
			keyCommand.requireUniquePress = true;
			_editCommands.attach(keyCommand);
			
			keyCommand = new KeyCommand(toggleLeftWall, Keyboard.SHIFT, Keyboard.LEFT);
			keyCommand.commandGroup = "edit";
			keyCommand.requireAllKeys = true;
			keyCommand.requireUniquePress = true;
			_editCommands.attach(keyCommand);
			
			keyCommand = new KeyCommand(toggleRightWall, Keyboard.SHIFT, Keyboard.RIGHT);
			keyCommand.commandGroup = "edit";
			keyCommand.requireAllKeys = true;
			keyCommand.requireUniquePress = true;
			_editCommands.attach(keyCommand);
			
			keyCommand = new KeyCommand(setStartingCell, Keyboard.SHIFT, "S");
			keyCommand.commandGroup = "edit";
			keyCommand.requireAllKeys = true;
			keyCommand.requireUniquePress = true;
			_editCommands.attach(keyCommand);
			
			keyCommand = new KeyCommand(addStairsDown, Keyboard.SHIFT, "D");
			keyCommand.commandGroup = "edit";
			keyCommand.requireAllKeys = true;
			keyCommand.requireUniquePress = true;
			_editCommands.attach(keyCommand);

			keyCommand = new KeyCommand(addTavern, Keyboard.SHIFT, "T");
			keyCommand.commandGroup = "edit";
			keyCommand.requireAllKeys = true;
			keyCommand.requireUniquePress = true;
			_editCommands.attach(keyCommand);

			keyCommand = new KeyCommand(addInn, Keyboard.SHIFT, "I");
			keyCommand.commandGroup = "edit";
			keyCommand.requireAllKeys = true;
			keyCommand.requireUniquePress = true;
			_editCommands.attach(keyCommand);
			
			// Cheat commands
			keyCommand = new KeyCommand(toggleCheatMode, Keyboard.SHIFT, Keyboard.F8);
			keyCommand.commandGroup = "cheat";
			keyCommand.requireAllKeys = true;
			keyCommand.requireUniquePress = true;
			attach(keyCommand);

			keyCommand = new KeyCommand(function():void {}, Keyboard.SHIFT);
			keyCommand.commandGroup = "cheat";
			_editCommands.attach(keyCommand);
			
			keyCommand = new KeyCommand(revealMapCheat, Keyboard.SHIFT, "R");
			keyCommand.commandGroup = "cheat";
			keyCommand.requireAllKeys = true;
			keyCommand.requireUniquePress = true;
			_cheatCommands.attach(keyCommand);
			
			keyCommand = new KeyCommand(gainLevelCheat, Keyboard.SHIFT, "L");
			keyCommand.commandGroup = "cheat";
			keyCommand.requireAllKeys = true;
			keyCommand.timeout = 1000;
			_cheatCommands.attach(keyCommand);
						
			sprite.scrollRect = new Rectangle(0, 0, width, height);
			reset();
		}
		
		private function descendStairs():void {
			if (_party.currentCell.object && _party.currentCell.object.type == CellType.STAIRS_DOWN) {
				newFloor();
				showPopupMessage("Welcome to floor " + (_party.currentFloor.id + 1) + ".");
			} else {
				showPopupMessage("No stairs to (d)escend.");
			}
		}
		
		private function toggleEditMode():void {
			_editMode = !_editMode;
			
			if (_editMode) {
				attachAtPosition(_editCommands, 0);
			} else {
				_editCommands.destroy();
			}
			
			showPopupMessage("Edit mode: " + _editMode);			
		}
		
		private function toggleCheatMode():void {
			_cheatMode = !_cheatMode;
			
			if (_cheatMode) {
				attachAtPosition(_cheatCommands, 0);
			} else {
				_cheatCommands.destroy();
			}
			
			showPopupMessage("Cheat mode: " + _cheatMode);			
		}
		
		private function revealMapCheat():void {
			showPopupMessage("CHEAT: Revealing map.");
			for (var i:uint = 0, n:uint = _party.currentFloor.width; i < n; ++i) {
				for (var j:uint = 0, m:uint = _party.currentFloor.height; j < m; ++j) {
					_party.currentFloor.getCell(i, j).visited = true;
				}
			}
		}
		
		private function gainLevelCheat():void {
			showPopupMessage("CHEAT: Gaining level.");
			for (var i:uint = 0; i < _party.size; ++i)
				_party.getCharacter(i).gainLevel();
		}
		
		private function toggleForwardWall():void {
			trace("toggle forward");
			_party.currentFloor.toggleWall(_party.cellX, _party.cellY, _party.getAbsoluteDirection(Directions.NORTH));
		}

		private function toggleBackWall():void {
			_party.currentFloor.toggleWall(_party.cellX, _party.cellY, _party.getAbsoluteDirection(Directions.SOUTH));
		}

		private function toggleLeftWall():void {
			trace("toggle left");
			_party.currentFloor.toggleWall(_party.cellX, _party.cellY, _party.getAbsoluteDirection(Directions.WEST));
		}

		private function toggleRightWall():void {
			_party.currentFloor.toggleWall(_party.cellX, _party.cellY, _party.getAbsoluteDirection(Directions.EAST));
		}
		
		private function setStartingCell():void {
			_party.currentFloor.start.x = _party.cellX;
			_party.currentFloor.start.y = _party.cellY;
			showPopupMessage("Set (" + _party.cellX + ", " + _party.cellY + ") as start cell.");
		}

		private function addStairsDown():void {
			_party.currentCell.object = new StairsDownObject(_party.currentFloor.id + 1);
			showPopupMessage("Added stairs down.");
		}
		
		private function addTavern():void {
			_party.currentCell.object = new TavernObject();
			showPopupMessage("Added tavern.");
		}
		
		private function addInn():void {
			_party.currentCell.object = new InnObject();
			showPopupMessage("Added inn.");
		}
		
		
		private function newFloor():void {
			_party.currentFloor = _maze.getFloor(StairsDownObject(_party.currentCell.object).floorID);
			
			_party.warp(_party.currentFloor.start.x, _party.currentFloor.start.y);
			_party.currentFloor.getCell(_party.cellX, _party.cellY).visited = true;
		};
		
		override public function update(delta:uint):void {
			super.update(delta);

			reset();
		}
		
		private function reset():void {
			var floor:Floor = _party.currentFloor;
			
			sprite.graphics.clear();
			
			sprite.graphics.beginFill(floor.skyColor);
			sprite.graphics.drawRect(0, 0, nominalWidth, nominalHeight >> 1);
			
			sprite.graphics.beginFill(floor.groundColor);
			sprite.graphics.drawRect(0, nominalHeight >> 1, nominalWidth, nominalHeight >> 1);
			
			sprite.graphics.lineStyle(2, 0xFFFFFF);
			
			
			var minDepth:int = 0;
			var maxDepth:int = 6;
			var cellPointer:CellPointer = new CellPointer(floor, _party.cellX, _party.cellY);
			
			for (var i:int = minDepth; i <= maxDepth; ++i)
				cellPointer.moveDirection(_party.facing);
			
			for (i = maxDepth; i >= minDepth; --i) {
				cellPointer.moveDirection(_party.getAbsoluteDirection(Directions.SOUTH));
				drawDepth(i, cellPointer);
			}
							
			_lastPartyX = _party.x;
			_lastPartyY = _party.z;
			_lastPartyFacing = _party.facing;
		}
		
		private function drawDepth(depth:int, cellPointer:CellPointer):void {
			var floor:Floor = _party.currentFloor;
			var halfNominalWidth:int = nominalWidth >> 1;			
			
			var polygons:Vector.<Polygon3D> = new Vector.<Polygon3D>();
			
			var wallSize:int = 200;
			var halfWallSize:int = wallSize >> 1;
			var perspective:int = halfNominalWidth;
			
			var x:int = halfWallSize - _party.cameraX;
			var z:int = wallSize * depth + _party.cameraZ;
			
			if (cellPointer.cell && (cellPointer.cell.walls & Directions.ALL) != Directions.ALL) {
				// draw middle frontal wall
				if (!(cellPointer.cell.walls & _party.facing)) {
					polygons.push(new Polygon3D(floor.wallTexture,
						new GridPoint3D(x - wallSize, halfWallSize, z),
						new GridPoint3D(x, halfWallSize, z),
						new GridPoint3D(x, -halfWallSize, z),
						new GridPoint3D(x - wallSize, -halfWallSize, z)
					));
				}
				
				// draw middle frontal stairs			
				if (cellPointer.cell.object && cellPointer.cell.object.type == CellType.STAIRS_DOWN) {
					polygons.push(new Polygon3D(Assets.stairsDown,
						new GridPoint3D(x - 25, halfWallSize, z - 25),
						new GridPoint3D(x - 175, halfWallSize, z - 25),
						new GridPoint3D(x - 175, halfWallSize, z - 175),
						new GridPoint3D(x - 25, halfWallSize, z - 175)
					));
				}
			}
			
			x = -halfWallSize - _party.cameraX;
			var sideWall:Boolean;
			var moves:int = 0;
			while ((perspective * (x / z)) + halfNominalWidth > 0) {
				sideWall = false;

				// find left side wall
				if (cellPointer.cell && !(cellPointer.cell.walls & _party.getAbsoluteDirection(Directions.WEST))) {
					sideWall = true;
				}
				
				cellPointer.moveDirection(_party.getAbsoluteDirection(Directions.WEST));
				++moves;
				
				if (cellPointer.cell && (cellPointer.cell.walls & Directions.ALL) != Directions.ALL) {
					// draw left back wall
					if (!(cellPointer.cell.walls & _party.facing)) {
						polygons.push(new Polygon3D(floor.wallTexture, 
							new GridPoint3D(x - wallSize, halfWallSize, z),
							new GridPoint3D(x, halfWallSize, z),
							new GridPoint3D(x, -halfWallSize, z),
							new GridPoint3D(x - wallSize, -halfWallSize, z)
						));
					}	
					
					// draw stairs
					if (cellPointer.cell.object && cellPointer.cell.object.type == CellType.STAIRS_DOWN) {
						polygons.push(new Polygon3D(Assets.stairsDown,
							new GridPoint3D(x - 25, halfWallSize, z - 25),
							new GridPoint3D(x - 175, halfWallSize, z - 25),
							new GridPoint3D(x - 175, halfWallSize, z - 175),
							new GridPoint3D(x - 25, halfWallSize, z - 175)
						));
					}
				}
					
				// draw left side wall
				if (sideWall) {
					polygons.push(new Polygon3D(floor.wallTexture,
						new GridPoint3D(x, halfWallSize, z),
						new GridPoint3D(x, -halfWallSize, z),
						new GridPoint3D(x, -halfWallSize, z - wallSize),
						new GridPoint3D(x, halfWallSize, z - wallSize)
					));
				}

				
				x -= wallSize;	
			}
						
			while (moves-- > 0)
				cellPointer.moveDirection(_party.getAbsoluteDirection(Directions.EAST));
			
			
			x = halfWallSize - _party.cameraX;
			moves = 0;
			
			
			while ((perspective * (x / z)) + halfNominalWidth < nominalWidth) {
				sideWall = false;
				
				// find right side wall
				if (cellPointer.cell && !(cellPointer.cell.walls & _party.getAbsoluteDirection(Directions.EAST))) {
					sideWall = true;
				} 

				cellPointer.moveDirection(_party.getAbsoluteDirection(Directions.EAST));
				++moves;
				
				if (cellPointer.cell && (cellPointer.cell.walls & Directions.ALL) != Directions.ALL) {
					// draw right back wall
					if (!(cellPointer.cell.walls & _party.facing)) {
						polygons.push(new Polygon3D(floor.wallTexture,
							new GridPoint3D(x + wallSize, halfWallSize, z),
							new GridPoint3D(x, halfWallSize, z),
							new GridPoint3D(x, -halfWallSize, z),
							new GridPoint3D(x + wallSize, -halfWallSize, z)
						));
					}
					
					if (cellPointer.cell.object && cellPointer.cell.object.type == CellType.STAIRS_DOWN) {
						polygons.push(new Polygon3D(Assets.stairsDown,
							new GridPoint3D(x + 25, halfWallSize, z - 25),
							new GridPoint3D(x + 175, halfWallSize, z - 25),
							new GridPoint3D(x + 175, halfWallSize, z - 175),
							new GridPoint3D(x + 25, halfWallSize, z - 175)
						));
					}
				}
					
				// draw right side wall
				if (sideWall) {
					polygons.push(new Polygon3D(floor.wallTexture,
						new GridPoint3D(x, halfWallSize, z),
						new GridPoint3D(x, -halfWallSize, z),
						new GridPoint3D(x, -halfWallSize, z - wallSize),
						new GridPoint3D(x, halfWallSize, z - wallSize)
					));
				}					
				
				x += wallSize;	
			}
			
			while (moves-- > 0)
				cellPointer.moveDirection(_party.getAbsoluteDirection(Directions.WEST));

			for each (var polygon3D:Polygon3D in polygons) {
				var polygon:Polygon = polygon3D.project(perspective, nominalWidth, nominalHeight);

				if (!polygon.truncate(-5, nominalWidth + 5, -5, nominalHeight + 5))
					continue;
					
				var m:Matrix = new Matrix();
				m.scale(polygon.width / polygon.texture.width, polygon.height / polygon.texture.height);
				m.translate(polygon.x, polygon.y);
				sprite.graphics.beginBitmapFill(polygon.texture, m, true);				

				sprite.graphics.moveTo(polygon.points[0].x, polygon.points[0].y);
				
				for (var i:uint = 1; i < polygon.points.length; ++i) {
					sprite.graphics.lineTo(polygon.points[i].x, polygon.points[i].y);
				}

				sprite.graphics.endFill();
			}
		}
	}
}
