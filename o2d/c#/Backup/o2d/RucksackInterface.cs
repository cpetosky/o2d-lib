using System;
using System.Collections.Generic;
using System.Text;
using Microsoft.Xna.Framework.Graphics;
using Microsoft.Xna.Framework.Content;

namespace o2d {
    class RucksackInterface : InterfaceElement {

        private static bool initialized = false;
        private static SpriteFont font;

        private static readonly int TextHeight = 18;
        private static readonly int Margin = 10;
        private static readonly int MaxTextLength = 60;
        private static readonly int MaxNameLength = 90;

        public static void Initialize(ContentManager content) {
            font = content.Load<SpriteFont>(@"fonts\RucksackText");

            initialized = true;
        }
        public RucksackInterface(Player player) : base(player) {
            if (!initialized)
                throw new InvalidOperationException("Rucksack must be statically initialized before use!");
        }

        override public void Render(SpriteBatch spriteBatch) {
            View view = player.View;

            int x = view.ScreenX + view.Width - MaxTextLength - MaxNameLength - Margin;
            int y = view.ScreenY + Margin;

            bool alreadyStarted = true;
            try {
                spriteBatch.End();
            } catch (InvalidOperationException e) {
                alreadyStarted = false;
            }

            spriteBatch.Begin(SpriteBlendMode.AlphaBlend, SpriteSortMode.Immediate, SaveStateMode.None);

            foreach (Resource resource in player.Resources) {
                drawText(resource.Type + ": ", font, x, y, spriteBatch);
                drawText(resource.Quantity.ToString(), font, x + MaxNameLength, y, spriteBatch);
                y += Margin + TextHeight;
            }

            spriteBatch.End();

            if (alreadyStarted)
                spriteBatch.Begin(SpriteBlendMode.AlphaBlend, SpriteSortMode.BackToFront, SaveStateMode.None);
        }

    }
}