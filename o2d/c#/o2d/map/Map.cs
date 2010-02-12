using System;
using System.Collections.Generic;
using System.Text;
using Microsoft.Xna.Framework.Graphics;
using Microsoft.Xna.Framework;
using System.Xml;
using Microsoft.Xna.Framework.Content;
using o2d.entity;

namespace o2d.map {
    public class Map {
        public static readonly uint Layers = 3;
        public static readonly uint Priorities = 6;

        private int width;
        private int height;

        private Palette palette;

        private Region[,] regions;
        private Tile[,,] tiles;
        private int[,,] neighbors;

        private int frame = 0;
        private double zoom = 1.0;

        private string name;
        private int id;

        private bool alreadyProcessed = false;

        private Dictionary<uint, Entity> entities;

        private int frameCounter = 0;

        public struct LogicalTile {
            Tile[] tiles;
            Region region;

            public LogicalTile(Tile[] tiles, Region region) {
                this.tiles = tiles;
                this.region = region;
            }

            public TileAccess Access {
                get {
                    // Look for tile and return passage of highest tile on lowest priority.
                    bool first = true;
                    TileAccess passage = TileAccess.None;
                    Tile tile = null;
                    for (int layer = 0; layer < Layers; ++layer) {
                        if (tiles[layer] != null) {
                            if (first) {
                                passage = tiles[layer].Access;
                                first = false;
                            } else {
                                if (tile.Priority == tiles[layer].Priority)
                                    passage = tiles[layer].Access;
                                else
                                    passage &= tiles[layer].Access;
                            }
                            tile = tiles[layer];
                        }
                    }

                    return passage;
                }
            }

            public Region Region {
                get { return region; }
            }
        }

        #region Constructors

        private static readonly int OceanBuffer = 10;
        private static readonly int DimensionThreshold = 16;
        private static readonly int MinimumDimension = DimensionThreshold / 2;
        public Map(Palette palette, int width, int height) {
            this.id = 0;
            this.palette = palette;
            this.width = width;
            this.height = height;
            this.name = "o2d random map";

            entities = new Dictionary<uint, Entity>();

            Queue<Rectangle> regionQ = new Queue<Rectangle>();
            List<Rectangle> regionList = new List<Rectangle>();
            regionQ.Enqueue(new Rectangle(OceanBuffer, OceanBuffer, width - (OceanBuffer << 1), height - (OceanBuffer << 1)));

            Random rand = new Random();
            while (regionQ.Count > 0) {
                Rectangle r1 = regionQ.Dequeue();
                Rectangle r2;
                if (rand.Next(0, 2) == 0) {
                    if (r1.Width < DimensionThreshold) {
                        regionList.Add(r1);
                        continue;
                    }
                    int slice = rand.Next(MinimumDimension, r1.Width - MinimumDimension);
                    r2 = new Rectangle(r1.X + slice, r1.Y, r1.Width - slice, r1.Height);
                    r1.Width = slice;
                } else {
                    if (r1.Height < DimensionThreshold) {
                        regionList.Add(r1);
                        continue;
                    }
                    int slice = rand.Next(MinimumDimension, r1.Height - MinimumDimension);
                    r2 = new Rectangle(r1.X, r1.Y + slice, r1.Width, r1.Height - slice);
                    r1.Height = slice;
                }

                if (Math.Max(r1.Width, r1.Height) >= DimensionThreshold)
                    regionQ.Enqueue(r1);
                else
                    regionList.Add(r1);

                if (Math.Max(r2.Width, r2.Height) >= DimensionThreshold)
                    regionQ.Enqueue(r2);
                else
                    regionList.Add(r2);
            }
            tiles = new Tile[width, height, Layers];
            regions = new Region[width, height];
            foreach (Rectangle regionSpace in regionList) {
                int regionType = rand.Next(0, 4);
                Region region = new Region((RegionType)regionType, regionSpace);

                int maxX = regionSpace.X + regionSpace.Width;
                int maxY = regionSpace.Y + regionSpace.Height;
                for (int i = regionSpace.X; i < maxX; ++i)
                    for (int j = regionSpace.Y; j < maxY; ++j) {
                        tiles[i, j, 0] = palette[regionType];
                        regions[i, j] = region;
                    }
            }

            for (int i = 0; i < width; ++i) {
                for (int j = 0; j < height; ++j) {
                    if (j == OceanBuffer && i >= OceanBuffer && i < width - OceanBuffer)
                        j = height - OceanBuffer;
                    tiles[i, j, 0] = palette[4];
                }
            }

            InitializeNeighbors();
        }

