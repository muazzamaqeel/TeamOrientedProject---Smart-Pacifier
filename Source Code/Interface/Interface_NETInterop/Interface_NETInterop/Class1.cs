namespace Interface_NETInterop
{
    public interface IDatabaseService
    {
        // Method to write data to the database
        void WriteData(string measurement, Dictionary<string, object> fields, Dictionary<string, string> tags);

        // Method to read data from the database
        List<string> ReadData(string query);
    }
}
