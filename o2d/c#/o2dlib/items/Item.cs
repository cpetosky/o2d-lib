using System.Collections.Generic;
using System.Text;

namespace o2dlib {
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