using System;
using System.Collections.Generic;
using System.Text;
using Microsoft.Xna.Framework.Content;
using Microsoft.Xna.Framework.Graphics;
using Microsoft.Xna.Framework;

namespace o2dlib {
    class EntityGraphicsReader : ContentTypeReader<EntityGraphics> {
        protected override EntityGraphics Read(ContentReader input, EntityGraphics existingInstance) {
            return new EntityGraphics(input);
        }
    }
}