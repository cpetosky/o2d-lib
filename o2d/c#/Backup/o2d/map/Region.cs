using System;
using System.Collections.Generic;
using System.Text;
using Microsoft.Xna.Framework;

namespace o2d.map {

    public enum RegionType {
        Grassland = 0, Lake = 1, Forest = 2, Farm = 3, Ocean = 4
    }

    public class Region {
        private RegionType type;
        private Rectangle space;

        public Region(RegionType type, Rectangle space) {
            this.type = type;
            this.space = space;
        }
    }
}