using System;
using System.Collections.Generic;
using System.Text;
using Microsoft.Xna.Framework.Graphics;
using Microsoft.Xna.Framework;

namespace net.tanatopia {
        
    public class Drawer {
        private Texture2D dot;
        private SpriteBatch spriteBatch;

        public Drawer(GraphicsDevice device, SpriteBatch sb) {
            spriteBatch = sb;

            // initialize the dot
            dot = new Texture2D(device, 1, 1, 0, TextureUsage.None, SurfaceFormat.Rgba32);
            //dot = new Texture2D(device, 1, 1, 0, TextureUsage.None, SurfaceFormat.Color);
            uint[] data = new uint[1];
            data[0] = Color.White.PackedValue;
            dot.SetData<uint>(data);
        }

        public void drawRectangle(int x, int y, int width, int height, Color color) {
            spriteBatch.Draw(dot, new Rectangle(x, y, width, height), color);
        }
    }
}