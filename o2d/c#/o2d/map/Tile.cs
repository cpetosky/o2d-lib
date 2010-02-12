//using System;
//using System.Collections.Generic;
//using System.Text;
//using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;
using System;
using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Content;

namespace o2d.map {

    /// <summary>
    /// TileAccess flags control from which directions an entity can enter and leave
    /// a tile.
    /// </summary>
    [Flags]
    public enum TileAccess : byte {
        None       = 0x00,
        EnterWest  = 0x01,
        EnterNorth = 0x02,
        EnterEast  = 0x04,
        EnterSouth = 0x08,
        LeaveWest  = 0x10,
        LeaveNorth = 0x20,
        LeaveEast  = 0x40,
        LeaveSouth = 0x80,
        All        = 0xff
    }

    public enum TileType {
        Static,
        StaticAnimated,
        Dynamic,
        DynamicAnimated,
        Blank
    }

    [Flags]
    public enum TileBorder : byte {
        None    = 0x00,
        Up      = 0x01,
        Right   = 0x02,
        Down    = 0x04,
        Left    = 0x08,
        All     = 0x0F
    }

    public struct TileInfo {
        public int ID;
        public string Name;
        public int Priority;
        public TileAccess Access;
        public Texture2D Texture;

        public TileInfo(int id, string name, int priority, TileAccess access, ContentManager content) {
            ID = id;
            Name = name;
            Priority = priority;
            Access = access;
            Texture = null;
            if (!Blank)
                Texture = content.Load<Texture2D>(@"gfx\textures\" + name);

        }

        public bool Blank {
            get { return Name == "{!BLANK!}"; }
        }

        public int Frames {
            get {
                if (Texture.Height > Tile.Size) { // Dynamic Texture
                    return Texture.Width / (Tile.Size * 3);
                } else { // Static Texture
                    return Texture.Width / Tile.Size;
                }
            }
        }

        public TileType Type {
            get {
                if (Blank)
                    return TileType.Blank;
                if (Texture.Height > Tile.Size) // Dynamic Texture
                    if (Frames == 1)
                        return TileType.Dynamic;
                    else
                        return TileType.DynamicAnimated;
                else // Static Texture
                    if (Frames == 1)
                        return TileType.Static;
                    else
                        return TileType.StaticAnimated;
            }
        }
    }


    public class Tile {
        public static readonly int Size = 32;

        private static readonly Vector2 origin = new Vector2(0, 0);
        private Palette palette;
        private TileInfo info;
        private Point tileLoc;

        public Tile(Palette palette, TileInfo info, Point tileLoc) {
            this.palette = palette;
            this.info = info;
            this.tileLoc = tileLoc;
        }

        public int ID {
            get { return info.ID; }
        }

        public int Frames {
            get {
                return info.Frames;
            }
        }

        public bool Animated {
            get {
                return info.Frames > 1;
            }
        }

        public TileAccess Access {
            get { return info.Access; }
        }

        public int Priority {
            get { return info.Priority; }
        }

        public float ZIndex(int layer) {
            return Math.Abs(1.0f - ((float)(Priority * Map.Layers + layer) / (float)(Map.Priorities * Map.Layers)));
        }

        private void Blit(SpriteBatch sb, Rectangle src, Rectangle dest, int layer) {
            
            sb.Draw(palette.Atlas, dest, src, Color.White, 0, origin, SpriteEffects.None, ZIndex(layer));
        }
        
        public void Blit(SpriteBatch sb, int neighbors, int frame, int layer, int dX, int dY, View view) {
            Rectangle src = new Rectangle();
            int xOffset = 0;
            int yOffset = 0;

            if (dX < 0)
                xOffset = -dX;
            else if ((dX + Size) > view.Width)
                xOffset = view.Width - (dX + Size);

            if (dY < 0)
                yOffset = -dY;
            else if (dY + Size > view.Height)
                yOffset = view.Height - (dY + Size);

            Rectangle dest = new Rectangle(
                dX + view.ScreenX,
                dY + view.ScreenY,
                Size - Math.Abs(xOffset),
                Size - Math.Abs(yOffset)
            );
            if (xOffset < 0)
                xOffset = 0;
            if (yOffset < 0)
                yOffset = 0;

            dest.X += xOffset;
            dest.Y += yOffset;
            src.Width = dest.Width;
            src.Height = dest.Height;

            

            switch (info.Type) {
                case TileType.Static:
                    src.X = tileLoc.X * Size + xOffset;
                    src.Y = tileLoc.Y * Size + yOffset;
                    break;
                case TileType.StaticAnimated:
                    src.X = (tileLoc.X + frame % Frames) * Size + xOffset;
                    src.Y = tileLoc.Y * Size + yOffset;
                    break;
                case TileType.Dynamic:
                    src.X = (tileLoc.X + neighbors) * Size + xOffset;
                    src.Y = tileLoc.Y * Size + yOffset;
                    break;
                case TileType.DynamicAnimated:
                    src.X = (tileLoc.X + neighbors) * Size + xOffset;
                    src.Y = (tileLoc.Y + frame % Frames) * Size + yOffset;
                    break;
            }
            Blit(sb, src, dest, layer);
        }
    }
}
