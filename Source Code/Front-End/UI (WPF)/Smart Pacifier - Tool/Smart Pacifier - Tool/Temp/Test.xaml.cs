using System;
using System.Collections.Generic;
using System.Windows;
using SmartPacifier.Interface.Services;
using SmartPacifier.BackEnd.Database.InfluxDB.Connection;
using Smart_Pacifier___Tool.Components;
using SmartPacifier.BackEnd.Database.InfluxDB.Managers;
using SmartPacifier.BackEnd.DatabaseLayer.InfluxDB.Managers;

namespace Smart_Pacifier___Tool.Temp
{
    public partial class Test : Window
    {
        private readonly IDatabaseService _databaseService;
        private readonly List<string> _campaigns = new List<string>();  // List to store campaigns
        private readonly List<string> _pacifiers = new List<string>();  // List to store pacifiers
        private ManagerCampaign? _managerCampaign;
        private ManagerPacifiers? _managerPacifiers;
        private ManagerSensors? _managerSensors;

        public Test(IDatabaseService databaseService)
        {
            InitializeComponent();
            _databaseService = databaseService;

            // Initialize the managers with default or placeholder values
            _managerCampaign = new ManagerCampaign(databaseService);
            _managerSensors = new ManagerSensors(databaseService);

            // Retrieve the client from the InfluxDatabaseService instance
            var influxService = _databaseService as InfluxDatabaseService;

            if (influxService == null)
            {
                MessageBox.Show("Failed to initialize InfluxDatabaseService. Please check the service configuration.",
                                "Initialization Error", MessageBoxButton.OK, MessageBoxImage.Error);
                return;  // Exit constructor gracefully if the client can't be initialized
            }

            var client = influxService.GetClient();
            _managerPacifiers = new ManagerPacifiers(databaseService, client);

            // Load existing campaigns into ComboBox
            LoadExistingCampaigns();
        }

        // Method to load existing campaigns (from the database)
        public async void LoadExistingCampaigns()
        {
            _campaigns.Clear();  // Clear the current list

            // Fetch campaigns from the database
            var campaignsFromDb = await _databaseService.GetCampaignsAsync();

            if (campaignsFromDb != null && campaignsFromDb.Count > 0)
            {
                foreach (var campaign in campaignsFromDb)
                {
                    _campaigns.Add(campaign);
                }

                CampaignComboBox.ItemsSource = null;  // Clear ComboBox
                CampaignComboBox.ItemsSource = _campaigns;  // Bind campaigns to ComboBox
            }
            else
            {
                MessageBox.Show("No campaigns found in the database.");
            }
        }

        // Method to load pacifiers for the selected campaign
        public async void LoadPacifiers(string selectedCampaign)
        {
            _pacifiers.Clear();  // Clear the current list of pacifiers

            if (string.IsNullOrWhiteSpace(selectedCampaign))
            {
                MessageBox.Show("Please select a valid campaign.");
                return;
            }

            // Fetch pacifiers for the selected campaign from the database
            var pacifiersFromDb = await _managerPacifiers.GetPacifiersAsync(selectedCampaign);

            if (pacifiersFromDb != null && pacifiersFromDb.Count > 0)
            {
                foreach (var pacifier in pacifiersFromDb)
                {
                    _pacifiers.Add(pacifier);
                }

                // Refresh the PacifierComboBox with pacifiers
                PacifierComboBox.ItemsSource = null;  // Clear ComboBox
                PacifierComboBox.ItemsSource = _pacifiers;  // Bind pacifiers to ComboBox
            }
            else
            {
                MessageBox.Show("No pacifiers found for the selected campaign.");
            }
        }


        // Event handler for when a campaign is selected, triggering loading of pacifiers
        // Event handler for when a campaign is selected, triggering loading of pacifiers
        private void CampaignComboBox_SelectionChanged(object sender, System.Windows.Controls.SelectionChangedEventArgs e)
        {
            string? selectedCampaign = CampaignComboBox.SelectedItem as string;

            if (!string.IsNullOrWhiteSpace(selectedCampaign))
            {
                LoadPacifiers(selectedCampaign);  // Load pacifiers for the selected campaign
            }
        }


        // Event handler for adding a campaign
        private async void OnAddCampaignButtonClick(object sender, RoutedEventArgs e)
        {
            InputDialog inputDialog = new InputDialog("Enter Campaign Name");
            if (inputDialog.ShowDialog() == true)
            {
                string newCampaignName = inputDialog.InputText;

                if (!string.IsNullOrWhiteSpace(newCampaignName))
                {
                    if (_managerCampaign != null)
                    {
                        await _managerCampaign.AddCampaignAsync(newCampaignName);  // Add campaign

                        _campaigns.Add(newCampaignName);
                        CampaignComboBox.ItemsSource = null;
                        CampaignComboBox.ItemsSource = _campaigns;

                        ResultsTextBox.Text += $"Added campaign: {newCampaignName}\n";
                    }
                    else
                    {
                        MessageBox.Show("Campaign manager is not initialized.");
                    }
                }
                else
                {
                    MessageBox.Show("Please enter a valid campaign name.");
                }
            }
        }

        // Event handler for adding a pacifier
        private async void OnAddPacifierButtonClick(object sender, RoutedEventArgs e)
        {
            string? selectedCampaign = CampaignComboBox.SelectedItem as string;

            if (selectedCampaign != null)
            {
                InputDialog inputDialog = new InputDialog("Enter Pacifier Name");
                if (inputDialog.ShowDialog() == true)
                {
                    string pacifierName = inputDialog.InputText;

                    if (!string.IsNullOrWhiteSpace(pacifierName))
                    {
                        if (_managerPacifiers != null)
                        {
                            await _managerPacifiers.AddPacifierAsync(selectedCampaign, pacifierName);
                            ResultsTextBox.Text += $"Added pacifier: {pacifierName} to campaign: {selectedCampaign}\n";
                        }
                        else
                        {
                            MessageBox.Show("Pacifier manager is not initialized.");
                        }
                    }
                    else
                    {
                        MessageBox.Show("Please enter a valid pacifier name.");
                    }
                }
            }
            else
            {
                MessageBox.Show("Please select a campaign.");
            }
        }

        // Event handler for adding sensors to the selected pacifier
        private async void OnAddSensorButtonClick(object sender, RoutedEventArgs e)
        {
            string? selectedCampaign = CampaignComboBox.SelectedItem as string;
            string? selectedPacifier = PacifierComboBox.SelectedItem as string;

            if (selectedCampaign != null && selectedPacifier != null)
            {
                if (_managerSensors != null)
                {
                    float ppgValue = 0.85f;
                    float imuAccelX = 0.001f;
                    float imuAccelY = 0.002f;
                    float imuAccelZ = 0.003f;

                    await _managerSensors.AddSensorDataAsync(selectedCampaign, selectedPacifier, ppgValue, imuAccelX, imuAccelY, imuAccelZ);
                    ResultsTextBox.Text += $"Added sensors to pacifier: {selectedPacifier} in campaign: {selectedCampaign}\n";
                }
                else
                {
                    MessageBox.Show("Sensor manager is not initialized.");
                }
            }
            else
            {
                MessageBox.Show("Please select a campaign and pacifier.");
            }
        }
    }
}
