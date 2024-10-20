using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using InfluxDB.Client;
using InfluxDB.Client.Writes;
using SmartPacifier.Interface.Services;

namespace SmartPacifier.BackEnd.Database.InfluxDB.Managers
{
    public partial class ManagerPacifiers : IDatabaseService
    {
        private readonly InfluxDBClient _client;
        private readonly IDatabaseService _databaseService;
        private readonly string _bucket = "SmartPacifier-Bucket1";
        private readonly string _org = "thu-de";

        public ManagerPacifiers(IDatabaseService databaseService, InfluxDBClient client)
        {
            _databaseService = databaseService;
            _client = client;
        }

        public async Task WriteDataAsync(string measurement, Dictionary<string, object> fields, Dictionary<string, string> tags)
        {
            await _databaseService.WriteDataAsync(measurement, fields, tags);
        }

        public List<string> ReadData(string query)
        {
            return _databaseService.ReadData(query);
        }

        public async Task<List<string>> GetCampaignsAsync()
        {
            return await _databaseService.GetCampaignsAsync();
        }

        public async Task AddPacifierAsync(string campaignName, string pacifierId)
        {
            var tags = new Dictionary<string, string>
            {
                { "campaign_name", campaignName },
                { "pacifier_id", pacifierId }
            };

            var fields = new Dictionary<string, object>
            {
                { "status", "assigned" }
            };

            await WriteDataAsync("pacifiers", fields, tags);
            Console.WriteLine($"Added pacifier: {pacifierId} to campaign: {campaignName}\n");
        }

        // Corrected method to retrieve pacifiers for a given campaign using InfluxDBClient
        public async Task<List<string>> GetPacifiersAsync(string campaignName)
        {
            var pacifiers = new List<string>();
            try
            {
                var fluxQuery = $"from(bucket: \"{_bucket}\") " +
                                $"|> range(start: -30d) " +
                                $"|> filter(fn: (r) => r[\"_measurement\"] == \"pacifiers\" and r[\"campaign_name\"] == \"{campaignName}\") " +
                                $"|> keep(columns: [\"pacifier_id\"]) " +
                                $"|> distinct(column: \"pacifier_id\")";

                var queryApi = _client.GetQueryApi();  // Use the InfluxDBClient's Query API
                var tables = await queryApi.QueryAsync(fluxQuery, _org);

                foreach (var table in tables)
                {
                    foreach (var record in table.Records)
                    {
                        var pacifierId = record.GetValueByKey("pacifier_id")?.ToString();
                        if (!string.IsNullOrEmpty(pacifierId))
                        {
                            pacifiers.Add(pacifierId);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error retrieving pacifiers: {ex.Message}");
            }

            return pacifiers;
        }

    }
}
