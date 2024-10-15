namespace SmartPacifier.Interface.Services
{
    public interface IBackendAlgorithmLayer
    {
        string ExecuteScript(string pythonCode);
    }
}
