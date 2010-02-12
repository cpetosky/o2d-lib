using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Content;
using System.Windows.Forms;
using Microsoft.Xna.Framework.Graphics;
using o2dlib;

namespace EditorWPF {
    class EditorGame : Game {

        GraphicsDeviceManager graphics;
        //Panel drawSurface;
        Random random = new Random();
        IntPtr handle;

        private SpriteBatch spriteBatch;
        private o2dlib.View view;


        public Project Project {
            get;
            set;
        }

        private void OnPreparingDeviceSettings(object sender, PreparingDeviceSettingsEventArgs args) {
            args.GraphicsDeviceInformation.PresentationParameters.DeviceWindowHandle = handle;
        }

        public EditorGame(IntPtr handle) {
            //this.drawSurface = drawSurface;
            this.handle = handle;
            graphics = new GraphicsDeviceManager(this);
            graphics.PreparingDeviceSettings += OnPreparingDeviceSettings;
            
            this.IsMouseVisible = true;

            //drawSurface = new Panel();
            //drawSurface.Width = 300;
            //drawSurface.Height = Form.FromHandle(this.Window.Handle).Height;
            //Form.FromHandle(this.Window.Handle).Controls.Add(drawSurface);
        }

        protected override void BeginRun() {
            base.BeginRun();
            Form form = (Form)Form.FromHandle(Window.Handle);
            form.Hide();

        }


        protected override void LoadContent() {
            spriteBatch = new SpriteBatch(GraphicsDevice);
            view = new o2dlib.View(new Rectangle(0, 0, 800, 600), 0, 0);

            base.LoadContent();
        }



        protected override void Update(GameTime gameTime) {
            if (Project != null && Project.CurrentMap != null)
                Project.CurrentMap.PassTime(gameTime.ElapsedRealTime.Milliseconds);

            base.Update(gameTime);
        }



        protected override void Draw(GameTime gameTime) {
            if (Project != null && Project.CurrentMap != null) {
                spriteBatch.Begin(SpriteBlendMode.AlphaBlend, SpriteSortMode.BackToFront, SaveStateMode.None);

                Project.CurrentMap.Render(spriteBatch, view);

                spriteBatch.End();

            } else {
                GraphicsDevice.Clear(Color.Violet);
            }

            base.Draw(gameTime);
        }
    }
}
