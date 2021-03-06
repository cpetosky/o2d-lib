using System;
using System.Collections.Generic;
using System.Text;
using Microsoft.Xna.Framework.Content;
using Microsoft.Xna.Framework.Graphics;
using Microsoft.Xna.Framework;

namespace o2d.map.readers {
    class PaletteReader : ContentTypeReader<Palette> {
        protected override Palette Read(ContentReader input, Palette existingInstance) {
            return new Palette(input, MainGame.GraphicsDevice);
        }
    }
}