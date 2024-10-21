using System;
using System.Collections.Generic;
using System.Linq;
using System.Windows;
using System.Windows.Controls;

namespace Smart_Pacifier___Tool.Tabs.DeveloperTab
{
    public partial class DeveloperView : UserControl
    {
        private List<SensorData> allData = new List<SensorData>();
        private List<SensorData> currentPageData = new List<SensorData>();
        private int currentPage = 1;
        private int pageSize = 10;

        public DeveloperView()
        {
            InitializeComponent();
            LoadData();
            DisplayData();
        }

        // Load data into allData
        private void LoadData()
        {
            allData = new List<SensorData>
            {
                new SensorData { Timestamp = DateTime.UtcNow.ToString("yyyy-MM-ddTHH:mm:ssZ"), Campaign = "campaign_1", Pacifier = "pacifier_1", Sensor = "sensor_1", Value = 36.5 },
                new SensorData { Timestamp = DateTime.UtcNow.ToString("yyyy-MM-ddTHH:mm:ssZ"), Campaign = "campaign_3", Pacifier = "pacifier_1", Sensor = "sensor_1", Value = 311.5 },
                new SensorData { Timestamp = DateTime.UtcNow.ToString("yyyy-MM-ddTHH:mm:ssZ"), Campaign = "campaign_2", Pacifier = "pacifier_2", Sensor = "sensor_1", Value = 36.5 },
            };
        }

        // Display the current page of data
        private void DisplayData()
        {
            currentPageData = allData?.Skip((currentPage - 1) * pageSize).Take(pageSize).ToList() ?? new List<SensorData>();
            DataListView.ItemsSource = currentPageData;
        }

        // Pagination: Previous Button
        private void PreviousButton_Click(object sender, RoutedEventArgs e)
        {
            if (currentPage > 1)
            {
                currentPage--;
                DisplayData();
            }
        }

        // Pagination: Next Button
        private void NextButton_Click(object sender, RoutedEventArgs e)
        {
            if (currentPage * pageSize < (allData?.Count ?? 0))
            {
                currentPage++;
                DisplayData();
            }
        }

        // Apply filters with null checks to avoid CS8602
        private void ApplyButton_Click(object sender, RoutedEventArgs e)
        {
            var filteredData = allData?.Where(d => d.Campaign == Campaign.SelectedItem?.ToString() &&
                                                   d.Pacifier == Pacifier.SelectedItem?.ToString() &&
                                                   d.Sensor == Sensor.SelectedItem?.ToString()).ToList();

            DataListView.ItemsSource = filteredData ?? new List<SensorData>();
        }

        // Delete selected entries with null check
        private void DeleteButton_Click(object sender, RoutedEventArgs e)
        {
            var selectedItems = DataListView.SelectedItems?.Cast<SensorData>().ToList();
            if (selectedItems != null && selectedItems.Count > 0)
            {
                foreach (var item in selectedItems)
                {
                    allData?.Remove(item);
                }
                DisplayData();
            }
        }

        // Add button click
        private void AddButton_Click(object sender, RoutedEventArgs e)
        {
            // Implement the popup for Add action here
            // Add logic to add a new entry and refresh the list
        }

        // Edit button click
        private void EditButton_Click(object sender, RoutedEventArgs e)
        {
            if (DataListView.SelectedItems.Count == 1)
            {
                // Implement the popup for Edit action here
                // Add logic to edit the selected entry and refresh the list
            }
            else
            {
                MessageBox.Show("Please select one entry to edit.");
            }
        }

        // Handling placeholder-like behavior for ComboBox
        private void ComboBox_Loaded(object sender, RoutedEventArgs e)
        {
            var comboBox = sender as ComboBox;
            comboBox.SelectedIndex = -1;
        }

        private void ComboBox_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            var comboBox = sender as ComboBox;
            if (comboBox.SelectedItem == null)
            {
                comboBox.SelectedIndex = -1; // Reset selection if nothing is chosen
            }
        }
    }

    // Example data model for sensor data
    public class SensorData
    {
        public string Timestamp { get; set; } = string.Empty;
        public string Campaign { get; set; } = string.Empty;
        public string Pacifier { get; set; } = string.Empty;
        public string Sensor { get; set; } = string.Empty;
        public double Value { get; set; }
    }
}
