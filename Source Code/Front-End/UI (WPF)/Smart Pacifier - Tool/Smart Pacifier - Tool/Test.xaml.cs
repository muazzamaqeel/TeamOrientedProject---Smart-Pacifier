using System;
using System.Collections.Generic;
using System.Windows;
using Interface_NETInterop;  // Reference to interface
using BackEndService;        // Reference to back-end service

namespace Smart_Pacifier___Tool
{
    public partial class Test : Window
    {
        private readonly IDatabaseService _databaseService;

        public Test()
        {
            InitializeComponent();

            // Initialize the InfluxDatabaseService as a Singleton
            _databaseService = InfluxDatabaseService.GetInstance("http://localhost:8086", "F3GXAaIr_gF4_GEFIE5otsy9UC-qcfRYwYYM2ojrga2YTxTi2lQPePxBgevqowEb6eIgmn1mih0ktZUgBSz1GA==");
        }

        // Write data button click event
        private void OnWriteDataButtonClick(object sender, RoutedEventArgs e)
        {
            try
            {
                var fields = new Dictionary<string, object>
                {
                    { "temperature", 37.2 },
                    { "humidity", 55 }
                };

                var tags = new Dictionary<string, string>
                {
                    { "sensor", "pacifier1" }
                };

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
                string fluxQuery = @"
                    from(bucket: ""SmartPacifier-Bucket1"")
                    |> range(start: -1h)
                    |> filter(fn: (r) => r._measurement == ""environment"")
                ";

                var results = _databaseService.ReadData(fluxQuery);
                ResultsTextBox.Text = string.Join(Environment.NewLine, results);
            }
            catch (UnauthorizedAccessException ex)
            {
                MessageBox.Show($"Error reading data: {ex.Message}");
            }
        }
    }
}
