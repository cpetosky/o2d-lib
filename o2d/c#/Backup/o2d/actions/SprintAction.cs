using System;
using System.Collections.Generic;
using System.Text;
using Microsoft.Xna.Framework.Input;

namespace o2d.actions {
    public class SprintAction : Action {
        public SprintAction(Player player)
            : base("Sprint", Buttons.B, player) {

        }

        public override void Start() {
            operating = true;
            player.Avatar.MaxSpeed *= 2;
        }

        public override void Stop() {
            operating = false;
            player.Avatar.MaxSpeed /= 2;
        }
    }
}