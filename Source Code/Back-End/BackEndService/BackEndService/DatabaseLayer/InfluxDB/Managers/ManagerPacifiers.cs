using SmartPacifier.Interface.Services;
using System;
using System.Collections.Generic;

namespace SmartPacifier.BackEnd.DatabaseLayer.InfluxDB.Managers
{
    public class ManagerPacifiers
    {
        private readonly IDatabaseService _databaseService;

        public ManagerPacifiers(IDatabaseService databaseService)
        {
            _databaseService = databaseService ?? throw new ArgumentNullException(nameof(databaseService));
        }

        // Method to add a new pacifier to an existing campaign
        public void AddPacifierToCampaign(string campaignName, string pacifierName)
        {
            if (!DoesCampaignExist(campaignName))
            {
                throw new Exception($"Campaign '{campaignName}' does not exist.");
            }

            // Check if pacifier already exists
            string query = $"from(bucket: \"IOT\") |> range(start: -1y) |> filter(fn: (r) => r._measurement == \"{campaignName}\" and r.pacifier_name == \"{pacifierName}\")";
            var result = _databaseService.ReadData(query);

            if (result.Count > 0)
            {
                throw new Exception($"Pacifier '{pacifierName}' already exists in the campaign.");
            }

            // Add the new pacifier as a tag in the existing campaign
            var fields = new Dictionary<string, object>
            {
                { "status", "active" }
            };

            var tags = new Dictionary<string, string>
            {
                { "campaign_name", campaignName },
                { "pacifier_name", pacifierName }
            };

            _databaseService.WriteData(campaignName, fields, tags);
        }

        // Method to check if the campaign exists in the InfluxDB
        public bool DoesCampaignExist(string campaignName)
        {
            string query = $"from(bucket: \"IOT\") |> range(start: -1y) |> filter(fn: (r) => r._measurement == \"{campaignName}\")";
            var result = _databaseService.ReadData(query);
            return result.Count > 0;
        }
    }
}
