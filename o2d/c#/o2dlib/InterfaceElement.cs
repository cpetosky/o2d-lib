using System;
using System.Collections.Generic;
using System.Text;
using Microsoft.Xna.Framework.Graphics;
using Microsoft.Xna.Framework;

namespace o2dlib {
    public abstract class InterfaceElement {
        protected Player player;

        protected InterfaceElement(Player player) {
            this.player = player;
        }

        public abstract void Render(SpriteBatch spriteBatch);

        protected static void drawText(string text, SpriteFont font, int x, int y, SpriteBatch spriteBatch) {
            spriteBatch.DrawString(font, text, new Vector2(x - 1, y), Color.White);
            spriteBatch.DrawString(font, text, new Vector2(x, y - 1), Color.White);
            spriteBatch.DrawString(font, text, new Vector2(x + 1, y), Color.White);
            spriteBatch.DrawString(font, text, new Vector2(x, y + 1), Color.White);
            spriteBatch.DrawString(font, text, new Vector2(x, y), Color.Black);
        }
    }
}
