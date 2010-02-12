using System;
using System.Collections.Generic;
using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Audio;
using Microsoft.Xna.Framework.Graphics;
using Microsoft.Xna.Framework.Input;
using Microsoft.Xna.Framework.Storage;
using Microsoft.Xna.Framework.Content;
using net.tanatopia.collections;
using o2d.map;

namespace o2d.entity {
    public class Entity {
        public enum Direction {
            South = 0, West, East, North
        }

        private static readonly Vector2 origin = new Vector2(0, 0);

        private static uint nextID = 0;
        private uint id;
        private string name;
        
        private Map map;
        private int x;
        private int y;

		private int maxSpeed = 125;
		private bool moving;
        private int moveSumX = 0;
        private int moveSumY = 0;
		private Stack<Point> path = new Stack<Point>();
		
		private int animTimer;
		private int animInterval = 200;
		
		private Direction facing;
        private Vector2 speed = Vector2.Zero;

		int frame;
		bool animating;
        private EntityGraphics graphics;

        public event EventHandler SpeedChange;

        public Entity(EntityGraphics graphics) {
            id = nextID++;
            this.graphics = graphics;
        }

        public Entity(EntityGraphics graphics, Map map, int x, int y) : this(graphics) {
            Teleport(map, x, y);
        }


        #region Properties

        public int X {
            get { return x; }
        }

        public int Y {
            get { return y; }
        }

        public Map Map {
            get { return map; }
        }

        public uint ID {
            get { return id; }
        }

        public string Name {
            get { return name; }
            set { name = value; }
        }

        public Direction Facing {
            get { return facing; }
            set { facing = value; }
        }

        public int MaxSpeed {
            get { return maxSpeed; }
            set { maxSpeed = value; }
        }

        public bool Moving {
            get { return moving; }
            set { moving = value; }
        }

        public bool Animating {
            get { return animating; }
        }

        public int Frame {
            get { return frame; }
        }

        public int Width {
            get { return graphics.Height; }
        }

        public int Height {
            get { return graphics.Width; }
        }

        public Vector2 Speed {
            get { return speed; }
            set { speed = value; onSpeedChange(); }
        }

        public float SpeedX {
            get { return speed.X; }
            set { speed.X = value; onSpeedChange(); }
        }

        public float SpeedY {
            get { return speed.Y; }
            set { speed.Y = value; onSpeedChange(); }
        }

        #endregion

        #region Events

        private void onSpeedChange() {
            if (SpeedChange != null)
                SpeedChange(this, EventArgs.Empty);
        }

        #endregion

        public void PassTime(int delta) {
            if (animating) {
                animTimer -= delta;
                if (animTimer <= 0) {
                    frame = (frame + 1) % graphics.Frames;
                    animTimer = animInterval;
                }
            }
        }

        public void StartAnimation(int interval) {
            animating = true;
            animTimer = interval;
            animInterval = interval;
        }

        public void StopAnimation() {
            animating = false;
            frame = 0;
        }

        public void Render(SpriteBatch sb, View view) {
            if (x + graphics.Width < view.X || y + graphics.Height < view.Y ||
                x > view.X + view.Width || y > view.Y + view.Height)
                return;
            int offset1 = y % Tile.Size;
            int offset2 = Tile.Size -offset1;

            int maxParts = 0;

            int h = graphics.Height;

            if (offset1 > 0) {
                maxParts++;
                h -= offset2;
            }
            maxParts += h / Tile.Size;
            if (h % Tile.Size > 0)
                maxParts++;

            for (int part = 0; part < maxParts; ++part) {
                Rectangle srcRect = new Rectangle(
                    frame * graphics.Width,
                    (int)facing * graphics.Height,
                    graphics.Width, 
                    0
                );                

                int yPart = (Tile.Size * (maxParts - part - 1)) - offset1;

                if (yPart < 0)
                    yPart = 0;

                srcRect.Y += yPart;

                if (part == maxParts - 1) {
                    srcRect.Height = offset2;
                } else if (part == 0) {
                    srcRect.Height = (graphics.Height - offset2) % Tile.Size;
                    if (srcRect.Height == 0)
                        srcRect.Height = Tile.Size;
                } else {
                    srcRect.Height = Tile.Size;
                }

                Rectangle dstRect = new Rectangle(
                    x - view.X,
                    y - view.Y + yPart,
                    srcRect.Width,
                    srcRect.Height
                );
                
                int xOffset = 0;
                int yOffset = 0;

                if (dstRect.X < 0)
                    xOffset = -dstRect.X;
                else if ((dstRect.X + dstRect.Width) > view.Width)
                    xOffset = view.Width - (dstRect.X + dstRect.Width);

                if (dstRect.Y < 0)
                    yOffset = -dstRect.Y;
                else if ((dstRect.Y + dstRect.Height) > view.Height)
                    yOffset = view.Height - (dstRect.Y + dstRect.Height);

                srcRect.Width -= Math.Abs(xOffset);
                srcRect.Height -= Math.Abs(yOffset);

                dstRect.Width = srcRect.Width;
                dstRect.Height = srcRect.Height;

                if (xOffset < 0)
                    xOffset = 0;
                if (yOffset < 0)
                    yOffset = 0;
 
                dstRect.X += xOffset;
                dstRect.Y += yOffset;
 
                srcRect.X += xOffset;
                srcRect.Y += yOffset;

                dstRect.X += view.ScreenX;
                dstRect.Y += view.ScreenY;
                sb.Draw(graphics.Texture, dstRect, srcRect, Color.White, 0, origin, SpriteEffects.None, ZIndex(part));
            }
        }

