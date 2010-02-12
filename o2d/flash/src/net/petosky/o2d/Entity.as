package net.petosky.o2d {
	import flash.events.EventDispatcher;	
	import flash.events.IEventDispatcher;	
	
	import net.petosky.o2d.script.ScriptableObject;	
	import net.petosky.o2d.player.View;	
	
	import flash.geom.Rectangle;	
	import flash.display.BitmapData;	
	import flash.geom.Point;
	import flash.events.Event;	

	/**
	 * @author Cory
	 */
	public class Entity extends ScriptableObject implements IEventDispatcher {
		private static var nextID:uint = 0;
		private var _id:uint;
		private var _name:String;
		
		private var _map:Map;
		private var _x:int;
		private var _y:int;

		private var _maxSpeed:int = 125;
		private var _moving:Boolean;
		private var _moveSumX:int = 0;
		private var _moveSumY:int = 0;
//		private var path:Vector.<GridPoint> = new Vector.<GridPoint>();
		
		private var _animTimer:int;
		private var _animInterval:int = 200;
		
		private var _facing:int;
		private var _speed:Point = new Point();

		private var _frame:int;
		private var _animating:Boolean;
		private var _graphics:EntityGraphics;

		//		public event EventHandler SpeedChange;

		public function Entity(graphics:EntityGraphics, map:Map, x:int, y:int) {
			super("entity");
			addScriptProperty("xVelocity");
			addScriptProperty("yVelocity");
			addScriptProperty("maxSpeed");
			addScriptProperty("name");
			
			_id = nextID++;
			this._graphics = graphics;

			teleportToMapTile(map, x, y);
		}


		public function get x():int {
			return _x;
		}
		public function set x(value:int):void {
			_x = value;
		}

		public function get y():int {
			return _y;
		}
		public function set y(value:int):void {
			_y = value;
		}

		public function get map():Map {
			return _map;
		}

		public function get id():uint {
			return _id;
		}

		public function get name():String {
			return _name;
		}
		public function set name(value:String):void {
			_name = value;
		}

		public function get facing():int {
			return _facing;
		}
		public function set facing(value:int):void {
			_facing = value;
		}

		public function get maxSpeed():int {
			return _maxSpeed;
		}
		public function set maxSpeed(value:int):void {
			_maxSpeed = value;
		}

		public function get moving():Boolean {
			return _moving;
		}

		public function get animating():Boolean {
			return _animating;
		}

		public function get frame():int {
			return _frame;
		}

		public function get width():int {
			return _graphics.width;
		}

		public function get height():int {
			return _graphics.height;
		}

		public function get speed():Point {
			return _speed;
		}
		public function set speed(value:Point):void {
			_speed = value;
			onSpeedChange();
		}

		public function get xVelocity():Number {
			return _speed.x;
		}
		public function set xVelocity(value:Number):void {
			_speed.x = value;
			onSpeedChange();
		}

		public function get yVelocity():Number {
			return _speed.y;
		}
		public function set yVelocity(value:Number):void {
			_speed.y = value;
			onSpeedChange();
		}



		private function onSpeedChange():void {
			_moving = _speed.x != 0 || _speed.y != 0;

			dispatchEvent(new EntityEvent(EntityEvent.VELOCITY_CHANGED, this));
		}


		public function update(delta:int):void {
			if (_animating) {
				_animTimer -= delta;
				if (_animTimer <= 0) {
					_frame = (_frame + 1) % _graphics.frames;
					_animTimer = _animInterval;
				}
			}
		}

		public function startAnimation(interval:int):void {
			_animating = true;
			_animTimer = interval;
			_animInterval = interval;
		}

		public function stopAnimation():void {
			_animating = false;
			_frame = 0;
		}

		public function renderPart(output:BitmapData, view:View, part:int):void {
			if (_x + _graphics.width < view.x || _y + _graphics.height < view.y ||
				_x > view.x + view.width || _y > view.y + view.height)
				return;
				
			var offset1:int = _y % Tile.SIZE;
			var offset2:int = Tile.SIZE -offset1;

			var maxParts:int = 0;

			var h:int = _graphics.height;

			if (offset1 > 0) {
				maxParts++;
				h -= offset2;
			}
			maxParts += h / Tile.SIZE;
			if (h % Tile.SIZE > 0)
				maxParts++;

			if (part >= maxParts)
				return;
				
			var srcRect:Rectangle = new Rectangle(
				_frame * _graphics.width,
				_facing * _graphics.height,
				_graphics.width, 
				0
			);				

			var yPart:int = (Tile.SIZE * (maxParts - part - 1)) - offset1;

			if (yPart < 0)
				yPart = 0;

			srcRect.y += yPart;

			if (part == maxParts - 1) {
				srcRect.height = offset2;
			} else if (part == 0) {
				srcRect.height = (_graphics.height - offset2) % Tile.SIZE;
				if (srcRect.height == 0)
					srcRect.height = Tile.SIZE;
			} else {
				srcRect.height = Tile.SIZE;
			}

			var destPoint:Point = new Point(
				_x - view.x,
				_y - view.y + yPart
			);
				
			var xOffset:int = 0;
			var yOffset:int = 0;

			if (destPoint.x < 0)
				xOffset = -destPoint.x;
			else if ((destPoint.x + srcRect.width) > view.width)
				xOffset = view.width - (destPoint.x + srcRect.width);

			if (destPoint.y < 0)
				yOffset = -destPoint.y;
			else if ((destPoint.y + srcRect.height) > view.height)
				yOffset = view.height - (destPoint.y + srcRect.height);

			srcRect.width -= Math.abs(xOffset);
			srcRect.height -= Math.abs(yOffset);

			if (xOffset < 0)
				xOffset = 0;
			if (yOffset < 0)
				yOffset = 0;
 
			destPoint.x += xOffset;
			destPoint.y += yOffset;
 
			srcRect.x += xOffset;
			srcRect.y += yOffset;

			destPoint.x += view.screenX;
			destPoint.y += view.screenY;
			output.copyPixels(_graphics.texture, srcRect, destPoint, null, null, true);
		}
		
		public function teleport(newX:int, newY:int):void {
			_x = newX;
			_y = newY;
		}
		
		public function teleportToTile(newX:int, newY:int):void {
			_x = newX * Tile.SIZE;
			_y = (newY + 1) * Tile.SIZE - _graphics.height - 1;
		}

		public function teleportToMapTile(newMap:Map, newX:int, newY:int):void {
			if (_map != null)
				_map.removeEntity(this);
			_map = newMap;
			teleportToTile(newX, newY);
			_map.addEntity(this);
		}

		public function moveX(distance:int):void {
			_x += distance;
			if (distance > 0)
				_facing = Direction.EAST;
			else if (distance < 0)
				_facing = Direction.WEST;
		}

		public function moveY(distance:int):void {
			_y += distance;
			if (distance > 0)
				_facing = Direction.SOUTH;
			else if (distance < 0)
				_facing = Direction.NORTH;
		}

		public function rotateCounterClockwise():void {
			switch (_facing) {
			case Direction.SOUTH:
				_facing = Direction.EAST;
				break;
			case Direction.EAST:
				_facing = Direction.NORTH;
				break;
			case Direction.NORTH:
				_facing = Direction.WEST;
				break;
			case Direction.WEST:
				_facing = Direction.SOUTH;
				break;	
			}
		}
		
		public function rotateClockwise():void {
			switch (_facing) {
			case Direction.SOUTH:
				_facing = Direction.WEST;
				break;
			case Direction.EAST:
				_facing = Direction.SOUTH;
				break;
			case Direction.NORTH:
				_facing = Direction.EAST;
				break;
			case Direction.WEST:
				_facing = Direction.NORTH;
				break;	
			}
		}

		public function move(delta:int):void {
			// Movement
			_moveSumX += (int)(_maxSpeed * _speed.x * delta);
			_moveSumY += (int)(_maxSpeed * _speed.y * delta);
			var distanceX:int = _moveSumX / 1000;
			var distanceY:int = -(_moveSumY / 1000); // negative because stick direction and pixel direction differ
			_moveSumX %= 1000;
			_moveSumY %= 1000;

			if (distanceX == 0 && distanceY == 0)
				return;

			var x1:int, x2:int, y1:int, y2:int;
			var occupied:Vector.<int> = getTilesOccupied();
			x1 = occupied[0];
			y1 = occupied[1];
			x2 = occupied[2];
			y2 = occupied[3];
		
//			if (path.Count > 0) {
//				// Move according to move queue
//				var xDelta:int, yDelta:int;
//				var p:GridPoint = path.Peek();
//				while ((x1 == p.x && p.x == x2) &&
//					   (y1 == p.y && p.y == y2)) {
//					path.Pop();
//					if (path.Count == 0) {
//						moving = false;
//						return;
//					}
//					p = path.Peek();
//				}
//				
//				// Figure out which direction to get to tile in question.
//				// Here, x and y refer to the distance needed to travel in each
//				// direction to get to the goal tile.
//				xDelta = (int)Math.Max(Math.Abs(x1 - p.X), Math.Abs(x2 - p.X));
//				yDelta = (int)Math.Max(Math.Abs(y1 - p.Y), Math.Abs(y2 - p.Y));
//						
//				if (yDelta == 0 || (xDelta != 0 && xDelta < yDelta))
//					if (p.X <= x1) {
//						facing = Direction.West; speed.X = -1.0f; speed.Y = 0;
//					} else {
//						facing = Direction.East; speed.X = 1.0f; speed.Y = 0;
//					}
//				else
//					if (p.Y <= y1) {
//						facing = Direction.North; speed.X = 0; speed.Y = 1.0f;
//					} else {
//						facing = Direction.South; speed.X = 0; speed.Y = -1.0f;
//					}
//							
//				moving = true;
//			}


			if (_moving) {
				var goodToGo:Boolean;
				var i:int;
				var j:int;
				
				// Try to move up
				if (distanceY < 0 && _y + distanceY >= 0) {
					goodToGo = true;
					// Test if movement crosses tile boundary
					if (int((_y + _graphics.height - (_graphics.width >> 1))/ Tile.SIZE) !=
							int((_y + _graphics.height - (_graphics.width >> 1) + distanceY) / Tile.SIZE)) {
						// Since movement crosses boundary, check passage information				
						for (i = x1; i <= x2; ++i) {
							// First check leave passage information on current tiles
							if ((map.getLogicalTile(i, y1).access & TileAccess.LEAVE_NORTH) == TileAccess.NONE) {
								goodToGo = false;
								break;
							}
							// Then check enter permission on acquiring tile
							if ((map.getLogicalTile(i, y1 - 1).access & TileAccess.ENTER_SOUTH) == TileAccess.NONE) {
								goodToGo = false;
								break;
							}
						}
					} 
					if (goodToGo) {
						// Move
						moveY(distanceY);
					}
				}
				// Try to move down
				else if (distanceY > 0 && _y + distanceY < map.pixelHeight - _graphics.height) {
					goodToGo = true;
					// Test if movement crosses tile boundary
					if (int((_y + _graphics.height) / Tile.SIZE) !=
							int((_y + _graphics.height + distanceY) / Tile.SIZE)) {
						// Since movement crosses boundary, check passage information				
						for (i = x1; i <= x2; ++i) {
							// First check leave passage information on current tiles
							if ((map.getLogicalTile(i, y2).access & TileAccess.LEAVE_SOUTH) == TileAccess.NONE) {
								goodToGo = false;
								break;
							}
							// Then check enter permission on acquiring tile
							if ((map.getLogicalTile(i, y2 + 1).access & TileAccess.ENTER_NORTH) == TileAccess.NONE) {
								goodToGo = false;
								break;
							}
						}
					} 
					if (goodToGo) {
						// Move
						moveY(distanceY);
					}
				}
				
				// Try to move left
				if (distanceX < 0 && _x + distanceX >= 0) {
					goodToGo = true;
					// Test if movement crosses tile boundary
					if (int((_x + (_graphics.width >> 2)) / Tile.SIZE) !=
							int((_x + (_graphics.width >> 2) + distanceX) / Tile.SIZE)) {
						// Since movement crosses boundary, check passage information				
						for (j = y1; j <= y2; ++j) {
							// First check leave passage information on current tiles
							if ((map.getLogicalTile(x1, j).access & TileAccess.LEAVE_WEST) == TileAccess.NONE) {
								goodToGo = false;
								break;
							}
							// Then check enter permission on acquiring tile
							if ((map.getLogicalTile(x1 - 1, j).access & TileAccess.ENTER_EAST) == TileAccess.NONE) {
								goodToGo = false;
								break;
							}
						}
					} 
					if (goodToGo) {
						// Move
						moveX(distanceX);
					}
				}
				// Try to move right
				else if (distanceX > 0 && _x + distanceX < map.pixelWidth - _graphics.width) {
					goodToGo = true;
					// Test if movement crosses tile boundary
					if (int((_x + 3 * ((_graphics.width >> 2))) / Tile.SIZE) != 
							int((_x + 3 * ((_graphics.width >> 2)) + distanceX) / Tile.SIZE)) {
						// Since movement crosses boundary, check passage information				
						for (j = y1; j <= y2; ++j) {
							// First check leave passage information on current tiles
							if ((map.getLogicalTile(x2, j).access & TileAccess.LEAVE_EAST) == TileAccess.NONE) {
								goodToGo = false;
								break;
							}
							// Then check enter permission on acquiring tile
							if ((map.getLogicalTile(x2 + 1, j).access & TileAccess.ENTER_WEST) == TileAccess.NONE) {
								goodToGo = false;
								break;
							}
						}
					} 
					if (goodToGo) {
						// Move
						moveX(distanceX);
					}
				}
			}
		}
//
//		#region Pathfinding
//		
//		private class Node : IComparable<Node> {
//			public int X;
//			public int Y;
//			public Node Parent;
//			public int Cost;
//			public bool Closed;
//			
//			public Node(int x, int y) {
//				X = x;
//				Y = y;
//				Parent = null;
//				Cost = -1;
//				Closed = false;
//			}
//
//			public int CompareTo(Node other) {
//				return Cost - other.Cost;
//			}
//		}
//
//		private int guessDistance(int x1, int y1, int x2, int y2) {
//			return Math.Abs(x1 - x2) + Math.Abs(y1 - y2);
//		}
//
//		private int moveCost(int x1, int y1, int x2, int y2) {
//			return 1;
//		}
//
//		private int mark(Node node, Node parent, int dX, int dY) {
//			int cost = moveCost(node.X, node.Y, parent.X, parent.Y) + guessDistance(node.X, node.Y, dX, dY);
//			if (node.Cost == -1 || node.Cost > cost) {
//				node.Parent = parent;
//				node.Cost = cost;
//				return cost;
//			}
//			return node.Cost; 
//		}
//
		/// <summary>
		/// Returns all the tile coordinates which this entity is currently occupying.
		/// This takes projected 3D space into account. In general, an entity is
		/// considered to occupy the tiles covered by a rectangle (width / 2) pixels wide
		/// and (width / 2) pixels tall, starting from its base. Naturally, entities with
		/// strange form factors won't fit this general rule.
		///
		/// This is used mostly for map-based border detection. It is unsuitable for
		/// entity-on-entity collision, and should not be used for such purposes.
		
		/// TODO: Load necessary form factor information from the XML instead of relying
		/// upon above formula to always hold true.
		/// </summary>
		private function getTilesOccupied():Vector.<int> {
			var x1:int, y1:int, x2:int, y2:int;
			x1 = _x + (_graphics.width >> 2);
			y1 = _y + _graphics.height - (_graphics.width >> 1);
			x2 = x1 + (_graphics.width >> 1);
			y2 = y1 + (_graphics.width >> 1);

			x1 /= Tile.SIZE;
			y1 /= Tile.SIZE;
			x2 /= Tile.SIZE;
			y2 /= Tile.SIZE;

			return Vector.<int>([x1, y1, x2, y2]);
		}
		
		
		private var _eventDispatcher:EventDispatcher = new EventDispatcher();

		public function dispatchEvent(event:Event):Boolean {
			return _eventDispatcher.dispatchEvent(event);
		}

		
		
		public function hasEventListener(type:String):Boolean {
			return _eventDispatcher.hasEventListener(type);
		}

		
		
		public function willTrigger(type:String):Boolean {
			return _eventDispatcher.willTrigger(type);
		}

		
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void {
			_eventDispatcher.removeEventListener(type, listener, useCapture);
		}

		
		
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void {
			_eventDispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
//			
//		public void WalkToTile(int dX, int dY) {
//			Node[,] tree = new Node[map.Width, map.Height];
//
//			for (int i = 0; i < map.Width; ++i) {
//				for (int j = 0; j < map.Height; ++j) {
//					tree[i, j] = new Node(i, j);
//				}
//			}
//
//			PriorityQueue<Node> nodeQ = new PriorityQueue<Node>();
//
//			int x1, y1, x2, y2;
//			getTilesOccupied(out x1, out y1, out x2, out y2);
//			nodeQ.Enqueue(tree[x1, y1]);
//			while (nodeQ.Count > 0) {
//				Node node = nodeQ.Dequeue();
//				
//				// End if target node found
//				if (node.X == dX && node.Y == dY)
//					break;
//					
//				if (!node.Closed) {
//					// Push neighboring nodes into the queue.
//					if (node.X > 0 && !tree[node.X-1, node.Y].Closed &&
//							(map[node.X-1, node.Y].Access & TileAccess.EnterEast) != TileAccess.None) {
//						mark(tree[node.X-1, node.Y], node, dX, dY);
//						nodeQ.Enqueue(tree[node.X-1, node.Y]);
//					}
//					if (node.X < map.Width - 1 && !tree[node.X+1, node.Y].Closed &&
//							(map[node.X+1, node.Y].Access & TileAccess.EnterWest) != TileAccess.None) {
//						mark(tree[node.X+1, node.Y], node, dX, dY);
//						nodeQ.Enqueue(tree[node.X+1, node.Y]);
//					}
//					if (node.Y > 0 && !tree[node.X, node.Y-1].Closed &&
//							(map[node.X, node.Y-1].Access & TileAccess.EnterSouth) != TileAccess.None) {
//						mark(tree[node.X, node.Y-1], node, dX, dY);
//						nodeQ.Enqueue(tree[node.X, node.Y-1]);
//					}
//					if (node.Y < map.Height - 1 && !tree[node.X, node.Y+1].Closed &&
//							(map[node.X, node.Y+1].Access & TileAccess.EnterNorth) != TileAccess.None) {
//						mark(tree[node.X, node.Y+1], node, dX, dY);
//						nodeQ.Enqueue(tree[node.X, node.Y+1]);
//					}
//					node.Closed = true;			
//				}
//			} 
//			
//			Node n = tree[dX, dY];
//			do {
//				path.Push(new Point(n.X, n.Y));
//			} while ((n = n.Parent) != null);
//		}
	}
}

