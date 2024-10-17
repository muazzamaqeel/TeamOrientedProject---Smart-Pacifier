using System;
using System.Windows;
using System.Windows.Controls;
using SmartPacifier.BackEnd.DatabaseLayer.InfluxDB.Managers;

namespace Smart_Pacifier___Tool.Temp
{
    public partial class Test : Window
    {
        private readonly ManagerPacifiers _managerPacifiers;

        public Test(ManagerPacifiers managerPacifiers)
        {
            InitializeComponent();
            _managerPacifiers = managerPacifiers; // Initialize the manager
        }

        // Method for handling TextBox focus (placeholder behavior)
        private void OnTextBoxGotFocus(object sender, RoutedEventArgs e)
        {
            TextBox textBox = sender as TextBox;
            if (textBox != null && (textBox.Text == "Enter Campaign Name" || textBox.Text == "Enter Pacifier Name"))
            {
                textBox.Text = string.Empty;
            }
        }

        private void OnTextBoxLostFocus(object sender, RoutedEventArgs e)
        {
            TextBox textBox = sender as TextBox;
            if (textBox != null && string.IsNullOrWhiteSpace(textBox.Text))
            {
                if (textBox == CampaignNameTextBox)
                {
                    textBox.Text = "Enter Campaign Name";
                }
                else if (textBox == PacifierNameTextBox)
                {
                    textBox.Text = "Enter Pacifier Name";
                }
            }
        }

        // Method for handling Add Campaign button click
        private void OnAddCampaignButtonClick(object sender, RoutedEventArgs e)
        {
            string campaignName = CampaignNameTextBox.Text.Trim();

            if (string.IsNullOrEmpty(campaignName) || campaignName == "Enter Campaign Name")
            {
                ResultsTextBox.Text = "Please enter a valid campaign name.";
                return;
            }

            // Assuming there's a manager for adding campaigns
            ResultsTextBox.Text = $"Campaign '{campaignName}' added successfully.";
        }

        // Method for handling Add Pacifier button click
        private void OnAddPacifierButtonClick(object sender, RoutedEventArgs e)
        {
            string campaignName = CampaignNameTextBox.Text.Trim();
            string pacifierName = PacifierNameTextBox.Text.Trim();

            if (string.IsNullOrEmpty(campaignName) || string.IsNullOrEmpty(pacifierName))
            {
                ResultsTextBox.Text = "Please enter both a valid campaign name and pacifier name.";
                return;
            }

            try
            {
                _managerPacifiers.AddPacifierToCampaign(campaignName, pacifierName);
                ResultsTextBox.Text = $"New pacifier '{pacifierName}' added successfully to campaign '{campaignName}'.";
            }
            catch (Exception ex)
            {
                ResultsTextBox.Text = $"Error: {ex.Message}";
            }
        }
    }
}
