using Interface_NETInterop;
using BackEndService;
using Python.Runtime;

namespace AlgorithmLayer
{
    public class ServiceFactory : IServiceFactory
    {
        public IAlgorithmService CreateAlgorithmService()
        {
            return new PythonScriptRunner();
        }

        public IDatabaseService CreateDatabaseService()
        {
            // Token and URL for InfluxDB are handled within BackEndService
            string influxDbUrl = "http://localhost:8086";
            string influxDbToken = "F3GXAaIr_gF4_GEFIE5otsy9UC-qcfRYwYYM2ojrga2YTxTi2lQPePxBgevqowEb6eIgmn1mih0ktZUgBSz1GA==";  // Provided token

            return InfluxDatabaseService.GetInstance(influxDbUrl, influxDbToken);
        }
    }

    public class PythonScriptRunner : IAlgorithmService
    {
        private static bool isPythonInitialized = false;

        public string RunPythonCode(string code)
        {
            try
            {
                string baseDirectory = AppDomain.CurrentDomain.BaseDirectory;
                string pythonDllPath = Path.Combine(baseDirectory, "python311.dll");

                if (!isPythonInitialized)
                {
                    Runtime.PythonDLL = pythonDllPath;
                    PythonEngine.Initialize();
                    isPythonInitialized = true;
                }

                using (Py.GIL())
                {
                    PythonEngine.RunSimpleString(code);
                }

                return "Python code executed successfully.";
            }
            catch (Exception ex)
            {
                return $"Error: {ex.Message}";
            }
        }
    }
}
