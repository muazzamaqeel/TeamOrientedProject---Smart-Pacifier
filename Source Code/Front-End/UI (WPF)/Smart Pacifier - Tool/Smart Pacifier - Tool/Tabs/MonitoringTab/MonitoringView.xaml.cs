using System;
using System.Collections.ObjectModel;
using System.Windows.Controls;

namespace Smart_Pacifier___Tool.Tabs.MonitoringTab
{
    public partial class MonitoringView : UserControl
    {
        public ObservableCollection<PacifierItemViewModel> PacifierItems { get; set; }

        public MonitoringView()
        {
            InitializeComponent();
            PacifierItems = new ObservableCollection<PacifierItemViewModel>();

            // Possible statuses
            string[] statuses = { "Connected", "Interrupted", "Disconnected", "Pending" };
            Random random = new Random();

            // Use a loop to add items
            for (int i = 1; i <= 15; i++)
            {
                var keyValuePairs = new ObservableCollection<KeyValuePair<string, int>>
                {
                    new KeyValuePair<string, int>("Key1", i * 1),
                    new KeyValuePair<string, int>("Key2", i * 2),
                    new KeyValuePair<string, int>("Key3", i * 3)
                };

                PacifierItems.Add(new PacifierItemViewModel
                {
                    DisplayName = $"Pacifier {i}",
                    KeyValuePairs = keyValuePairs,
                    Status = statuses[random.Next(statuses.Length)] // Assign a random status
                });
            }

            this.DataContext = this; // Set DataContext to the current instance
        }
    }

    public class PacifierItemViewModel
    {
        public string DisplayName { get; set; } = string.Empty;
        public ObservableCollection<KeyValuePair<string, int>> KeyValuePairs { get; set; } = new ObservableCollection<KeyValuePair<string, int>>();
        public string Status { get; set; } = "Disconnected"; // Default status
    }
}