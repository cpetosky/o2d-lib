using System;
using System.Collections.Generic;
using System.Text;
using o2d.actions;

namespace o2d.items {
    public abstract class Item {
        protected string name;
        protected List<Action> actions = new List<Action>();

        public string Name {
            get { return name; }
        }

        public List<Action> Actions {
            get { return actions; }
        }

    }
}