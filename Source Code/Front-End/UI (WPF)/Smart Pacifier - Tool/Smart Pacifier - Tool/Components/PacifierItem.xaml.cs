using System.Collections.ObjectModel;
using System.Windows;
using System.Windows.Controls;

namespace Smart_Pacifier___Tool.Components
{
    public partial class PacifierItem : UserControl
    {
        public PacifierItem()
        {
            InitializeComponent();
        }

        public string DisplayName
        {
            get { return (string)GetValue(DisplayNameProperty); }
            set { SetValue(DisplayNameProperty, value); }
        }

        public static readonly DependencyProperty DisplayNameProperty =
            DependencyProperty.Register("DisplayName", typeof(string), typeof(PacifierItem), new PropertyMetadata(string.Empty));

        public ObservableCollection<KeyValuePair<string, int>> KeyValuePairs
        {
            get { return (ObservableCollection<KeyValuePair<string, int>>)GetValue(KeyValuePairsProperty); }
            set { SetValue(KeyValuePairsProperty, value); }
        }

        public static readonly DependencyProperty KeyValuePairsProperty =
            DependencyProperty.Register("KeyValuePairs", typeof(ObservableCollection<KeyValuePair<string, int>>), typeof(PacifierItem), new PropertyMetadata(new ObservableCollection<KeyValuePair<string, int>>()));

        public string Status
        {
            get { return (string)GetValue(StatusProperty); }
            set { SetValue(StatusProperty, value); }
        }

        public static readonly DependencyProperty StatusProperty =
            DependencyProperty.Register("Status", typeof(string), typeof(PacifierItem), new PropertyMetadata("Disconnected"));
    }
}