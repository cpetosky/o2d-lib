using System;
using System.Collections.Generic;
using System.Text;
using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Input;
using Microsoft.Xna.Framework.Graphics;
using o2d.actions;
using o2d.items;
using o2d.entity;

namespace o2d {
    public struct View {
        public int X;
        public int Y;
        public int Width;
        public int Height;
        public int ScreenX;
        public int ScreenY;

        public View(int x, int y, int width, int height, int screenX, int screenY) {
            X = x;
            Y = y;
            Width = width;
            Height = height;
            ScreenX = screenX;
            ScreenY = screenY;
        }

        public View(Rectangle source, int screenX, int screenY)
            :
            this(source.X, source.Y, source.Width, source.Height, screenX, screenY) {

        }
    }

    public class Player {
        private readonly int VerticalThreshold = 160;
        private readonly int HorizontalThreshold = 200;

        private PlayerIndex index;
        private Entity avatar;
        private View view;

        private Point lastPosition;

        private Dictionary<Buttons, Action> actions = new Dictionary<Buttons,Action>();
        private List<Item> items = new List<Item>();
        private List<InterfaceElement> interfaceElements = new List<InterfaceElement>();

        private ResourceBundle resources = new ResourceBundle();
        private GamePadState lastState;

        public Player(PlayerIndex index, View view, Entity avatar) {
            this.index = index;
            this.view = view;
            this.avatar = avatar;
            lastPosition = new Point(avatar.X, avatar.Y);
            lastState = GamePad.GetState(index);

            items.Add(new SprintShoes(this));
            items.Add(new Rucksack(this));

            interfaceElements.Add(new ButtonLegend(this));
            prepareActions();
        }

        private void prepareActions() {
            foreach (Item item in items)
                foreach (Action action in item.Actions)
                    actions[action.Buttons] = action;
        }

        public void TrackInput() {
            GamePadState gamepad = GamePad.GetState(index);
            
            float x = 0;
            float y = 0;

            if (gamepad.IsButtonDown(Buttons.DPadUp)) {
                avatar.Facing = Entity.Direction.North;
                y = 1.0f;
            } else if (gamepad.IsButtonDown(Buttons.DPadDown)) {
                avatar.Facing = Entity.Direction.South;
                y = -1.0f;
            } else if (gamepad.ThumbSticks.Left.Y != 0) {
                y = gamepad.ThumbSticks.Left.Y;
                avatar.Facing = gamepad.ThumbSticks.Left.Y > 0 ? Entity.Direction.North : Entity.Direction.South;
            }
            
            if (gamepad.IsButtonDown(Buttons.DPadLeft)) {
                avatar.Facing = Entity.Direction.West;
                x = -1.0f;
            } else if (gamepad.IsButtonDown(Buttons.DPadRight)) {
                avatar.Facing = Entity.Direction.East;
                x = 1.0f;
            } else if (gamepad.ThumbSticks.Left.X != 0) {
                x = gamepad.ThumbSticks.Left.X;
                if (Math.Abs(x) > Math.Abs(y))
                    avatar.Facing = gamepad.ThumbSticks.Left.X > 0 ? Entity.Direction.East : Entity.Direction.West;
            }
            
            if (x != 0 || y != 0) {
                avatar.Moving = true;
                avatar.Speed = new Vector2(x, y);
            } else {
                avatar.Moving = false; avatar.Speed = Vector2.Zero;
            }

            if (actions.ContainsKey(Buttons.A))
                trackHoldStateChange(Buttons.A, actions[Buttons.A]);
            if (actions.ContainsKey(Buttons.B))
                trackHoldStateChange(Buttons.B, actions[Buttons.B]);
            if (actions.ContainsKey(Buttons.X))
                trackHoldStateChange(Buttons.X, actions[Buttons.X]);
            if (actions.ContainsKey(Buttons.Y))
                trackHoldStateChange(Buttons.Y, actions[Buttons.Y]);

            lastState = gamepad;
        }

        private void trackHoldStateChange(Buttons buttons, Action action) {
            if (action == null)
                return;
            GamePadState gamepad = GamePad.GetState(index);
            if (lastState.IsButtonUp(buttons) && gamepad.IsButtonDown(buttons))
                action.Start();
            else if (lastState.IsButtonDown(buttons) && gamepad.IsButtonUp(buttons))
                action.Stop();
        }

        public void Scroll() {
            // Handle scrolling
            int move = avatar.Y - lastPosition.Y;

            // Scroll up, if necessary	
            if ((move < 0) && (avatar.Y - view.Y < VerticalThreshold) && (view.Y + move >= 0))
                view.Y += move;

            // Scroll down, if necessary
            if ((move > 0) && ((view.Y + view.Height) - (avatar.Y + avatar.Height) < VerticalThreshold) &&
                    (view.Y + move < avatar.Map.PixelHeight - view.Height))
                view.Y += move;

            move = avatar.X - lastPosition.X;

            // Scroll left, if necessary
            if ((move < 0) && (avatar.X - view.X < HorizontalThreshold) && (view.X + move >= 0))
                view.X += move;

            // Scroll right, if necessary
            if ((move > 0) && ((view.X + view.Width) - (avatar.X + avatar.Width) < HorizontalThreshold) &&
                (view.X + move < avatar.Map.PixelWidth - view.Width))
                view.X += move;

            lastPosition.X = avatar.X;
            lastPosition.Y = avatar.Y;
        }

        public void RenderView(SpriteBatch spriteBatch) {
            avatar.Map.Render(spriteBatch, view);

            foreach (InterfaceElement element in interfaceElements)
                element.Render(spriteBatch);
        }

        public Entity Avatar {
            get { return avatar; }
        }

        public View View {
            get { return view; }
        }

        public void AddInterfaceElement(InterfaceElement element) {
            interfaceElements.Add(element);
        }

        public void RemoveInterfaceElement(InterfaceElement element) {
            interfaceElements.Remove(element);
        }

        public ResourceBundle Resources {
            get { return resources; }
        }

        public Action this[Buttons button] {
            get {
                if (actions.ContainsKey(button))
                    return actions[button];
                else
                    return null;
            }
        }
    }
}