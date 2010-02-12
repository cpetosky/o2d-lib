using System;
using System.Collections.Generic;
using System.Text;
using o2d.actions;

namespace o2d.items {
    class Rucksack : Item {
        public Rucksack(Player player) {
            name = "Rucksack";
            actions.Add(new OpenRucksackAction(player));
        }
    }
}