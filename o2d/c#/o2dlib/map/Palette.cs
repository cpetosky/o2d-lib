using System;
using System.Collections.Generic;
using System.Text;
using Microsoft.Xna.Framework.Graphics;
using System.Xml;
using Microsoft.Xna.Framework.Content;
using Microsoft.Xna.Framework;
using net.tanatopia;
using System.Collections;
using System.IO;

namespace o2dlib {
    public class Palette : IData {

        private string name;
        private int id;
        private List<TileInfo> tileInfos;

        private GraphicsDevice graphicsDevice;

        // Generated from tileInfos
        private Tile[] tiles;
        private Texture2D atlas;


        public Palette() {
       
        }

        void IData.Initialize() {
            tileInfos = new List<TileInfo>();
        }

        public void Serialize(BinaryWriter writer) {

        }

        public Palette(ContentReader reader, GraphicsDevice graphicsDevice) {
            this.graphicsDevice = graphicsDevice;
            id = reader.ReadInt32();
            name = reader.ReadString();
            int size = reader.ReadInt32();

            tileInfos = new List<TileInfo>(size);

            for (int i = 0; i < size; ++i) {
                tileInfos.Add(new TileInfo(
                    i,
                    reader.ReadString(),
                    reader.ReadInt32(),
                    (TileAccess)reader.ReadInt32(),
                    reader.ContentManager
                ));
            }

            RegenerateTextures();
        }

        public void AddTile(TileInfo info) {
            tileInfos.Add(info);

            RegenerateTextures();
        }

        public GraphicsDevice GraphicsDevice {
            get {
                return graphicsDevice;
            }

            set {
                graphicsDevice = value;
            }
        }

        public void Render(SpriteBatch sb, View view) {
            int xStart = -(view.X % Tile.Size);
            int yStart = -(view.Y % Tile.Size);
            int iTileStart = view.X / Tile.Size;
            int jTileStart = view.Y / Tile.Size;

            int i = iTileStart;
            int width = 8;
            int height = Size / width + 1;

            for (int x = xStart; x < view.Width && i < width; x += Tile.Size) {
                int j = jTileStart;
                for (int y = yStart; y < view.Height && j < height; y += Tile.Size) {
                    if (tiles[i + j / 8] != null) {
                        tiles[i + j / 8].Blit(
                            sb,
                            0,
                            0,
                            0,
                            x, y,
                            view
                        );
                    }
                    ++j;
                }
                ++i;
            }

        }

        #region Atlas Generation

        public void RegenerateTextures() {
            List<TileInfo> dynamicTiles = new List<TileInfo>();
            List<TileInfo> staticTiles = new List<TileInfo>();
            List<TileInfo> staticAnimatedTiles = new List<TileInfo>();

            tiles = new Tile[tileInfos.Count];

            foreach (TileInfo info in tileInfos) {
                if (info.Blank)
                    continue;

                switch (info.Type) {
                    case TileType.Dynamic:
                    case TileType.DynamicAnimated:
                        dynamicTiles.Add(info);
                        break;
                    case TileType.Static:
                        staticTiles.Add(info);
                        break;
                    case TileType.StaticAnimated:
                        staticAnimatedTiles.Add(info);
                        break;
                }
            }

            // Create ubertexture.
            int totalFrames = 0;
            dynamicTiles.ForEach(info => totalFrames += info.Frames);
            CreateAtlas(totalFrames, staticAnimatedTiles.Count, staticTiles.Count);

            ProcessDynamicTiles(dynamicTiles);
            ProcessStaticTiles(staticTiles, staticAnimatedTiles);
        }

        private void ProcessStaticTiles(List<TileInfo> staticTiles, List<TileInfo> staticAnimatedTiles) {
            const int StaticOffset = 48;
            const int StaticWidth = 16;

            int x = 0;
            int y = 0;

            foreach (TileInfo info in staticAnimatedTiles) {
                Point p = new Point(x + StaticOffset, y);
                x += 4;
                if (x >= StaticWidth) {
                    x = 0;
                    ++y;
                }

                Rectangle srcRect = new Rectangle(0, 0, Tile.Size * 4, Tile.Size);
                Rectangle destRect = new Rectangle(
                    p.X * Tile.Size,
                    p.Y * Tile.Size,
                    Tile.Size * 4, Tile.Size);
                TextureUtilities.blit(info.Texture, srcRect, atlas, destRect);

                tiles[info.ID] = new Tile(this, info, p);
            }

            if (x != 0) {
                x = 0;
                ++y;
            }

            foreach (TileInfo info in staticTiles) {
                Point p = new Point(x + StaticOffset, y);
                ++x;
                
                if (x >= StaticWidth) {
                    x = 0;
                    ++y;
                }

                Rectangle srcRect = new Rectangle(0, 0, Tile.Size, Tile.Size);
                Rectangle destRect = new Rectangle(
                    p.X * Tile.Size,
                    p.Y * Tile.Size,
                    Tile.Size, Tile.Size);
                
                TextureUtilities.blit(info.Texture, srcRect, atlas, destRect);
                tiles[info.ID] = new Tile(this, info, p);
            }

        }