        public float ZIndex(int part) {
            return Math.Abs(1.0f - ((float)(part * Map.Layers + Map.Layers - 1) / (float)(Map.Priorities * Map.Layers)));
        }

        #region Movement

        public void Teleport(int newX, int newY) {
            x = newX * Tile.Size;
		    y = (newY + 1) * Tile.Size - graphics.Height - 1;
        }

        public void Teleport(Map newMap, int newX, int newY) {
            if (map != null)
                map.RemoveEntity(this);
            map = newMap;
            Teleport(newX, newY);
            map.AddEntity(this);
        }

        public void MoveX(int d) {
            x += d;
            if (d > 0)
                facing = Direction.East;
            else if (d < 0)
                facing = Direction.West;
        }

        public void MoveY(int d) {
            y += d;
            if (d > 0)
                facing = Direction.South;
            else if (d < 0)
                facing = Direction.North;
        }

        public void RotateLeft() {
	        switch (facing) {
	        case Direction.South:
		        facing = Direction.East;
		        break;
	        case Direction.East:
		        facing = Direction.North;
		        break;
	        case Direction.North:
		        facing = Direction.West;
		        break;
	        case Direction.West:
		        facing = Direction.South;
		        break;	
	        }
        }
    	
        public void RotateRight() {
	        switch (facing) {
	        case Direction.South:
		        facing = Direction.West;
		        break;
	        case Direction.East:
		        facing = Direction.South;
		        break;
	        case Direction.North:
		        facing = Direction.East;
		        break;
	        case Direction.West:
		        facing = Direction.North;
		        break;	
	        }
        }

