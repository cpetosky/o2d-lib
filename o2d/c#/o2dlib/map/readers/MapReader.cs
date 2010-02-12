using System;
using System.Collections.Generic;
using System.Text;
using Microsoft.Xna.Framework.Content;

namespace o2dlib {
    class MapReader : ContentTypeReader<Map> {
        protected override Map Read(ContentReader input, Map existingInstance) {
            int id = input.ReadInt32();
            int width = input.ReadInt32();
            int height = input.ReadInt32();
            string name = input.ReadString();
            Palette palette = Databases.Palettes.Get(input.ReadInt32(), input.ContentManager);

            Map map = new Map(id, palette, width, height, name);

            for (int i = 0; i < map.Width; ++i)
                for (int j = 0; j < map.Height; ++j)
                    for (int l = 0; l < Map.Layers; ++l)
                        map[i, j, l] = map.Palette[input.ReadInt32()];

            map.InitializeNeighbors();

            return map;
        }
    }
}