namespace SmartPacifier.Interface.Services
{
    public interface IDatabaseService
    {
        Task WriteDataAsync(string measurement, Dictionary<string, object> fields, Dictionary<string, string> tags); // Updated to Task
        List<string> ReadData(string query);
        Task<List<string>> GetCampaignsAsync();  // Asynchronous method to retrieve campaigns

    }


    public interface IManagerCampaign : IDatabaseService
    {
        Task AddCampaignAsync(string campaignName);  // Campaign-specific method
    }


    public interface IManagerPacifiers : IDatabaseService
    {
        Task AddPacifierAsync(string campaignName, string pacifierId);  // Pacifier-specific method
        Task<List<string>> GetPacifiersAsync(string campaignName);  // Retrieve pacifiers for a campaign
    }


    public interface IManagerSensors : IDatabaseService
    {
        Task AddSensorDataAsync(string pacifierId, float ppgValue, float imuAccelX, float imuAccelY, float imuAccelZ);  // Sensor-specific method
    }
}