        private void ProcessDynamicTiles(List<TileInfo> dynamicTiles) {
            int x = 0;
            int y = 0;
            foreach (TileInfo info in dynamicTiles) {
                Point p = new Point(x, y);
                y += info.Frames;

                tiles[info.ID] = new Tile(this, info, p);

                for (int f = 0; f < info.Frames; ++f) {
                    for (int i = 0; i < 47; ++i) {
                        BitArray flags = new BitArray(20, false);
                        if (i == 0)
                            flags[(int)DynamicPart.BaseEmpty] = true;
                        else if (i == 1)
                            flags[(int)DynamicPart.BaseNE] = flags[(int)DynamicPart.SideS] = flags[(int)DynamicPart.BendSE] = true;
                        else if (i == 2)
                            flags[(int)DynamicPart.BaseSW] = flags[(int)DynamicPart.SideN] = flags[(int)DynamicPart.BendNW] = true;
                        else if (i == 3)
                            flags[(int)DynamicPart.BaseSW] = flags[(int)DynamicPart.SideE] = flags[(int)DynamicPart.BendSE] = true;
                        else if (i == 4)
                            flags[(int)DynamicPart.BaseNE] = flags[(int)DynamicPart.SideW] = flags[(int)DynamicPart.BendNW] = true;
                        else if (i == 5)
                            flags[(int)DynamicPart.BaseSE] = true;
                        else if (i == 6)
                            flags[(int)DynamicPart.BaseSE] = flags[(int)DynamicPart.CornerNW] = true;
                        else if (i == 7)
                            flags[(int)DynamicPart.BaseSW] = true;
                        else if (i == 8)
                            flags[(int)DynamicPart.BaseSW] = flags[(int)DynamicPart.CornerNE] = true;
                        else if (i == 9)
                            flags[(int)DynamicPart.BaseNW] = true;
                        else if (i == 10)
                            flags[(int)DynamicPart.BaseNW] = flags[(int)DynamicPart.CornerSE] = true;
                        else if (i == 11)
                            flags[(int)DynamicPart.BaseNE] = true;
                        else if (i == 12)
                            flags[(int)DynamicPart.BaseNE] = flags[(int)DynamicPart.CornerSW] = true;
                        else if (i == 13)
                            flags[(int)DynamicPart.BaseW] = flags[(int)DynamicPart.SideE] = true;
                        else if (i == 14)
                            flags[(int)DynamicPart.BaseN] = flags[(int)DynamicPart.SideS] = true;
                        else if (i >= 31) {
                            int j = i - 31;
                            flags[(int)DynamicPart.BaseCenter] = true;
                            if ((j & 1) > 0)
                                flags[(int)DynamicPart.CornerNW] = true;
                            if ((j & 2) > 0)
                                flags[(int)DynamicPart.CornerNE] = true;
                            if ((j & 4) > 0)
                                flags[(int)DynamicPart.CornerSW] = true;
                            if ((j & 8) > 0)
                                flags[(int)DynamicPart.CornerSE] = true;
                        } else if (i >= 27) {
                            int j = i - 27;
                            flags[(int)DynamicPart.BaseE] = true;
                            if ((j & 1) > 0)
                                flags[(int)DynamicPart.CornerNW] = true;
                            if ((j & 2) > 0)
                                flags[(int)DynamicPart.CornerSW] = true;
                        } else if (i >= 23) {
                            int j = i - 23;
                            flags[(int)DynamicPart.BaseN] = true;
                            if ((j & 1) > 0)
                                flags[(int)DynamicPart.CornerSW] = true;
                            if ((j & 2) > 0)
                                flags[(int)DynamicPart.CornerSE] = true;
                        } else if (i >= 19) {
                            int j = i - 19;
                            flags[(int)DynamicPart.BaseW] = true;
                            if ((j & 1) > 0)
                                flags[(int)DynamicPart.CornerNE] = true;
                            if ((j & 2) > 0)
                                flags[(int)DynamicPart.CornerSE] = true;
                        } else if (i >= 15) {
                            int j = i - 15;
                            flags[(int)DynamicPart.BaseS] = true;
                            if ((j & 1) > 0)
                                flags[(int)DynamicPart.CornerNW] = true;
                            if ((j & 2) > 0)
                                flags[(int)DynamicPart.CornerNE] = true;
                        }

                        // Flags set, deal with 'em

                        Rectangle dstRect = new Rectangle(
                            (p.X + i) * Tile.Size,
                            (p.Y + f) * Tile.Size,
                            Tile.Size, Tile.Size);

                        int offset = f * Tile.Size * 3;
                        //int offset = 0;

                        if (flags[(int)DynamicPart.BaseEmpty]) {
                            addBase(info.Texture, dstRect, offset, 0);
                        }

                        if (flags[(int)DynamicPart.BaseCenter]) {
                            addBase(info.Texture, dstRect, offset + Tile.Size, 2 * Tile.Size);
                        }

                        if (flags[(int)DynamicPart.BaseNW]) {
                            addBase(info.Texture, dstRect, offset, Tile.Size);
                        }

                        if (flags[(int)DynamicPart.BaseN]) {
                            addBase(info.Texture, dstRect, offset + Tile.Size, Tile.Size);
                        }

                        if (flags[(int)DynamicPart.BaseNE]) {
                            addBase(info.Texture, dstRect, offset + Tile.Size + Tile.Size, Tile.Size);
                        }

                        if (flags[(int)DynamicPart.BaseW]) {
                            addBase(info.Texture, dstRect, offset, 2 * Tile.Size);
                        }

                        if (flags[(int)DynamicPart.BaseE]) {
                            addBase(info.Texture, dstRect, offset + Tile.Size + Tile.Size, Tile.Size + Tile.Size);
                        }

                        if (flags[(int)DynamicPart.BaseSW]) {
                            addBase(info.Texture, dstRect, offset, Tile.Size + Tile.Size + Tile.Size);
                        }

                        if (flags[(int)DynamicPart.BaseS]) {
                            addBase(info.Texture, dstRect, offset + Tile.Size, Tile.Size + Tile.Size + Tile.Size);
                        }

                        if (flags[(int)DynamicPart.BaseSE]) {
                            addBase(info.Texture, dstRect, offset + Tile.Size + Tile.Size, Tile.Size + Tile.Size + Tile.Size);
                        }

                        if (flags[(int)DynamicPart.SideW]) {
                            addSide(info.Texture, dstRect, 0, 0, offset, Tile.Size * 2, SliceType.Vertical);
                        }

                        if (flags[(int)DynamicPart.SideN]) {
                            addSide(info.Texture, dstRect, 0, 0, offset + Tile.Size, Tile.Size, SliceType.Horizontal);
                        }

                        if (flags[(int)DynamicPart.SideE]) {
                            addSide(info.Texture, dstRect, Tile.Size / 2, 0,
                                offset + 2 * Tile.Size + Tile.Size / 2, 2 * Tile.Size, SliceType.Vertical);
                        }

                        if (flags[(int)DynamicPart.SideS]) {
                            addSide(info.Texture, dstRect, 0, Tile.Size / 2,
                                    offset + Tile.Size, 3 * Tile.Size + Tile.Size / 2, SliceType.Horizontal);
                        }

                        if (flags[(int)DynamicPart.BendNW]) {
                            addBend(info.Texture, dstRect, offset, Tile.Size);
                        }

                        if (flags[(int)DynamicPart.BendSE]) {
                            dstRect.X += Tile.Size / 2;
                            dstRect.Y += Tile.Size / 2;
                            addBend(info.Texture, dstRect, offset + Tile.Size * 2 + Tile.Size / 2, Tile.Size * 3 + Tile.Size / 2);
                        }

                        if (flags[(int)DynamicPart.CornerNW]) {
                            addCorner(info.Texture, dstRect, 0, 0, offset + Tile.Size * 2, 0);
                        }

                        if (flags[(int)DynamicPart.CornerNE]) {
                            addCorner(info.Texture, dstRect, Tile.Size / 2, 0, offset + Tile.Size * 2 + Tile.Size / 2, 0);
                        }

                        if (flags[(int)DynamicPart.CornerSW]) {
                            addCorner(info.Texture, dstRect, 0, Tile.Size / 2, offset + Tile.Size * 2, Tile.Size / 2);
                        }

                        if (flags[(int)DynamicPart.CornerSE]) {
                            addCorner(info.Texture, dstRect, Tile.Size / 2, Tile.Size / 2, offset + Tile.Size * 2 + Tile.Size / 2, Tile.Size / 2);
                        }
                    }
                }
            }
        }

