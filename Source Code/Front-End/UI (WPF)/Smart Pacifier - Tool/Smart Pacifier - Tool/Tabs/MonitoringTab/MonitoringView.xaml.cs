using System.Windows;
using System.Windows.Controls;

namespace Smart_Pacifier___Tool.Tabs.MonitoringTab
{
    public partial class MonitoringView : UserControl
    {
        public MonitoringView()
        {
            InitializeComponent();
        }

        private void OpenRawDataView_Click(object sender, RoutedEventArgs e)
        {
            // Define the properties to pass
            string pacifierName = "Pacifier 01";

            // Create an instance of RawDataView with the properties and a reference to this view
            var rawDataView = new RawDataView(pacifierName, this);

            // Replace the current view with RawDataView
            var parent = this.Parent as ContentControl;
            if (parent != null)
            {
                parent.Content = rawDataView;
            }
        }
    }
}