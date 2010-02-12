using System.Xml;
using Microsoft.Xna.Framework.Content.Pipeline.Serialization.Intermediate;

namespace o2dPipeline {
    public static class TempMain {
        public static void Main() {
            MapContent testValue = new MapContent();

            testValue.Width = 5;
            testValue.Height = 3;
            testValue.initTiles();
            XmlWriterSettings settings = new XmlWriterSettings();
            settings.Indent = true;

            using (XmlWriter xmlWriter = XmlWriter.Create("test.xml", settings)) {
                IntermediateSerializer.Serialize(xmlWriter, testValue, null);
            }
        }
    }
}