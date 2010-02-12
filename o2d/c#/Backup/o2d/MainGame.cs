#region Using Statements
using System;
using System.Collections.Generic;
using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Audio;
using Microsoft.Xna.Framework.Content;
using Microsoft.Xna.Framework.Graphics;
using Microsoft.Xna.Framework.Input;
using Microsoft.Xna.Framework.Storage;
using System.IO;
using net.tanatopia;
using o2d.map;
using o2d.entity;
#endregion

namespace o2d {
    /// <summary>
    /// This is the main type for your game
    /// </summary>
    public class MainGame : Game {
	    private readonly int MoveRate = 120;
	    private readonly int AnimateRate = 175;

        static GraphicsDeviceManager graphics;
        SpriteBatch spriteBatch;

        private List<Player> players;

        private ToggleState showDebugInfo;
        private ToggleState showGrid;
        private ToggleState pause;

        private SpriteFont debugFont;
        private Drawer drawer;

        public static GraphicsDevice GraphicsDevice {
            get { return graphics.GraphicsDevice; }
        }

        public MainGame() {
            graphics = new GraphicsDeviceManager(this);
            Content.RootDirectory = @"Content\Content";

            graphics.IsFullScreen = true;

            // Render at 720p.
            graphics.PreferredBackBufferWidth = 1280;
            graphics.PreferredBackBufferHeight = 720;
            graphics.PreferMultiSampling = false;
            graphics.SynchronizeWithVerticalRetrace = false;
            IsFixedTimeStep = false;
        }


        /// <summary>
        /// Allows the game to perform any initialization it needs to before starting to run.
        /// This is where it can query for any required services and load any non-graphic
        /// related content.  Calling base.Initialize will enumerate through any components
        /// and initialize them as well.
        /// </summary>
        protected override void Initialize() {
            ButtonLegend.Initialize(Content);
            RucksackInterface.Initialize(Content);

            // Build random map
            Palette p = Content.Load<Palette>(@"palette\00001");
            Map map = new Map(p, 160, 90);
            
            players = new List<Player>();

            int numPlayers = (GamePad.GetState(PlayerIndex.One).IsConnected ? 1 : 0) +
                (GamePad.GetState(PlayerIndex.Two).IsConnected ? 1 : 0) +
                (GamePad.GetState(PlayerIndex.Three).IsConnected ? 1 : 0) +
                (GamePad.GetState(PlayerIndex.Four).IsConnected ? 1 : 0);

            Rectangle view;
            switch (numPlayers) {
                case 1:
                    view = new Rectangle(0, 0, graphics.PreferredBackBufferWidth,
                        graphics.PreferredBackBufferHeight);
                    break;
                case 2:
                    view = new Rectangle(0, 0, graphics.PreferredBackBufferWidth / 2,
                        graphics.PreferredBackBufferHeight);
                    break;
                case 3:
                case 4:
                    view = new Rectangle(0, 0, graphics.PreferredBackBufferWidth / 2,
                        graphics.PreferredBackBufferHeight / 2);
                    break;
                default:
                    view = default(Rectangle);
                    break;
            }

            // Always add player 1
            players.Add(new Player(
                PlayerIndex.One,
                new View(view, 0, 0),
                new Entity(Content.Load<EntityGraphics>(@"entity\00000"), map, 15, 15)
            ));

            // Conditionally add more players
            if (GamePad.GetState(PlayerIndex.Two).IsConnected)
                players.Add(new Player(
                    PlayerIndex.Two,
                    new View(view, view.Width, 0),
                    new Entity(Content.Load<EntityGraphics>(@"entity\00001"), map, 15, 20)
                ));
            if (GamePad.GetState(PlayerIndex.Three).IsConnected)
                players.Add(new Player(
                    PlayerIndex.Three,
                    new View(view, 0, view.Height),
                    new Entity(Content.Load<EntityGraphics>(@"entity\00002"), map, 20, 5)
                ));
            if (GamePad.GetState(PlayerIndex.Four).IsConnected)
                players.Add(new Player(
                    PlayerIndex.Four,
                    new View(view, view.Width, view.Height),
                    new Entity(Content.Load<EntityGraphics>(@"entity\00003"), map, 20, 20)
                ));
            base.Initialize();
        }

        /// <summary>
        /// LoadContent will be called once per game and is the place to load
        /// all of your content.
        /// </summary>
        protected override void LoadContent() {
            debugFont = Content.Load<SpriteFont>(@"fonts\DebugText");
            spriteBatch = new SpriteBatch(GraphicsDevice);
            drawer = new Drawer(GraphicsDevice, spriteBatch);

            // TODO: use this.Content to load your game content here
        }


        /// <summary>
        /// UnloadContent will be called once per game and is the place to unload
        /// all content.
        /// </summary>
        protected override void UnloadContent() {
            // TODO: Unload any non ContentManager content here
        }


        /// <summary>
        /// Allows the game to run logic such as updating the world,
        /// checking for collisions, gathering input and playing audio.
        /// </summary>
        /// <param name="gameTime">Provides a snapshot of timing values.</param>
        protected override void Update(GameTime gameTime) {
            foreach (Player p in players) {
                p.Avatar.Map.PassTime(gameTime.ElapsedRealTime.Milliseconds);
                p.Scroll();
            }
	
            // Allows the game to exit
            GamePadState gamepad = GamePad.GetState(PlayerIndex.One);
            GamePadButtons buttons = gamepad.Buttons;
            if (buttons.Back == ButtonState.Pressed)
                Exit();
            
            ButtonUtilities.TrackButtonToggle(ref showDebugInfo, buttons.LeftShoulder);
            ButtonUtilities.TrackButtonToggle(ref showGrid, buttons.RightShoulder);
            ButtonUtilities.TrackButtonToggle(ref pause, buttons.Start);

            foreach (Player p in players) {
                p.Avatar.Map.AlreadyProcessed = false;
                p.TrackInput();
            }

            base.Update(gameTime);
        }

        /// <summary>
        /// This is called when the game should draw itself.
        /// </summary>
        /// <param name="gameTime">Provides a snapshot of timing values.</param>
        protected override void Draw(GameTime gameTime) {
            if (pause.Off) {
                spriteBatch.Begin(SpriteBlendMode.AlphaBlend, SpriteSortMode.BackToFront, SaveStateMode.None);

                foreach (Player p in players)
                    p.RenderView(spriteBatch);

                if (showDebugInfo.On)
                    spriteBatch.DrawString(debugFont, debugText(gameTime), new Vector2(0, 0), Color.Black);

                switch (players.Count) {
                    case 2:
                        drawer.drawRectangle(graphics.PreferredBackBufferWidth / 2 - 2,
                            0, 4,
                            graphics.PreferredBackBufferHeight,
                            Color.Black
                        );
                    break;
                }

                spriteBatch.End();
                base.Draw(gameTime);
                
            }
        }

        private string debugText(GameTime gameTime) {
            return
                "Run Time  : " + gameTime.TotalRealTime + "\n" +
                "FPS       : " + 1 / gameTime.ElapsedGameTime.TotalSeconds + "\n" +
                "Resolution: " + GraphicsAdapter.DefaultAdapter.CurrentDisplayMode.Width + " x " + GraphicsAdapter.DefaultAdapter.CurrentDisplayMode.Height;
        }
    }
}
