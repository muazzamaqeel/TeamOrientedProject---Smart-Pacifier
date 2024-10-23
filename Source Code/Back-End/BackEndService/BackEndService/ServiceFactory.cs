using SmartPacifier.BackEnd.Database.InfluxDB.Connection;
using SmartPacifier.Interface.Services;
using SmartPacifier.BackEnd.Database.InfluxDB.Managers;


//<summary>
//This class is a factory class that creates the services that are needed by the backend
//It implements the IServiceFactory interface
//The CreateAlgorithmService method creates an instance of the AlgorithmLayer.PythonScriptEngine class
//The CreateDatabaseService method creates an instance of the Database.InfluxDB.Connection.InfluxDatabaseService class
//The reason is this we use this factory class to create in the App.xaml.cs file directly
//</summary>

namespace SmartPacifier.BackEnd
{
    public class ServiceFactory: IServiceFactory


    {
        public IAlgorithmLayer CreateAlgorithmService()
        {
            return AlgorithmLayer.PythonScriptEngine.GetInstance();
        }

        IDatabaseService IServiceFactory.CreateDatabaseService(string url, string token)
        {
            return InfluxDatabaseService.GetInstance(url, token);
        }
    }
}
