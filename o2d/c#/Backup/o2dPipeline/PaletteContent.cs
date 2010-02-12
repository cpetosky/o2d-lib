using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;

namespace o2dPipeline {
    public class PaletteContent {
        public int ID;
        public string Name;
        public int Size;
        public TileEntry[] Tiles;

        public static PaletteContent Create(int id) {
            PaletteContent content = new PaletteContent();
            content.ID = id;

            XmlReaderSettings settings = new XmlReaderSettings();

            settings.ConformanceLevel = ConformanceLevel.Fragment;
            settings.IgnoreWhitespace = true;
            settings.IgnoreComments = true;

            XmlReader reader = XmlReader.Create(@"Content\palette\" + id.ToString("D5") + ".xml", settings);
            reader.Read();
            reader.ReadStartElement("palette");
            reader.ReadStartElement("name");
            content.Name = reader.ReadContentAsString();
            reader.ReadEndElement();
            reader.ReadStartElement("size");
            content.Size = reader.ReadContentAsInt();
            content.Tiles = new TileEntry[content.Size];
            reader.ReadEndElement();

            while (reader.IsStartElement()) {
                TileEntry tile = new TileEntry();
                reader.ReadStartElement("tile");
                reader.ReadStartElement("position");
                int i = reader.ReadContentAsInt();
                reader.ReadEndElement();
                reader.ReadStartElement("texture");
                tile.TexName = reader.ReadContentAsString();
                reader.ReadEndElement();
                reader.ReadStartElement("priority");
                tile.Priority = reader.ReadContentAsInt();
                reader.ReadEndElement();
                reader.ReadStartElement("access");
                tile.TileAccess = reader.ReadContentAsInt();

                content.Tiles[i] = tile;
                reader.ReadEndElement();
                reader.ReadEndElement();
            }
            reader.ReadEndElement();

            return content;
        }
    }

    public struct TileEntry {
        public String TexName;
        public int Priority;
        public int TileAccess;
    }
}