	    public void Move(int delta) {
		    // Movement
		    moveSumX += (int)(maxSpeed * speed.X * delta);
            moveSumY += (int)(maxSpeed * speed.Y * delta);
		    int moveX = moveSumX / 1000;
            int moveY = -(moveSumY / 1000); // negative because stick direction and pixel direction differ
		    moveSumX %= 1000;
            moveSumY %= 1000;

            if (moveX == 0 && moveY == 0)
                return;

		    int x1, x2, y1, y2;
		    getTilesOccupied(out x1, out y1, out x2, out y2);
    	
		    if (path.Count > 0) {
			    // Move according to move queue
			    int xDelta, yDelta;
			    Point p = path.Peek();
			    while ((x1 == p.X && p.X == x2) &&
			           (y1 == p.Y && p.Y == y2)) {
				    path.Pop();
				    if (path.Count == 0) {
					    moving = false;
					    return;
				    }
			        p = path.Peek();
			    }
    			
			    // Figure out which direction to get to tile in question.
			    // Here, x and y refer to the distance needed to travel in each
			    // direction to get to the goal tile.
			    xDelta = (int)Math.Max(Math.Abs(x1 - p.X), Math.Abs(x2 - p.X));
			    yDelta = (int)Math.Max(Math.Abs(y1 - p.Y), Math.Abs(y2 - p.Y));
    					
			    if (yDelta == 0 || (xDelta != 0 && xDelta < yDelta))
                    if (p.X <= x1) {
                        facing = Direction.West; speed.X = -1.0f; speed.Y = 0;
                    } else {
                        facing = Direction.East; speed.X = 1.0f; speed.Y = 0;
                    }
			    else
                    if (p.Y <= y1) {
                        facing = Direction.North; speed.X = 0; speed.Y = 1.0f;
                    } else {
                        facing = Direction.South; speed.X = 0; speed.Y = -1.0f;
                    }
    						
			    moving = true;
		    }


		    if (moving) {
			    // Try to move up
			    if (moveY < 0 && y + moveY >= 0) {
				    bool goodToGo = true;
				    // Test if movement crosses tile boundary
				    if (((y + graphics.Height - graphics.Width / 2)/ Tile.Size) !=
						    ((y + graphics.Height - graphics.Width / 2 + moveY) / Tile.Size)) {
					    // Since movement crosses boundary, check passage information				
					    for (int i = x1; i <= x2; ++i) {
						    // First check leave passage information on current tiles
						    if ((map[i, y1].Access & TileAccess.LeaveNorth) == TileAccess.None) {
							    goodToGo = false;
							    break;
						    }
						    // Then check enter permission on acquiring tile
                            if ((map[i, y1 - 1].Access & TileAccess.EnterSouth) == TileAccess.None) {
							    goodToGo = false;
							    break;
						    }
					    }
				    } 
				    if (goodToGo) {
					    // Move
					    MoveY(moveY);
				    }
			    }
			    // Try to move down
			    else if (moveY > 0 && y + moveY < map.PixelHeight - graphics.Height) {
				    bool goodToGo = true;
				    // Test if movement crosses tile boundary
				    if (((y + graphics.Height) / Tile.Size) !=
						    ((y + graphics.Height + moveY) / Tile.Size)) {
					    // Since movement crosses boundary, check passage information				
					    for (int i = x1; i <= x2; ++i) {
						    // First check leave passage information on current tiles
                            if ((map[i, y2].Access & TileAccess.LeaveSouth) == TileAccess.None) {
							    goodToGo = false;
							    break;
						    }
						    // Then check enter permission on acquiring tile
                            if ((map[i, y2 + 1].Access & TileAccess.EnterNorth) == TileAccess.None) {
							    goodToGo = false;
							    break;
						    }
					    }
				    } 
				    if (goodToGo) {
					    // Move
					    MoveY(moveY);
				    }
			    }
			    
                // Try to move left
			    if (moveX < 0 && x + moveX >= 0) {
				    bool goodToGo = true;
				    // Test if movement crosses tile boundary
				    if (((x + graphics.Width / 4)/ Tile.Size) !=
						    ((x + graphics.Width / 4 + moveX) / Tile.Size)) {
					    // Since movement crosses boundary, check passage information				
					    for (int j = y1; j <= y2; ++j) {
						    // First check leave passage information on current tiles
                            if ((map[x1, j].Access & TileAccess.LeaveWest) == TileAccess.None) {
							    goodToGo = false;
							    break;
						    }
						    // Then check enter permission on acquiring tile
                            if ((map[x1 - 1, j].Access & TileAccess.EnterEast) == TileAccess.None) {
							    goodToGo = false;
							    break;
						    }
					    }
				    } 
				    if (goodToGo) {
					    // Move
					    MoveX(moveX);
				    }
			    }
			    // Try to move right
			    else if (moveX > 0 && x + moveX < map.PixelWidth - graphics.Width) {
				    bool goodToGo = true;
				    // Test if movement crosses tile boundary
				    if (((x + 3 * (graphics.Width / 4))/ Tile.Size) != 
						    ((x + 3 * (graphics.Width / 4) + moveX) / Tile.Size)) {
					    // Since movement crosses boundary, check passage information				
					    for (int j = y1; j <= y2; ++j) {
						    // First check leave passage information on current tiles
                            if ((map[x2, j].Access & TileAccess.LeaveEast) == TileAccess.None) {
							    goodToGo = false;
							    break;
						    }
						    // Then check enter permission on acquiring tile
                            if ((map[x2 + 1, j].Access & TileAccess.EnterWest) == TileAccess.None) {
							    goodToGo = false;
							    break;
						    }
					    }
				    } 
				    if (goodToGo) {
					    // Move
					    MoveX(moveX);
				    }
			    }
		    }
        }

        #region Pathfinding
        
        private class Node : IComparable<Node> {
			public int X;
			public int Y;
			public Node Parent;
			public int Cost;
			public bool Closed;
            
            public Node(int x, int y) {
                X = x;
                Y = y;
                Parent = null;
                Cost = -1;
                Closed = false;
            }

            public int CompareTo(Node other) {
                return Cost - other.Cost;
            }
		}

        private int guessDistance(int x1, int y1, int x2, int y2) {
	        return Math.Abs(x1 - x2) + Math.Abs(y1 - y2);
        }

