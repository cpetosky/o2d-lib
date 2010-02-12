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
    public class EntityGraphicsWriter : ContentTypeWriter<EntityGraphicsContent> {
        protected override void Write(ContentWriter output, EntityGraphicsContent value) {
            output.Write(value.ID);
            output.Write(value.Width);
            output.Write(value.Height);
            output.Write(value.Frames);
            output.Write(value.Image);

            for (int i = 0; i < value.Modes.Length; ++i)
                output.Write(value.Modes[i]);
        }

        public override string GetRuntimeType(TargetPlatform targetPlatform) {
            return "o2d.EntityGraphics, o2d";
        }

        public override string GetRuntimeReader(TargetPlatform targetPlatform) {
             return "o2d.EntityGraphicsReader, o2d";
        }
    }
}
