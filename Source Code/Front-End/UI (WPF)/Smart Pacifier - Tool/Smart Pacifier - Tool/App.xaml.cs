using System;
using System.Windows;
using SmartPacifier.Interface.Services;
using SmartPacifier.Interface;  // Reference the Interface

namespace Smart_Pacifier___Tool
{
    public partial class App : Application, IServiceFactory
    {
        protected override void OnStartup(StartupEventArgs e)
        {
            base.OnStartup(e);

            // Create services using the factory methods (implemented in the same class)
            IAlgorithmLayer algorithmService = CreateAlgorithmService();
            IDatabaseService databaseService = CreateDatabaseService("http://localhost:8086", "mOUzJzz7YYY4DTyt8FoaHZAKP8pgQ15b75VBC81f-pTlgURAg94lulE_arUtbFsdKfPGQKgvY3aQxtnKmWDbtA==");

            // Pass services to the windows
            var algoTestWindow = new Temp.AlgoTest(algorithmService);
            var testWindow = new Temp.Test(databaseService);

            algoTestWindow.Show();
            testWindow.Show();
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