        private int moveCost(int x1, int y1, int x2, int y2) {
	        return 1;
        }

        private int mark(Node node, Node parent, int dX, int dY) {
		    int cost = moveCost(node.X, node.Y, parent.X, parent.Y) + guessDistance(node.X, node.Y, dX, dY);
		    if (node.Cost == -1 || node.Cost > cost) {
			    node.Parent = parent;
			    node.Cost = cost;
			    return cost;
		    }
		    return node.Cost; 
	    }

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
	    private void getTilesOccupied(out int x1, out int y1, out int x2, out int y2) {
		    x1 = x + (graphics.Width / 4);
            y1 = y + graphics.Height - (graphics.Width / 2);
            x2 = x1 + (graphics.Width / 2);
            y2 = y1 + (graphics.Width / 2);
    		
		    x1 /= Tile.Size;
		    y1 /= Tile.Size;
		    x2 /= Tile.Size;
            y2 /= Tile.Size;
	    }
    		
	    public void WalkToTile(int dX, int dY) {
		    Node[,] tree = new Node[map.Width, map.Height];

		    for (int i = 0; i < map.Width; ++i) {
			    for (int j = 0; j < map.Height; ++j) {
				    tree[i, j] = new Node(i, j);
			    }
		    }

		    PriorityQueue<Node> nodeQ = new PriorityQueue<Node>();

		    int x1, y1, x2, y2;
		    getTilesOccupied(out x1, out y1, out x2, out y2);
		    nodeQ.Enqueue(tree[x1, y1]);
		    while (nodeQ.Count > 0) {
			    Node node = nodeQ.Dequeue();
    			
			    // End if target node found
			    if (node.X == dX && node.Y == dY)
				    break;
    				
			    if (!node.Closed) {
				    // Push neighboring nodes into the queue.
				    if (node.X > 0 && !tree[node.X-1, node.Y].Closed &&
						    (map[node.X-1, node.Y].Access & TileAccess.EnterEast) != TileAccess.None) {
					    mark(tree[node.X-1, node.Y], node, dX, dY);
					    nodeQ.Enqueue(tree[node.X-1, node.Y]);
				    }
				    if (node.X < map.Width - 1 && !tree[node.X+1, node.Y].Closed &&
						    (map[node.X+1, node.Y].Access & TileAccess.EnterWest) != TileAccess.None) {
					    mark(tree[node.X+1, node.Y], node, dX, dY);
					    nodeQ.Enqueue(tree[node.X+1, node.Y]);
				    }
				    if (node.Y > 0 && !tree[node.X, node.Y-1].Closed &&
						    (map[node.X, node.Y-1].Access & TileAccess.EnterSouth) != TileAccess.None) {
					    mark(tree[node.X, node.Y-1], node, dX, dY);
					    nodeQ.Enqueue(tree[node.X, node.Y-1]);
				    }
				    if (node.Y < map.Height - 1 && !tree[node.X, node.Y+1].Closed &&
						    (map[node.X, node.Y+1].Access & TileAccess.EnterNorth) != TileAccess.None) {
					    mark(tree[node.X, node.Y+1], node, dX, dY);
					    nodeQ.Enqueue(tree[node.X, node.Y+1]);
				    }
				    node.Closed = true;			
			    }
		    } 
    		
		    Node n = tree[dX, dY];
		    do {
			    path.Push(new Point(n.X, n.Y));
		    } while ((n = n.Parent) != null);
	    }

        #endregion

        #endregion
    }
}


