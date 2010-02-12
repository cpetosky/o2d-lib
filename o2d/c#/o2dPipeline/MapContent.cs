using System;
using System.Collections.Generic;
using System.Text;

namespace o2dPipeline {
    public class MapContent {
        public int ID;
        public int Width;
        public int Height;
        public string Name;

        public int PaletteID;

        public int[][][] TileID;
        
 
        public void initTiles() {
            TileID = new int[Width][][];
            for (int i = 0; i < Width; ++i) {
                TileID[i] = new int[Height][];
                for (int j = 0; j < Height; ++j) {
                    TileID[i][j] = new int[3];
                }
            }

        }
    }
}
