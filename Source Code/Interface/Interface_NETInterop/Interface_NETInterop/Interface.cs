namespace Interface_NETInterop
{
    public interface IDatabaseService
    {
        void WriteData(string measurement, Dictionary<string, object> fields, Dictionary<string, string> tags);
        List<string> ReadData(string query);
    }

    public interface IAlgorithmService
    {
        string RunPythonCode(string code);
    }

    public interface IServiceFactory
    {
        IAlgorithmService CreateAlgorithmService();
        IDatabaseService CreateDatabaseService();
    }
}
