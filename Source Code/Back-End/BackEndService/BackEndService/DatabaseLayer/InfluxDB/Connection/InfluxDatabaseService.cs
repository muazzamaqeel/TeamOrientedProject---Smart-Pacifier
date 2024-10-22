using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using InfluxDB.Client;
using InfluxDB.Client.Api.Domain;
using InfluxDB.Client.Writes;
using SmartPacifier.Interface.Services;

namespace SmartPacifier.BackEnd.Database.InfluxDB.Connection
{
    //<summary>
    // This class connects to InfluxDB and implements the IDatabaseService interface.
    // The WriteData method writes data to InfluxDB.
    // The ReadData method queries InfluxDB.
    //</summary>
    public class InfluxDatabaseService : IDatabaseService
    {
        private static InfluxDatabaseService? _instance;
        private static readonly object _lock = new object();
        private readonly InfluxDBClient _client;
        private readonly string _bucket = "SmartPacifier-Bucket1";
        private readonly string _org = "thu-de";  // Replace with your actual organization name

        private InfluxDatabaseService(string url, string token)
        {
            _client = new InfluxDBClient(url, token); // Use the new constructor directly
        }

        public static InfluxDatabaseService GetInstance(string url, string token)
        {
            if (_instance == null)
            {
                lock (_lock)
                {
                    if (_instance == null)
                    {
                        _instance = new InfluxDatabaseService(url, token);
                    }
                }
            }
            return _instance;
        }

        // Expose InfluxDBClient so other classes can use it
        public InfluxDBClient GetClient()
        {
            return _client;
        }

        public async Task WriteDataAsync(string measurement, Dictionary<string, object> fields, Dictionary<string, string> tags)
        {
            try
            {
                var point = PointData.Measurement(measurement);

                // Add tags to the point
                foreach (var tag in tags)
                {
                    point = point.Tag(tag.Key, tag.Value);
                }

                // Add fields to the point
                foreach (var field in fields)
                {
                    if (field.Value is float)
                        point = point.Field(field.Key, (float)field.Value);
                    else if (field.Value is double)
                        point = point.Field(field.Key, (double)field.Value);
                    else if (field.Value is int)
                        point = point.Field(field.Key, (int)field.Value);
                    else if (field.Value is string)
                        point = point.Field(field.Key, (string)field.Value);
                }

                // Assign timestamp and precision
                point = point.Timestamp(DateTime.UtcNow, WritePrecision.Ns);

                var writeApi = _client.GetWriteApiAsync();
                await writeApi.WritePointAsync(point, _bucket, _org);
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error writing data: {ex.Message}");
            }
        }

        public List<string> ReadData(string query)
        {
            var results = new List<string>();
            // Implementation of data reading logic goes here.
            return results;
        }

        // WriteDataAsync method stays the same as before

        public async Task<List<string>> GetCampaignsAsync()
        {
            var campaigns = new List<string>();
            try
            {
                var fluxQuery = $"from(bucket: \"{_bucket}\") " +
                                "|> range(start: -30d) " +  // Adjust the time range if needed
                                "|> keep(columns: [\"campaign_name\"]) " +
                                "|> distinct(column: \"campaign_name\")";

                // Use _client.GetQueryApi() to access the query API
                var queryApi = _client.GetQueryApi();
                var tables = await queryApi.QueryAsync(fluxQuery, _org);

                Console.WriteLine("Query executed, parsing results...");
                foreach (var table in tables)
                {
                    foreach (var record in table.Records)
                    {
                        var campaignName = record.GetValueByKey("campaign_name")?.ToString();
                        if (!string.IsNullOrEmpty(campaignName))
                        {
                            Console.WriteLine($"Found campaign: {campaignName}");
                            campaigns.Add(campaignName);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error retrieving campaigns: {ex.Message}");
            }

            return campaigns;
        }
    }
}