/*
	    public void Move(int delta) {
		    // Movement
		    moveSum += (maxSpeed * delta);
		    int move = moveSum / 1000;
		    moveSum %= 1000;

		    int x1, x2, y1, y2;
		    getTilesOccupied(out x1, out y1, out x2, out y2);
    	
		    if (path.Count > 0) {
			    // Move according to move queue
			    int xDelta, yDelta;
			    Point p = path.Peek();
			    while ((x1 == p.X && p.X == x2) &&
			           (y1 == p.Y && p.Y == y2)) {
				    path.Pop();
				    if (path.Count == 0) {
					    moving = false;
					    return;
				    }
			        p = path.Peek();
			    }
    			
			    // Figure out which direction to get to tile in question.
			    // Here, x and y refer to the distance needed to travel in each
			    // direction to get to the goal tile.
			    xDelta = (int)Math.Max(Math.Abs(x1 - p.X), Math.Abs(x2 - p.X));
			    yDelta = (int)Math.Max(Math.Abs(y1 - p.Y), Math.Abs(y2 - p.Y));
    					
			    if (yDelta == 0 || (xDelta != 0 && xDelta < yDelta))
                    if (p.X <= x1) {
                        facing = Direction.West; speed.X = -1.0f; speed.Y = 0;
                    } else {
                        facing = Direction.East; speed.X = 1.0f; speed.Y = 0;
                    }
			    else
                    if (p.Y <= y1) {
                        facing = Direction.North; speed.X = 0; speed.Y = 1.0f;
                    } else {
                        facing = Direction.South; speed.X = 0; speed.Y = -1.0f;
                    }
    						
			    moving = true;
		    }
		    if (moving) {
			    // Try to move up
			    if ((facing == Direction.North) && y - move >= 0) {
				    bool goodToGo = true;
				    // Test if movement crosses tile boundary
				    if (((y + graphics.Height - graphics.Width / 2)/ Tile.Size) !=
						    ((y + graphics.Height - graphics.Width / 2 - move) / Tile.Size)) {
					    // Since movement crosses boundary, check passage information				
					    for (int i = x1; i <= x2; ++i) {
						    // First check leave passage information on current tiles
						    if ((map[i, y1].Access & TileAccess.LeaveNorth) == TileAccess.None) {
							    goodToGo = false;
							    break;
						    }
						    // Then check enter permission on acquiring tile
                            if ((map[i, y1 - 1].Access & TileAccess.EnterSouth) == TileAccess.None) {
							    goodToGo = false;
							    break;
						    }
					    }
				    } 
				    if (goodToGo) {
					    // Move
					    MoveY(-move);
				    }
			    }
			    // Try to move down
			    else if ((facing == Direction.South) && y + move < map.PixelHeight - graphics.Height) {
				    bool goodToGo = true;
				    // Test if movement crosses tile boundary
				    if (((y + graphics.Height) / Tile.Size) !=
						    ((y + graphics.Height + move) / Tile.Size)) {
					    // Since movement crosses boundary, check passage information				
					    for (int i = x1; i <= x2; ++i) {
						    // First check leave passage information on current tiles
                            if ((map[i, y2].Access & TileAccess.LeaveSouth) == TileAccess.None) {
							    goodToGo = false;
							    break;
						    }
						    // Then check enter permission on acquiring tile
                            if ((map[i, y2 + 1].Access & TileAccess.EnterNorth) == TileAccess.None) {
							    goodToGo = false;
							    break;
						    }
					    }
				    } 
				    if (goodToGo) {
					    // Move
					    MoveY(move);
				    }
			    }
			    // Try to move left
			    else if ((facing == Direction.West) && x - move >= 0) {
				    bool goodToGo = true;
				    // Test if movement crosses tile boundary
				    if (((x + graphics.Width / 4)/ Tile.Size) !=
						    ((x + graphics.Width / 4 - move) / Tile.Size)) {
					    // Since movement crosses boundary, check passage information				
					    for (int j = y1; j <= y2; ++j) {
						    // First check leave passage information on current tiles
                            if ((map[x1, j].Access & TileAccess.LeaveWest) == TileAccess.None) {
							    goodToGo = false;
							    break;
						    }
						    // Then check enter permission on acquiring tile
                            if ((map[x1 - 1, j].Access & TileAccess.EnterEast) == TileAccess.None) {
							    goodToGo = false;
							    break;
						    }
					    }
				    } 
				    if (goodToGo) {
					    // Move
					    MoveX(-move);
				    }
			    }
			    // Try to move right
			    else if ((facing == Direction.East) && x + move < map.PixelWidth - graphics.Width) {
				    bool goodToGo = true;
				    // Test if movement crosses tile boundary
				    if (((x + 3 * (graphics.Width / 4))/ Tile.Size) != 
						    ((x + 3 * (graphics.Width / 4) + move) / Tile.Size)) {
					    // Since movement crosses boundary, check passage information				
					    for (int j = y1; j <= y2; ++j) {
						    // First check leave passage information on current tiles
                            if ((map[x2, j].Access & TileAccess.LeaveEast) == TileAccess.None) {
							    goodToGo = false;
							    break;
						    }
						    // Then check enter permission on acquiring tile
                            if ((map[x2 + 1, j].Access & TileAccess.EnterWest) == TileAccess.None) {
							    goodToGo = false;
							    break;
						    }
					    }
				    } 
				    if (goodToGo) {
					    // Move
					    MoveX(move);
				    }
			    }
		    }
        }
*/