        private void CreateAtlas(int dynamicFrames, int staticAnimatedCount, int staticCount) {
            int width = 64;
            int leftHeight = dynamicFrames;
            int rightHeight = staticAnimatedCount / 4 + staticAnimatedCount % 4 > 0 ? 1 : 0;
            rightHeight += staticCount / 16 + staticCount % 16 > 0 ? 1 : 0;

            int height = Math.Max(leftHeight, rightHeight);

            atlas = new Texture2D(
                graphicsDevice,
                width * Tile.Size,
                height * Tile.Size,
                1,
                TextureUsage.None,
                SurfaceFormat.Color
            );
        }

        private enum DynamicPart : int {
            BaseEmpty = 0, BaseCenter, BaseNW, BaseN, BaseNE, BaseW, BaseE, BaseSW, BaseS, BaseSE,
            SideN, SideW, SideS, SideE,
            BendNW, BendSE,
            CornerNW, CornerNE, CornerSW, CornerSE
        }

        private enum SliceType {
            Horizontal, Vertical
        }

        private void addSide(Texture2D src, Rectangle dstRect, int dx, int dy, int sx, int sy, SliceType st) {
		    Rectangle srcRect = new Rectangle();
		    srcRect.X = sx;
		    srcRect.Y = sy;
		    dstRect.X += dx;
		    dstRect.Y += dy;
    	
		    switch (st) {
		        case SliceType.Horizontal:
			        srcRect.Width = dstRect.Width = Tile.Size;
			        srcRect.Height = dstRect.Height = Tile.Size / 2;
			        TextureUtilities.blit(src, srcRect, atlas, dstRect);
			        break;
		        case SliceType.Vertical:
			        srcRect.Width = dstRect.Width = Tile.Size / 2;
			        srcRect.Height = dstRect.Height = Tile.Size;
                    TextureUtilities.blit(src, srcRect, atlas, dstRect);
			        break;
		    }
	    }
	
