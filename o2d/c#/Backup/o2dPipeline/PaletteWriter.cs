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
    public class PaletteWriter : ContentTypeWriter<PaletteContent> {
        protected override void Write(ContentWriter output, PaletteContent value) {
            output.Write(value.ID);
            output.Write(value.Name);
            output.Write(value.Size);

            for (int i = 0; i < value.Size; ++i) {
                if (value.Tiles[i].TexName == null)
                    output.Write("{!BLANK!}");
                else
                    output.Write(value.Tiles[i].TexName);
                output.Write(value.Tiles[i].Priority);
                output.Write(value.Tiles[i].TileAccess);
            }
        }

        public override string GetRuntimeType(TargetPlatform targetPlatform) {
            return "o2d.Palette, o2d";
        }

        public override string GetRuntimeReader(TargetPlatform targetPlatform) {
            return "o2d.PaletteReader, o2d";
        }
    }
}
