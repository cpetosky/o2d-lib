﻿#pragma checksum "..\..\Editor.xaml" "{406ea660-64cf-4c82-b6f0-42d48172a799}" "AD0210BCD200A43BD99F60743415C005"
//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by a tool.
//     Runtime Version:2.0.50727.4918
//
//     Changes to this file may cause incorrect behavior and will be lost if
//     the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

using System;
using System.Diagnostics;
using System.Windows;
using System.Windows.Automation;
using System.Windows.Controls;
using System.Windows.Controls.Primitives;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Forms;
using System.Windows.Forms.Integration;
using System.Windows.Ink;
using System.Windows.Input;
using System.Windows.Markup;
using System.Windows.Media;
using System.Windows.Media.Animation;
using System.Windows.Media.Effects;
using System.Windows.Media.Imaging;
using System.Windows.Media.Media3D;
using System.Windows.Media.TextFormatting;
using System.Windows.Navigation;
using System.Windows.Shapes;


namespace EditorWPF {
    
    
    /// <summary>
    /// Editor
    /// </summary>
    public partial class Editor : System.Windows.Window, System.Windows.Markup.IComponentConnector {
        
        
        #line 9 "..\..\Editor.xaml"
        internal System.Windows.Controls.MenuItem NewProject;
        
        #line default
        #line hidden
        
        
        #line 10 "..\..\Editor.xaml"
        internal System.Windows.Controls.MenuItem LoadProject;
        
        #line default
        #line hidden
        
        
        #line 12 "..\..\Editor.xaml"
        internal System.Windows.Controls.MenuItem SaveProject;
        
        #line default
        #line hidden
        
        
        #line 13 "..\..\Editor.xaml"
        internal System.Windows.Controls.MenuItem SaveProjectAs;
        
        #line default
        #line hidden
        
        
        #line 16 "..\..\Editor.xaml"
        internal System.Windows.Controls.MenuItem CreateDefaultPalette;
        
        #line default
        #line hidden
        
        
        #line 17 "..\..\Editor.xaml"
        internal System.Windows.Controls.MenuItem CreateDefaultMap;
        
        #line default
        #line hidden
        
        
        #line 20 "..\..\Editor.xaml"
        internal System.Windows.Controls.Primitives.StatusBar statusBar;
        
        #line default
        #line hidden
        
        
        #line 22 "..\..\Editor.xaml"
        internal System.Windows.Controls.TextBlock statusText;
        
        #line default
        #line hidden
        
        
        #line 26 "..\..\Editor.xaml"
        internal System.Windows.Forms.Panel palettePanel;
        
        #line default
        #line hidden
        
        
        #line 29 "..\..\Editor.xaml"
        internal System.Windows.Forms.Panel renderPanel;
        
        #line default
        #line hidden
        
        private bool _contentLoaded;
        
        /// <summary>
        /// InitializeComponent
        /// </summary>
        [System.Diagnostics.DebuggerNonUserCodeAttribute()]
        public void InitializeComponent() {
            if (_contentLoaded) {
                return;
            }
            _contentLoaded = true;
            System.Uri resourceLocater = new System.Uri("/EditorWPF;component/editor.xaml", System.UriKind.Relative);
            
            #line 1 "..\..\Editor.xaml"
            System.Windows.Application.LoadComponent(this, resourceLocater);
            
            #line default
            #line hidden
        }
        
        [System.Diagnostics.DebuggerNonUserCodeAttribute()]
        [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Never)]
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Design", "CA1033:InterfaceMethodsShouldBeCallableByChildTypes")]
        void System.Windows.Markup.IComponentConnector.Connect(int connectionId, object target) {
            switch (connectionId)
            {
            case 1:
            this.NewProject = ((System.Windows.Controls.MenuItem)(target));
            
            #line 9 "..\..\Editor.xaml"
            this.NewProject.Click += new System.Windows.RoutedEventHandler(this.NewProject_Click);
            
            #line default
            #line hidden
            return;
            case 2:
            this.LoadProject = ((System.Windows.Controls.MenuItem)(target));
            
            #line 10 "..\..\Editor.xaml"
            this.LoadProject.Click += new System.Windows.RoutedEventHandler(this.LoadProject_Click);
            
            #line default
            #line hidden
            return;
            case 3:
            this.SaveProject = ((System.Windows.Controls.MenuItem)(target));
            
            #line 12 "..\..\Editor.xaml"
            this.SaveProject.Click += new System.Windows.RoutedEventHandler(this.SaveProject_Click);
            
            #line default
            #line hidden
            return;
            case 4:
            this.SaveProjectAs = ((System.Windows.Controls.MenuItem)(target));
            
            #line 13 "..\..\Editor.xaml"
            this.SaveProjectAs.Click += new System.Windows.RoutedEventHandler(this.SaveProjectAs_Click);
            
            #line default
            #line hidden
            return;
            case 5:
            this.CreateDefaultPalette = ((System.Windows.Controls.MenuItem)(target));
            
            #line 16 "..\..\Editor.xaml"
            this.CreateDefaultPalette.Click += new System.Windows.RoutedEventHandler(this.CreateDefaultPalette_Click);
            
            #line default
            #line hidden
            return;
            case 6:
            this.CreateDefaultMap = ((System.Windows.Controls.MenuItem)(target));
            
            #line 17 "..\..\Editor.xaml"
            this.CreateDefaultMap.Click += new System.Windows.RoutedEventHandler(this.CreateDefaultMap_Click);
            
            #line default
            #line hidden
            return;
            case 7:
            this.statusBar = ((System.Windows.Controls.Primitives.StatusBar)(target));
            return;
            case 8:
            this.statusText = ((System.Windows.Controls.TextBlock)(target));
            return;
            case 9:
            this.palettePanel = ((System.Windows.Forms.Panel)(target));
            return;
            case 10:
            this.renderPanel = ((System.Windows.Forms.Panel)(target));
            return;
            }
            this._contentLoaded = true;
        }
    }
}