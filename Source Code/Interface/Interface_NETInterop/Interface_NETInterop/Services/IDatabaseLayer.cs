namespace SmartPacifier.Interface.Services
{
    public interface IDatabaseService
    {
        Task WriteDataAsync(string measurement, Dictionary<string, object> fields, Dictionary<string, string> tags); // Updated to Task
        List<string> ReadData(string query);
    }
}
