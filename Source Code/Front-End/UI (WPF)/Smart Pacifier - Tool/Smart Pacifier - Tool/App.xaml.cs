using System;
using System.Windows;
using SmartPacifier.Interface.Services;  // Reference the interface services
using SmartPacifier.BackEnd.Database.InfluxDB.Connection;  // For the database service
using SmartPacifier.BackEnd.Database.InfluxDB.Managers;  // For managers
using SmartPacifier.BackEnd.DatabaseLayer.InfluxDB.Managers;  // For sensor manager
using Smart_Pacifier___Tool.Temp;


namespace Smart_Pacifier___Tool
{
    public partial class App : Application
    {
        private IManagerCampaign ?_managerCampaign;
        private IManagerPacifiers ?_managerPacifiers;
        private IManagerSensors ?_managerSensors;

        protected override void OnStartup(StartupEventArgs e)
        {
            base.OnStartup(e);

            // Create services using the factory methods
            IDatabaseService databaseService = CreateDatabaseService("http://localhost:8086", "Ui71geKMxY2e7R5hcknCQivDIiK7drc3jJl5WZ6nIHMpGkzKAAPxLelsWePJUCt-qLPeB6k9z8YAXkcWZGM1qA==");

            // Initialize manager services using the database service
            _managerCampaign = new ManagerCampaign(databaseService);
            _managerPacifiers = new ManagerPacifiers(databaseService, ((InfluxDatabaseService)databaseService).GetClient());
            _managerSensors = new ManagerSensors(databaseService);

            // Open the Test window and pass the services
            Test testWindow = new Test(_managerCampaign, _managerPacifiers, _managerSensors);
            testWindow.Show();
        }

        // Factory method to create a database service
        public IDatabaseService CreateDatabaseService(string url, string token)
        {
            return InfluxDatabaseService.GetInstance(url, token);  // Use singleton pattern
        }
    }
}
