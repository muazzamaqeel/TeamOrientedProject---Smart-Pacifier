using System.Diagnostics;
using SmartPacifier.Interface.Services;

namespace SmartPacifier.BackEnd.AlgorithmLayer
{

    /// <summary>
    /// The PythonScriptEngine class is used to execute Python scripts
    /// </summary>
    public class PythonScriptEngine : IAlgorithmLayer
    {
        private static PythonScriptEngine? _instance;
        private static readonly object _lock = new object();

        private PythonScriptEngine() { }

        public static PythonScriptEngine GetInstance()
        {
            if (_instance == null)
            {
                lock (_lock)
                {
                    if (_instance == null)
                    {
                        _instance = new PythonScriptEngine();
                    }
                }
            }
            return _instance;
        }

        public string ExecuteScript(string code)
        {
            try
            {
                var startInfo = new ProcessStartInfo
                {
                    FileName = "python",
                    Arguments = $"-c \"{code}\"",
                    RedirectStandardOutput = true,
                    RedirectStandardError = true,
                    UseShellExecute = false,
                    CreateNoWindow = true
                };

                using (var process = Process.Start(startInfo))
                {
                    if (process == null)
                    {
                        throw new InvalidOperationException("Process failed to start.");
                    }

                    string output = process.StandardOutput.ReadToEnd();
                    string error = process.StandardError.ReadToEnd();

                    if (!string.IsNullOrEmpty(error))
                    {
                        throw new Exception($"Python Error: {error}");
                    }

                    return output;
                }
            }
            catch (Exception ex)
            {
                throw new Exception($"Error executing Python script: {ex.Message}");
            }
        }
    }
}