        public Map(int id, Palette palette, int width, int height, string name) {
            this.id = id;
            this.palette = palette;
            this.width = width;
            this.height = height;
            this.name = name;

            entities = new Dictionary<uint, Entity>();
            tiles = new Tile[width, height, Layers];
            for (int i = 0; i < width; ++i)
                for (int j = 0; j < height; ++j)
                    for (int l = 0; l < Layers; ++l)
                        tiles[i, j, l] = (l == 0 ? palette.DefaultTile : null);
        }

        #endregion

        public void InitializeNeighbors() {
            neighbors = new int[width, height, Layers];
            for (int i = 0; i < width; ++i)
                for (int j = 0; j < height; ++j)
                    for (int l = 0; l < Layers; ++l)
                        neighbors[i, j, l] = getNeighborProfile(i, j, l);

        }

        #region Indexers

        public LogicalTile this[int i, int j] {
            get {
                return this[(uint)i, (uint)j];
            }
        }

        public LogicalTile this[uint i, uint j] {
            get {
                Tile[] tiles = new Tile[Layers];
                for (int l = 0; l < Layers; ++l)
                    tiles[l] = this.tiles[i, j, l];
                return new LogicalTile(tiles, regions[i, j]);
            }
        }

        /// <summary>
        /// Get the tile at the location and layer.
        /// </summary>
        /// <param name="i">x-coordinate</param>
        /// <param name="j">y-coordinate</param>
        /// <param name="l">layer</param>
        /// <returns>Tile at this location, or null if location is empty</returns>
        public Tile this[int i, int j, int l] {
            get {
                return tiles[i, j, l];
            }
            set {
                tiles[i, j, l] = value;
            }
        }

        #endregion

        #region Properties

        public int ID {
            get { return id; }
        }

        /// <summary>
        /// The width of the map, in tiles.
        /// </summary>
        public int Width {
            get { return width; }
        }

        /// <summary>
        /// The height of the map, in tiles.
        /// </summary>
        public int Height {
            get { return height; }
        }

        public int PixelWidth {
            get { return Tile.Size * width; }
        }

        public int PixelHeight {
            get { return Tile.Size * height; }
        }

        public string Name {
            get { return name; }
        }

        public double Zoom {
            get { return zoom; }
            set { zoom = value; }
        }

        public Palette Palette {
            get { return palette; }
        }

        public bool AlreadyProcessed {
            get { return alreadyProcessed; }
            set { alreadyProcessed = value; }
        }

        #endregion

        public void PassTime(int delta) {
            if (alreadyProcessed) return;
            alreadyProcessed = true;
            frameCounter += delta;
            while (frameCounter > 400) {
                frameCounter -= 400;
                NextFrame();
            }

            foreach (Entity e in entities.Values) {
                e.PassTime(delta);
                e.Move(delta);

                // Animation
                if (!e.Animating && e.Moving)
                    e.StartAnimation(175);
                else if (e.Animating && !e.Moving)
                    e.StopAnimation();
            }
        }
        public void NextFrame() {
            frame = (frame + 1) % 4;
        }

        public void AddEntity(Entity e) {
            entities.Add(e.ID, e);
        }

        public void RemoveEntity(Entity e) {
            entities.Remove(e.ID);
        }


        #region Rendering

