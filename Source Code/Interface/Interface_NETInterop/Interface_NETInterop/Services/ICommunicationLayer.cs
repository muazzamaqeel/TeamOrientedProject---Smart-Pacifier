namespace SmartPacifier.Interface.Services
{
    public interface ICommunicationLayer
    {
        string ExecuteScript(string pythonCode);
    }
}
