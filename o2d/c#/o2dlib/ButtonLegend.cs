using System;
using System.Collections.Generic;
using System.Text;
using Microsoft.Xna.Framework.Graphics;
using Microsoft.Xna.Framework.Content;
using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Input;

namespace o2dlib {
    public class ButtonLegend : InterfaceElement {
        private static Texture2D buttonA;
        private static Texture2D buttonB;
        private static Texture2D buttonX;
        private static Texture2D buttonY;
        private static SpriteFont font;
        private static bool initialized = false;

        private static readonly int ButtonSize = 24;
        private static readonly int Margin = 10;
        private static readonly int MaxTextLength = 100;

        public static void Initialize(ContentManager content) {
            buttonA = content.Load<Texture2D>(@"gfx\controller\ButtonA");
            buttonB = content.Load<Texture2D>(@"gfx\controller\ButtonB");
            buttonX = content.Load<Texture2D>(@"gfx\controller\ButtonX");
            buttonY = content.Load<Texture2D>(@"gfx\controller\ButtonY");
            font = content.Load<SpriteFont>(@"fonts\ButtonText");

            initialized = true;
        }

        public ButtonLegend(Player player) : base(player) {
            if (!initialized)
                throw new InvalidOperationException("ButtonLegend must be statically initialized before use!");
        }

        override public void Render(SpriteBatch spriteBatch) {
            View view = player.View;
            int topX = view.ScreenX + view.Width - (3 * ButtonSize) - MaxTextLength - Margin;
            int topY = view.ScreenY + view.Height - (4 * ButtonSize) - Margin;
            spriteBatch.Draw(buttonY, new Rectangle(
                topX + ButtonSize,
                topY,
                ButtonSize, ButtonSize), Color.White
            );
            spriteBatch.Draw(buttonX, new Rectangle(
                topX,
                topY + ButtonSize,
                ButtonSize, ButtonSize), Color.White
            );
            spriteBatch.Draw(buttonB, new Rectangle(
                topX + (2 * ButtonSize),
                topY + ButtonSize,
                ButtonSize, ButtonSize), Color.White
            );
            spriteBatch.Draw(buttonA, new Rectangle(
                topX + ButtonSize,
                topY + (2 * ButtonSize),
                ButtonSize, ButtonSize), Color.White
            );

            Vector2 textStats;
            int x;
            int y;

            bool alreadyStarted = true;
            try {
                spriteBatch.End();
            } catch (InvalidOperationException) {
                alreadyStarted = false;
            }

            spriteBatch.Begin(SpriteBlendMode.AlphaBlend, SpriteSortMode.Immediate, SaveStateMode.None);

            if (player[Buttons.A] != null) {
                textStats = font.MeasureString(player[Buttons.A].Name);
                x = topX + ButtonSize + ((ButtonSize - (int)textStats.X) / 2);
                y = topY + (3 * ButtonSize);

                drawText(player[Buttons.A].Name, font, x, y, spriteBatch);
            }

            if (player[Buttons.Y] != null) {
                textStats = font.MeasureString(player[Buttons.Y].Name);
                x = topX + ButtonSize + ((ButtonSize - (int)textStats.X) / 2);
                y = topY - ButtonSize;

                drawText(player[Buttons.Y].Name, font, x, y, spriteBatch);
            }

            if (player[Buttons.X] != null) {
                textStats = font.MeasureString(player[Buttons.X].Name);
                x = topX - (int)textStats.X;
                y = topY + ButtonSize;

                drawText(player[Buttons.X].Name, font, x, y, spriteBatch);
            }

            if (player[Buttons.B] != null) {
                x = topX + (3 * ButtonSize) + Margin;
                y = topY + ButtonSize;

                drawText(player[Buttons.B].Name, font, x, y, spriteBatch);
            }

            spriteBatch.End();

            if (alreadyStarted)
                spriteBatch.Begin(SpriteBlendMode.AlphaBlend, SpriteSortMode.BackToFront, SaveStateMode.None);
        }
    }
}