	    private void addCorner(Texture2D src, Rectangle dstRect, int dx, int dy, int sx, int sy) {
            Rectangle srcRect = new Rectangle();
		    srcRect.X = sx;
		    srcRect.Y = sy;
		    srcRect.Width = srcRect.Height = dstRect.Width = dstRect.Height = Tile.Size / 2;
		    dstRect.X += dx;
		    dstRect.Y += dy;
            TextureUtilities.blit(src, srcRect, atlas, dstRect);
	    }

        private void addBase(Texture2D src, Rectangle dstRect, int sx, int sy) {
            Rectangle srcRect = new Rectangle();
		    srcRect.X = sx;
		    srcRect.Y = sy;
		    srcRect.Width = srcRect.Height = Tile.Size;
		    TextureUtilities.blit(src, srcRect, atlas, dstRect);
	    }

        private void addBend(Texture2D src, Rectangle dstRect, int sx, int sy) {
            Rectangle srcRect = new Rectangle();
		    srcRect.X = sx;
		    srcRect.Y = sy;
		    srcRect.Width = srcRect.Height = dstRect.Width = dstRect.Height = Tile.Size / 2;
		    TextureUtilities.blit(src, srcRect, atlas, dstRect);
        }

        #endregion

        #region Indexers

        public Tile this[int i] {
            get {
                if (i >= 0 && i < tiles.Length)
                    return tiles[i];
                else
                    return null;
            }
        }

        #endregion

        #region Properties

        public int ID {
            get { return id; }
            set { id = value; }
        }

        public string Name {
            get { return name; }
            set { name = value; }
        }

        public Tile DefaultTile {
            get { return tiles.Length > 0 ? tiles[0] : null; }
        }

        public Texture2D Atlas {
            get { return atlas; }
        }

        public int Size {
            get { return tiles.Length; }
        }

        #endregion



    }
}
