using SmartPacifier.Interface.Services;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace SmartPacifier.BackEnd.Database.InfluxDB.Managers
{
    public class ManagerCampaign : IManagerCampaign
    {
        private readonly IDatabaseService _databaseService;

        // Constructor to initialize the database service
        public ManagerCampaign(IDatabaseService databaseService)
        {
            _databaseService = databaseService;
        }

        // Implementation of WriteDataAsync from the IDatabaseService interface
        public async Task WriteDataAsync(string measurement, Dictionary<string, object> fields, Dictionary<string, string> tags)
        {
            await _databaseService.WriteDataAsync(measurement, fields, tags);
        }

        // Implementation of ReadData from the IDatabaseService interface
        public List<string> ReadData(string query)
        {
            return _databaseService.ReadData(query);
        }

        // Implementation of GetCampaignsAsync from the IDatabaseService interface
        public async Task<List<string>> GetCampaignsAsync()
        {
            return await _databaseService.GetCampaignsAsync();
        }

        // Method to add a campaign
        public async Task AddCampaignAsync(string campaignName)
        {
            var tags = new Dictionary<string, string>
            {
                { "campaign_name", campaignName }
            };

            var fields = new Dictionary<string, object>
            {
                { "status", "active" }  // Example field
            };

            // Write campaign data to InfluxDB
            await WriteDataAsync("campaigns", fields, tags);

            // Note: Removed reference to ResultsTextBox because this is a non-UI class
            Console.WriteLine($"Added campaign: {campaignName}");
        }
    }
}
