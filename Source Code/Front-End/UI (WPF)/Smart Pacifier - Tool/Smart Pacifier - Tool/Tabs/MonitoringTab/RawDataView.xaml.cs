using System;
using System.Collections.Generic;
using System.Windows;
using System.Windows.Controls;

namespace Smart_Pacifier___Tool.Tabs.MonitoringTab
{
    public partial class RawDataView : UserControl
    {
        private UserControl backLocation;
        public string PacifierName { get; private set; }

        /// <summary>
        /// Initializes a new instance of the <see cref="RawDataView"/> class.
        /// </summary>
        /// <param name="pacifierName">The name of the pacifier to be displayed.</param>
        /// <param name="backLocation">The view to navigate back to when the back button is clicked.</param>
        public RawDataView(string pacifierName, UserControl backLocation)
        {
            InitializeComponent();
            DataContext = this;
            PacifierName = pacifierName;
            this.backLocation = backLocation;
            LoadData();
        }

        private void BackButton_Click(object sender, RoutedEventArgs e)
        {
            var parent = this.Parent as ContentControl;
            if (parent != null)
            {
                parent.Content = backLocation;
            }
        }

        public List<SensorData> SensorEntries { get; set; }


        // Dummy data
        private void LoadData()
        {
            SensorEntries = new List<SensorData>();
            var random = new Random();

            for (int i = 0; i < 1000; i++)
            {
                SensorEntries.Add(new SensorData
                {
                    Timestamp = DateTime.UtcNow.AddMinutes(-i).ToString("yyyy-MM-ddTHH:mm:ssZ"),
                    Sensor1 = random.NextDouble() * 100,
                    Sensor2 = random.NextDouble() * 100,
                    Sensor3 = random.NextDouble() * 100,
                    Sensor4 = random.NextDouble() * 100,
                    Sensor5 = random.NextDouble() * 100
                });
            }
        }
    }

    public class SensorData
    {
        public string Timestamp { get; set; } = string.Empty; // Initialize with default value
        public double Sensor1 { get; set; }
        public double Sensor2 { get; set; }
        public double Sensor3 { get; set; }
        public double Sensor4 { get; set; }
        public double Sensor5 { get; set; }
    }
}