using System;
using System.Collections.Generic;
using System.Windows;
using Interface_NETInterop;  // Reference 
using BackEndService;        // Reference 

namespace Smart_Pacifier___Tool
{
    public partial class Test : Window
    {
        private readonly IDatabaseService _databaseService;

        public Test()
        {
            InitializeComponent();

            // Initialize the InfluxDatabaseService with the InfluxDB URL and the provided token
            _databaseService = new InfluxDatabaseService("http://localhost:8086", "F3GXAaIr_gF4_GEFIE5otsy9UC-qcfRYwYYM2ojrga2YTxTi2lQPePxBgevqowEb6eIgmn1mih0ktZUgBSz1GA==");
        }

        // Write data button click event
        private void OnWriteDataButtonClick(object sender, RoutedEventArgs e)
        {
            try
            {
                // Sample data to write to InfluxDB
                var fields = new Dictionary<string, object>
                {
                    { "temperature", 37.2 },
                    { "humidity", 55 }
                };

                var tags = new Dictionary<string, string>
                {
                    { "sensor", "pacifier1" }
                };

                // Write the data to InfluxDB with the correct bucket name
                _databaseService.WriteData("environment", fields, tags);

                MessageBox.Show("Data written to SmartPacifier-Bucket1.");
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Error writing data: {ex.Message}");
            }
        }

        // Read data button click event
        private void OnReadDataButtonClick(object sender, RoutedEventArgs e)
        {
            try
            {
                // Query to read data from the last hour
                string fluxQuery = @"
                    from(bucket: ""SmartPacifier-Bucket1"")
                    |> range(start: -1h)
                    |> filter(fn: (r) => r._measurement == ""environment"")
                ";

                // Read the data from InfluxDB
                var results = _databaseService.ReadData(fluxQuery);

                // Display the results in the TextBox
                ResultsTextBox.Text = string.Join(Environment.NewLine, results);
            }
            catch (UnauthorizedAccessException ex)
            {
                MessageBox.Show($"Error reading data: {ex.Message}");
            }
        }
    }
}
