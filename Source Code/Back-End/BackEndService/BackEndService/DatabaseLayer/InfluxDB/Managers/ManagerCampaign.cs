using SmartPacifier.Interface.Services;
using System;
using System.Collections.Generic;

namespace SmartPacifier.BackEnd.Database.InfluxDB.Managers
{
    public class ManagerCampaign
    {
        private readonly IDatabaseService _databaseService;

        public ManagerCampaign(IDatabaseService databaseService)
        {
            _databaseService = databaseService ?? throw new ArgumentNullException(nameof(databaseService));
        }

        // Method to check if the campaign exists in the InfluxDB
        public bool DoesCampaignExist(string campaignName)
        {
            string query = $"from(bucket: \"IOT\") |> range(start: -1y) |> filter(fn: (r) => r._measurement == \"{campaignName}\")";
            var result = _databaseService.ReadData(query);
            return result.Count > 0;
        }

        // Method to create a new campaign in the InfluxDB bucket
        public void CreateNewCampaign(string campaignName)
        {
            var fields = new Dictionary<string, object>
            {
                { "status", "active" }
            };

            var tags = new Dictionary<string, string>
            {
                { "campaign_name", campaignName }
            };

            _databaseService.WriteData(campaignName, fields, tags);
        }
    }
}
