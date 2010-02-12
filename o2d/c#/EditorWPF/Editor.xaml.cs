using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;

using o2dlib;
using System.Windows.Forms;
using System.Threading;

namespace EditorWPF {
    /// <summary>
    /// Interaction logic for Window1.xaml
    /// </summary>
    public partial class Editor : Window {

        private Project project;
        private EditorGame game;
        private PaletteGame paletteGame;
        
        public Editor() {
            InitializeComponent();

            // Set up Game component in new thread.
            IntPtr handle = renderPanel.Handle;
            new Thread(new ThreadStart(() => { game = new EditorGame(handle); game.Run(); })).Start();

            handle = palettePanel.Handle;
            new Thread(new ThreadStart(() => { paletteGame = new PaletteGame(handle); paletteGame.Run(); })).Start();
        }

        private void NewProject_Click(object sender, RoutedEventArgs e) {
            NewProjectDialog dialog = new NewProjectDialog();
            dialog.Owner = this;
            dialog.ShowDialog();

            string name = dialog.ProjectName;

            if (name == null || name.Length == 0) {
                System.Windows.MessageBox.Show("You must enter a project name!");
                return;
            }

            project = new Project(name);
            project.Save();
            game.Project = project;

            SaveProject.IsEnabled = true;
            SaveProjectAs.IsEnabled = true;
        }

        private void LoadProject_Click(object sender, RoutedEventArgs e) {
            project = Project.Load();
            if (project != null) {
                statusText.Text = "Project \"" + project.Name + "\" loaded.";
                game.Project = project;
            }
        }

        private void SaveProject_Click(object sender, RoutedEventArgs e) {
            project.Save();
            statusText.Text = "Project \"" + project.Name + "\" saved.";
        }

        private void SaveProjectAs_Click(object sender, RoutedEventArgs e) {
            project.SaveAs();
        }

        private void CreateDefaultPalette_Click(object sender, RoutedEventArgs e) {
            if (project == null)
                return;

            Palette palette = project.Palettes.Create("dev-default", p => p.GraphicsDevice = game.GraphicsDevice);

            palette.AddTile(new TileInfo(0, "light_grass", 0, TileAccess.All, game.GraphicsDevice, project));
        }

        private void CreateDefaultMap_Click(object sender, RoutedEventArgs e) {
            if (project == null)
                return;

            if (project.Palettes[0] == null)
                return;

            Map map = project.Maps.Create("test map", m => { m.Width = 25; m.Height = 25; m.Palette = project.Palettes[0]; });

            project.CurrentMap = map;
        }
    }
}
