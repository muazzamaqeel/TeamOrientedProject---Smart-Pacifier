using System;
using System.Collections.Generic;
using System.Linq;
using System.Windows;
using System.Windows.Controls;

namespace Smart_Pacifier___Tool.Tabs.DeveloperTab
{
    public partial class DeveloperView : UserControl
    {
        private List<SensorData> allData = new List<SensorData>();  // Initialize to avoid CS8618
        private List<SensorData> currentPageData = new List<SensorData>();  // Initialize to avoid CS8618
        private int currentPage = 1;
        private int pageSize = 10;

        public DeveloperView()
        {
            InitializeComponent();
            LoadData();
            DisplayData();
        }

        // Load data into allData (normally this would be from your database)
        private void LoadData()
        {
            // Mock data for demonstration
            allData = new List<SensorData>
            {
                new SensorData { Timestamp = DateTime.UtcNow.ToString("yyyy-MM-ddTHH:mm:ssZ"), Campaign = "campaign_1", Pacifier = "pacifier_1", Sensor = "sensor_1", Value = 36.5 },
                // Add more data as needed...
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
        public string Timestamp { get; set; } = string.Empty;  // Avoid CS8618
        public string Campaign { get; set; } = string.Empty;  // Avoid CS8618
        public string Pacifier { get; set; } = string.Empty;  // Avoid CS8618
        public string Sensor { get; set; } = string.Empty;  // Avoid CS8618
        public double Value { get; set; }
    }
}
