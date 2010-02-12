using System;
using System.Collections.Generic;
using System.Text;

namespace o2dlib {
    class Rucksack : Item {
        public Rucksack(Player player) {
            name = "Rucksack";
            actions.Add(new OpenRucksackAction(player));
        }
    }
}