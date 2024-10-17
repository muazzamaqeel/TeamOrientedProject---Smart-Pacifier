namespace SmartPacifier.Interface.Services
{
    public interface IDatabaseService
    {
        // Low-level database operations
        void WriteData(string measurement, Dictionary<string, object> fields, Dictionary<string, string> tags);
        List<string> ReadData(string query);

        // High-level campaign management
        void CreateNewCampaign(string campaignName);
        bool DoesCampaignExist(string campaignName);
    }
}
