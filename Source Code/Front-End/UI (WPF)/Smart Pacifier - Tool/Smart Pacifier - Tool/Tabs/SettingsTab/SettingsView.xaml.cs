using System.Windows;
using System.Windows.Controls;

namespace Smart_Pacifier___Tool.Tabs.SettingsTab
{
    public partial class SettingsView : UserControl
    {
        private bool isUserMode = true;  // Default to User Mode

        public SettingsView()
        {
            InitializeComponent();
            UpdateButtonStates();  // Set default state when the tool opens
        }

        private void UserMode_Click(object sender, RoutedEventArgs e)
        {
            // Switch to User Mode
            isUserMode = true;
            UpdateButtonStates();
        }

        private void DeveloperMode_Click(object sender, RoutedEventArgs e)
        {
            // Switch to Developer Mode
            isUserMode = false;
            UpdateButtonStates();
        }

        private void UpdateButtonStates()
        {
            if (isUserMode)
            {
                // Show "Current Mode" under User Mode, hide under Developer Mode
                UserModeStatus.Visibility = Visibility.Visible;
                DeveloperModeStatus.Visibility = Visibility.Collapsed;

                // Optionally, update text for clarity
                UserModeText.Text = "User Mode";
                DeveloperModeText.Text = "Developer Mode";
            }
            else
            {
                // Show "Current Mode" under Developer Mode, hide under User Mode
                UserModeStatus.Visibility = Visibility.Collapsed;
                DeveloperModeStatus.Visibility = Visibility.Visible;

                // Optionally, update text for clarity
                UserModeText.Text = "User Mode";
                DeveloperModeText.Text = "Developer Mode";
            }
        }
    }
}
