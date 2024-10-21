using System;
using System.Windows;
using SmartPacifier.Interface.Services;
using SmartPacifier.Interface;  // Reference the Interface
using Smart_Pacifier___Tool.Temp;

namespace Smart_Pacifier___Tool
{
    public partial class App : Application, IServiceFactory
    {
        protected override void OnStartup(StartupEventArgs e)
        {
            base.OnStartup(e);

            // Create services using the factory methods (implemented in the same class)
            IAlgorithmLayer algorithmService = CreateAlgorithmService();
            IDatabaseService databaseService = CreateDatabaseService("http://localhost:8086", "Ui71geKMxY2e7R5hcknCQivDIiK7drc3jJl5WZ6nIHMpGkzKAAPxLelsWePJUCt-qLPeB6k9z8YAXkcWZGM1qA==");

            // Open the AlgoTest window
            //AlgoTest algoTestWindow = new AlgoTest(serviceFactory);
            //algoTestWindow.Show();

            // Uncomment the following if you want to open the Test window as well:
            //Test testWindow = new Test(databaseService);
            //testWindow.Show();
            // Pass services to the windows
            //var algoTestWindow = new Temp.AlgoTest(algorithmService);
            //var testWindow = new Temp.Test(databaseService);

            //algoTestWindow.Show();
            //indow.Show();
        }

        // Factory method to create an algorithm service
        public IAlgorithmLayer CreateAlgorithmService()
        {
            return SmartPacifier.BackEnd.AlgorithmLayer.PythonScriptEngine.GetInstance(); // Use GetInstance()
        }

        // Factory method to create a database service
        public IDatabaseService CreateDatabaseService(string url, string token)
        {
            return SmartPacifier.BackEnd.Database.InfluxDB.Connection.InfluxDatabaseService.GetInstance(url, token); // Use GetInstance()
        }
    }
}
