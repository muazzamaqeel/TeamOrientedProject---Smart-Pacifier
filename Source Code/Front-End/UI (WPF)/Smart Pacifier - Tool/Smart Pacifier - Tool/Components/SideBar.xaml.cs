using System.Windows;
using System.Windows.Controls;
using Smart_Pacifier___Tool.Tabs.CampaignsTab; 
using Smart_Pacifier___Tool.Tabs.MonitoringTab;
using Smart_Pacifier___Tool.Tabs.SettingsTab;

namespace Smart_Pacifier___Tool
{
    public partial class Sidebar : UserControl
    {
        public Sidebar()
        {
            InitializeComponent();
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
    }
}