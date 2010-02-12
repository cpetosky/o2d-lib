using System;
using System.Collections.Generic;
using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;
using Microsoft.Xna.Framework.Content.Pipeline;
using Microsoft.Xna.Framework.Content.Pipeline.Graphics;
using Microsoft.Xna.Framework.Content.Pipeline.Processors;
using Microsoft.Xna.Framework.Content.Pipeline.Serialization.Compiler;

namespace o2dPipeline {
    /// <summary>
    /// This class will be instantiated by the XNA Framework Content Pipeline
    /// to write the specified data type into binary .xnb format.
    ///
    /// This should be part of a Content Pipeline Extension Library project.
    /// </summary>
    [ContentTypeWriter]
    public class MapWriter : ContentTypeWriter<MapContent> {
        protected override void Write(ContentWriter output, MapContent value) {
            output.Write(value.ID);
            output.Write(value.Width);
            output.Write(value.Height);
            output.Write(value.Name);
            output.Write(value.PaletteID);

            for (int i = 0; i < value.Width; ++i)
                for (int j = 0; j < value.Height; ++j)
                    for (int l = 0; l < 3; ++l)
                        output.Write(value.TileID[i][j][l]);
        }

        public override string GetRuntimeType(TargetPlatform targetPlatform) {
            return "o2d.Map, o2d";
        }

        public override string GetRuntimeReader(TargetPlatform targetPlatform) {
             return "o2d.MapReader, o2d";
        }
    }
}
