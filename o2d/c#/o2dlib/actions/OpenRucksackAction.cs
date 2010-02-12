using System;
using System.Collections.Generic;
using System.Text;
using Microsoft.Xna.Framework.Input;

namespace o2dlib {
    class OpenRucksackAction : Action {
        public OpenRucksackAction(Player player)
            : base("Resources", Buttons.Y, player) {

        }

        private InterfaceElement rucksack;

        public override void Start() {
            if (operating) {
                closeRucksack();
            } else {
                openRucksack();
            }

            operating = !operating;
        }

        public override void Stop() {
            // Do nothing
        }

        private void openRucksack() {
            rucksack = new RucksackInterface(player);
            player.AddInterfaceElement(rucksack);
        }

        private void closeRucksack() {
            player.RemoveInterfaceElement(rucksack);
        }
    }
}