using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Microsoft.Xna.Framework.Content;
using System.IO;

namespace o2dlib {

    public interface IData {
        int ID {
            get;
            set;
        }

        string Name {
            get;
            set;
        }

        void Initialize();
        void Serialize(BinaryWriter writer);
    }

    public static class Databases {
        public static Database<Palette> Palettes = new Database<Palette>("palettes");
    }

    public class Database<T> where T: IData, new() {

        public delegate void initializer(T data);

        private int nextID = 0;
        private Dictionary<int, T> objects = new Dictionary<int, T>();

        private string contentPath;

        public Database(string contentPath) {
            this.contentPath = contentPath;
        }

        public T this[int id] {
            get { return objects[id]; }
        }


        public T Get(int id, ContentManager content) {
            if (!objects.ContainsKey(id))
                objects[id] = content.Load<T>(Path.Combine(contentPath, id.ToString("D5")));
            return objects[id];
        }

        public T Create(string name, initializer init) {
            T data = new T();
            init(data);

            data.ID = nextID++;
            data.Name = name;
            data.Initialize();

            objects[data.ID] = data;

            return data;
        }

        public void SaveAll() {
            foreach (T data in objects.Values) {
                string path = Path.Combine(contentPath, data.ID.ToString());
                FileStream fileStream = File.Create(path);
                BinaryWriter writer = new BinaryWriter(fileStream);

                data.Serialize(writer);

                writer.Close();
                fileStream.Close();
            }
        }

    }
}
