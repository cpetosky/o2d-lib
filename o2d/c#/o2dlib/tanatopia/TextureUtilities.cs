using System;
using System.Collections.Generic;
using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Audio;
using Microsoft.Xna.Framework.Graphics;
using Microsoft.Xna.Framework.Input;
using Microsoft.Xna.Framework.Storage;
using Microsoft.Xna.Framework.Content;

namespace net.tanatopia {
    public class TextureUtilities {
        public static void blit(Texture2D src, Rectangle srcRect, Texture2D dest, Rectangle destRect) {
            int count = srcRect.Width * srcRect.Height;
            uint[] data = new uint[count];
            src.GetData<uint>(0, srcRect, data, 0, count);
            dest.SetData<uint>(0, destRect, data, 0, count, SetDataOptions.None);
        }
    }
}