        public void Render(SpriteBatch sb, View view) {
		    int xStart = -(view.X % Tile.Size);
		    int yStart = -(view.Y % Tile.Size);
		    int iTileStart = view.X / Tile.Size;
		    int jTileStart = view.Y / Tile.Size;
    		
		    for (int layer = 0; layer < Layers; ++layer) {
			    int i = iTileStart;
			    for (int x = xStart; x < view.Width && i < width; x += Tile.Size) {
				    int j = jTileStart;
				    for (int y = yStart; y < view.Height && j < height; y += Tile.Size) {
					    if (tiles[i, j, layer] != null) {
                            tiles[i, j, layer].Blit(
                                sb, 
                                neighbors[i, j, layer],
                                frame,
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
            foreach (Entity e in entities.Values) {
                e.Render(sb, view);
            }
        }

        private int getNeighborProfile(int i, int j, int layer) {
            Tile[] nearby = getNearbyTiles(this, i, j, layer);

            TileBorder borders = TileBorder.None;
            Tile tile = tiles[i, j, layer];
            if (nearby[3] == tile)
                borders |= TileBorder.Left;

            if (nearby[5] == tile)
                borders |= TileBorder.Right;

            if (nearby[1] == tile)
                borders |= TileBorder.Up;

            if (nearby[7] == tile)
                borders |= TileBorder.Down;

            int n;
            switch (borders) {
                // No border case -- default tile
                // No inside corner checks
                case TileBorder.None:
                    return 0;

                // Dead end cases -- corner tile + extra corner tile
                // No inside corner checks.
                case TileBorder.Left:
                    return 1;

                case TileBorder.Right:
                    return 2;

                case TileBorder.Up:
                    return 3;

                case TileBorder.Down:
                    return 4;

                // Elbow cases -- corner tile
                // Gotta check for the inside corner!
                case TileBorder.Left | TileBorder.Up:
                    if (checkNWCorner(tile, nearby))
                        return 6;
                    return 5;

                case TileBorder.Up | TileBorder.Right:
                    if (checkNECorner(tile, nearby))
                        return 8;
                    return 7;

                case TileBorder.Right | TileBorder.Down:
                    if (checkSECorner(tile, nearby))
                        return 10;
                    return 9;

                case TileBorder.Down | TileBorder.Left:
                    if (checkSWCorner(tile, nearby))
                        return 12;
                    return 11;

                // Row/column cases -- side + opposite side
                // No inside corner checks.
                case TileBorder.Up | TileBorder.Down:
                    return 13;

                case TileBorder.Left | TileBorder.Right:
                    return 14;

                // T cases -- side tile
                // Gotta check for both inside corners!
                case TileBorder.Left | TileBorder.Up | TileBorder.Right:
                    n = 15;
                    if (checkNWCorner(tile, nearby))
                        n += 1;
                    if (checkNECorner(tile, nearby))
                        n += 2;
                    return n;

                case TileBorder.Up | TileBorder.Right | TileBorder.Down:
                    n = 19;
                    if (checkNECorner(tile, nearby))
                        n += 1;
                    if (checkSECorner(tile, nearby))
                        n += 2;
                    return n;

                case TileBorder.Right | TileBorder.Down | TileBorder.Left:
                    n = 23;
                    if (checkSWCorner(tile, nearby))
                        n += 1;
                    if (checkSECorner(tile, nearby))
                        n += 2;
                    return n;

                case TileBorder.Down | TileBorder.Left | TileBorder.Up:
                    n = 27;
                    if (checkNWCorner(tile, nearby))
                        n += 1;
                    if (checkSWCorner(tile, nearby))
                        n += 2;
                    return n;

                // Middle case -- middle tile
                // Gotta check for every inside corner!
                case TileBorder.Left | TileBorder.Up | TileBorder.Right | TileBorder.Down:
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

        public static Tile[] getNearbyTiles(Map m, int i, int j, int layer) {
            Tile[] nearby = new Tile[9];
            int count = 0;
            for (int y = j - 1; y <= j + 1; ++y) {
                for (int x = i - 1; x <= i + 1; ++x) {
                    if (x >= 0 && y >= 0 && x < m.width && y < m.height)
                        nearby[count] = m.tiles[x, y, layer];
                    else
                        nearby[count] = m.tiles[i, j, layer];
                    ++count;
                }
            }
            return nearby;
        }

        public static bool checkNWCorner(Tile tile, Tile[] nearby) {
		    return nearby[0] != tile;	
	    }
    	
	    public static bool checkNECorner(Tile tile, Tile[] nearby) {
		    return nearby[2] != tile;	
	    }
    	
	    public static bool checkSWCorner(Tile tile, Tile[] nearby) {
		    return nearby[6] != tile;	
	    }

        public static bool checkSECorner(Tile tile, Tile[] nearby) {
		    return nearby[8] != tile;		
	    }

        #endregion
    }
}
