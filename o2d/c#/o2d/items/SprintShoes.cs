using System;
using System.Collections.Generic;
using System.Text;
using o2d.actions;

namespace o2d.items {
    public class SprintShoes : Item {
        public SprintShoes(Player player) {
            name = "Sprint Shoes";
            actions.Add(new SprintAction(player));
        }
    }
}