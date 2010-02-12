using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.IO;

namespace o2dlib {
    public class Project {
        private static string lastPath;

        private string name;

        private Database<Palette> palettes;
        private Database<Map> maps;

        public Project(string name) {
            this.name = name;
            palettes = new Database<Palette>("palettes");
            maps = new Database<Map>("maps");
        }

        public string Name {
            get { return name; }
            set { name = value; }
        }

        public Database<Palette> Palettes {
            get { return palettes; }
        }

        public Database<Map> Maps {
            get { return maps; }
        }

        public string ProjectPath {
            get { return lastPath; }
        }

        public Map CurrentMap {
            get;
            set;
        }

        public static Project Load() {
            FolderBrowserDialog dialog = new FolderBrowserDialog();

            if (lastPath != null)
                dialog.SelectedPath = lastPath;

            dialog.ShowNewFolderButton = false;

            dialog.ShowDialog();

            // Hit cancel
            if (dialog.SelectedPath.Length == 0)
                return null;

            lastPath = dialog.SelectedPath;

            return Load(lastPath);
        }

        public static Project Load(string path) {
            Directory.SetCurrentDirectory(path);

            // Read project metadata file
            FileStream fileStream = File.OpenRead("project");
            BinaryReader reader = new BinaryReader(fileStream);

            int fileVersion = reader.ReadInt32();
            string projectName = reader.ReadString();
            bool isStartingMap = reader.ReadBoolean();
            // skipping check for map, NIY
            bool isStartingAvatar = reader.ReadBoolean();
            // skipping check for avatar, NIY

            reader.Close();
            fileStream.Close();

            return new Project(projectName);
        }

        #region Saving
        public void Save() {
            if (lastPath == null) {
                FolderBrowserDialog dialog = new FolderBrowserDialog();

                dialog.Description = "Choose an empty folder to save your project in.";
                dialog.ShowDialog();

                // Hit cancel
                if (dialog.SelectedPath.Length == 0)
                    return;

                DirectoryInfo directory = new DirectoryInfo(dialog.SelectedPath);

                if (!directory.Exists)
                    directory.Create();

                if (directory.GetFiles().Length != 0 || directory.GetDirectories().Length != 0) {
                    MessageBox.Show("You must choose an empty directory to save a project!");
                    return;
                }

                lastPath = directory.FullName;
            }

            Save(lastPath);
        }

        public void Save(string path) {
            Directory.CreateDirectory(path);
            Directory.SetCurrentDirectory(path);

            // Write project metadata file
            FileStream fileStream = File.Create("project");
            BinaryWriter writer = new BinaryWriter(fileStream);

            writer.Write((int)1); // file version
            writer.Write(name);   // project name
            writer.Write(false);  // is starting map?
            writer.Write(false);  // is starting avatar?

            writer.Close();
            fileStream.Close();

            // Write other directory structure
            Directory.CreateDirectory(Path.Combine(path, "db"));
            Directory.CreateDirectory(Path.Combine(path, "entities"));
            Directory.CreateDirectory(Path.Combine(path, "fonts"));
            Directory.CreateDirectory(Path.Combine(path, "gfx-entity"));
            Directory.CreateDirectory(Path.Combine(path, "gfx-textures"));
            Directory.CreateDirectory(Path.Combine(path, "maps"));
            Directory.CreateDirectory(Path.Combine(path, "palettes"));
            Directory.CreateDirectory(Path.Combine(path, "scripts"));

            palettes.SaveAll();
        }

        public void SaveAs() {
            lastPath = null;
            Save();
        }
        #endregion Saving
    }
}
