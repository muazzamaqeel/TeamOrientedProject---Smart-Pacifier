namespace SmartPacifier.Interface.Services
{
    public interface IDatabaseService
    {
        void WriteData(string measurement, Dictionary<string, object> fields, Dictionary<string, string> tags);
        List<string> ReadData(string query);
    }
}
