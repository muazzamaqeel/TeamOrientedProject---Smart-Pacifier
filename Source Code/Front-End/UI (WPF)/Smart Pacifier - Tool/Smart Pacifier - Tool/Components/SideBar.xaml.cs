using System.Windows;
using System.Windows.Controls;
using Smart_Pacifier___Tool.Tabs.CampaignsTab;
using Smart_Pacifier___Tool.Tabs.MonitoringTab;
using Smart_Pacifier___Tool.Tabs.SettingsTab;
using Smart_Pacifier___Tool.Tabs.DeveloperTab;

namespace Smart_Pacifier___Tool
{
    public partial class Sidebar : UserControl
    {
        private const string DeveloperTabVisibleKey = "DeveloperTabVisible";

        public Sidebar()
        {
            InitializeComponent();
            UpdateDeveloperTabVisibility();
        }

        public void UpdateDeveloperTabVisibility()
        {
            if (Application.Current.Properties["DeveloperTabVisibleKey"] is bool isVisible && isVisible)
            {
                DeveloperButton.Visibility = Visibility.Visible;
            }
            else
            {
                DeveloperButton.Visibility = Visibility.Collapsed;
            }
        }





        private void CampaignsButton_Click(object sender, RoutedEventArgs e)
        {
            ((MainWindow)Application.Current.MainWindow).NavigateTo(new CampaignsView());
        }

        private void MonitoringButton_Click(object sender, RoutedEventArgs e)
        {
            ((MainWindow)Application.Current.MainWindow).NavigateTo(new MonitoringView());
        }

        private void SettingsButton_Click(object sender, RoutedEventArgs e)
        {
            ((MainWindow)Application.Current.MainWindow).NavigateTo(new SettingsView());
        }
        private void DeveloperButton_Click(object sender, RoutedEventArgs e)
        {
            // Navigate to the Developer tab
            ((MainWindow)Application.Current.MainWindow).NavigateTo(new DeveloperView());
        }

    }
}
