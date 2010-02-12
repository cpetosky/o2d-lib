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
using System.Windows.Shapes;

namespace EditorWPF {
    /// <summary>
    /// Interaction logic for NewProjectDialog.xaml
    /// </summary>
    public partial class NewProjectDialog : Window {
        public NewProjectDialog() {
            InitializeComponent();
        }

        public string ProjectName {
            get { return projectName.Text; }
            set { projectName.Text = value; }
        }

        private void Submit_Click(object sender, RoutedEventArgs e) {
            Close();
        }
    }
}
