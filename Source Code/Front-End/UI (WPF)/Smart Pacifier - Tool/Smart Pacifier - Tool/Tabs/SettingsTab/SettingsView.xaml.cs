using System.Windows;
using System.Windows.Controls;

namespace Smart_Pacifier___Tool.Tabs.SettingsTab
{
    public partial class SettingsView : UserControl
    {
        // Defining a constant key for storing the mode in the application properties
        private const string UserModeKey = "UserMode";

        public SettingsView()
        {
            InitializeComponent();

            // Retrieving the persisted state when the view is loaded
            if (Application.Current.Properties[UserModeKey] is bool userModeValue)
            {
                isUserMode = userModeValue;
            }
            else
            {
                isUserMode = true;  // Default to User Mode if no state was saved
            }

            UpdateButtonStates();  // Update button states when the tool opens
        }

        private bool isUserMode = true;  // Default to User Mode

        private void UserMode_Click(object sender, RoutedEventArgs e)
        {
            // Switch to User Mode and save the state
            isUserMode = true;
            Application.Current.Properties[UserModeKey] = isUserMode;
            UpdateButtonStates();
        }

        private void DeveloperMode_Click(object sender, RoutedEventArgs e)
        {
            // Switch to Developer Mode and save the state
            isUserMode = false;
            Application.Current.Properties[UserModeKey] = isUserMode;
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
