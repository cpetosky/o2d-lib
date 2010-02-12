using System;
using System.Collections.Generic;
using System.Text;
using Microsoft.Xna.Framework.Input;

namespace net.tanatopia {
    public struct ToggleState {
        public bool On;
        public bool Ready;
        public bool Off {
            get { return !On; }
            set { On = !value; }
        }
        public bool Toggle() {
            On = !On;
            return On;
        }
    }

    public class ButtonUtilities {
        public static void TrackButtonToggle(ref ToggleState state, ButtonState buttonState) {
            if (state.Ready && buttonState == ButtonState.Pressed) {
                state.Ready = false;
                state.Toggle();
            } else if (!state.Ready && buttonState == ButtonState.Released) {
                state.Ready = true;
            }
        }
    }
}