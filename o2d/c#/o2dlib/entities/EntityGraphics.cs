using System;
using System.Collections.Generic;
using System.Text;
using Microsoft.Xna.Framework.Graphics;
using Microsoft.Xna.Framework.Content;

namespace o2dlib {
    public class EntityGraphics {
        private int id;
        private int width;
        private int height;
        private int frames;
        private string image;
        private string[] modes;

        private Texture2D texture;

        public EntityGraphics(ContentReader reader) {
            id = reader.ReadInt32();
            width = reader.ReadInt32();
            height = reader.ReadInt32();
            frames = reader.ReadInt32();
            image = reader.ReadString();

            texture = reader.ContentManager.Load<Texture2D>(@"gfx\entities\" + image);

            modes = new string[texture.Height / height];
            for (int i = 0; i < modes.Length; ++i)
                modes[i] = reader.ReadString();
        }

        public int Frames {
            get { return frames; }
        }

        public int Width {
            get { return width; }
        }

        public int Height {
            get { return height; }
        }

        public Texture2D Texture {
            get { return texture; }
        }
    }
}