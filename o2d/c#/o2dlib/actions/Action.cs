using System;
using System.Collections.Generic;
using System.Text;
using Microsoft.Xna.Framework.Input;

namespace o2dlib {
    public abstract class Action {
        protected string name;
        protected Buttons buttons;
        protected Player player;
        protected bool operating = false;

        protected Action(string name, Buttons buttons, Player player) {
            this.name = name;
            this.buttons = buttons;
            this.player = player;
        }

        public string Name {
            get { return name; }
        }
        public Buttons Buttons {
            get { return buttons; }
        }

        public abstract void Start();
        public abstract void Stop();
    }
}