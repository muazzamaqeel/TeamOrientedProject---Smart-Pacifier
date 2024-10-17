using System;
using System.Windows;
using SmartPacifier.Interface.Services;
using SmartPacifier.BackEnd.Database.InfluxDB.Connection;
using SmartPacifier.BackEnd.DatabaseLayer.InfluxDB.Managers;

namespace Smart_Pacifier___Tool
{
    public partial class App : Application
    {
        // Static property to access the Singleton database service globally
        public static IDatabaseService? DatabaseService { get; private set; }

        protected override void OnStartup(StartupEventArgs e)
        {
            base.OnStartup(e);

            // Initialize the Singleton instance of the database service
            DatabaseService = CreateDatabaseService("http://localhost:8086", "DNy29b40GIMQusZWWYD1AWJxfR6gyJ2gK4TjpsmNA3Pc_6gQilT6HY_QC5Ld3BL1x4NDbp-yR69bXMKJ8-xgug==");

            // Pass DatabaseService to ManagerPacifiers and then pass it to the Test window
            var managerPacifiers = new ManagerPacifiers(DatabaseService);
            var testWindow = new Temp.Test(managerPacifiers);
            testWindow.Show();
        }

        // Factory method to create a database service
        public IDatabaseService CreateDatabaseService(string url, string token)
        {
            return InfluxDatabaseService.GetInstance(url, token); // Singleton
        }
    }
}
