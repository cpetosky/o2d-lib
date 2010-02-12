using System;
using System.Collections.Generic;
using System.Text;

namespace o2dlib {
    public class SprintShoes : Item {
        public SprintShoes(Player player) {
            name = "Sprint Shoes";
            actions.Add(new SprintAction(player));
        }
    }
}