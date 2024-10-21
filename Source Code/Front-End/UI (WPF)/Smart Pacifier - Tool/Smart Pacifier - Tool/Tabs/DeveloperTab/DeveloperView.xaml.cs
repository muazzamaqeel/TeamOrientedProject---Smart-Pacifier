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
        // Show confirmation dialog
        MessageBoxResult result = MessageBox.Show("Are you sure you want to delete the selected data?", 
                                                  "Warning", MessageBoxButton.YesNo, MessageBoxImage.Warning);

        // If the user confirms deletion
        if (result == MessageBoxResult.Yes)
        {
            foreach (var item in selectedItems)
            {
                allData?.Remove(item);
            }

            // Refresh the display
            DisplayData();
        }
        // If Cancel is chosen, do nothing.
    }
    else
    {
        MessageBox.Show("Please select at least one entry to delete.");
    }
}


        // Add button click
        private void AddButton_Click(object sender, RoutedEventArgs e)
        {
            AddDataWindow addDataWindow = new AddDataWindow();

            // Open the window as a dialog
            if (addDataWindow.ShowDialog() == true)
            {
                // Add the new data to the list if Save was clicked
                var newData = new SensorData
                {
                    Timestamp = addDataWindow.Timestamp,
                    Pacifier = addDataWindow.Pacifier,
                    Campaign = addDataWindow.Campaign,
                    Sensor = addDataWindow.Sensor,
                    Value = addDataWindow.Value
                };

                allData.Add(newData);
                DisplayData();
            }
        }


        // Edit button click
        private void EditButton_Click(object sender, RoutedEventArgs e)
        {
            if (DataListView.SelectedItems.Count == 1)
            {
                // Get the selected item
                var selectedItem = (SensorData)DataListView.SelectedItem;

                // Open the Edit Data Window with the selected item's data
                EditDataWindow editDataWindow = new EditDataWindow(selectedItem);

                // If Save is clicked, update the entry with the new data
                if (editDataWindow.ShowDialog() == true)
                {
                    // Update the selected item with new values
                    selectedItem.Timestamp = editDataWindow.Timestamp;
                    selectedItem.Pacifier = editDataWindow.Pacifier;
                    selectedItem.Campaign = editDataWindow.Campaign;
                    selectedItem.Sensor = editDataWindow.Sensor;
                    selectedItem.Value = editDataWindow.Value;

                    // Refresh the data display
                    DisplayData();
                }
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

            // Check if comboBox is not null
            if (comboBox != null)
            {
                comboBox.SelectedIndex = -1;
            }
        }
        private void ComboBox_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            var comboBox = sender as ComboBox;

            // Check if comboBox is not null
            if (comboBox != null)
            {
                if (comboBox.SelectedItem == null)
                {
                    comboBox.SelectedIndex = -1; // Reset selection if nothing is chosen
                }
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
