using System;
using System.Collections.Generic;
using InfluxDB.Client;
using InfluxDB.Client.Api.Domain;
using InfluxDB.Client.Writes;
using SmartPacifier.Interface.Services;

namespace SmartPacifier.BackEnd.Database.InfluxDB.Connection
{
    public class InfluxDatabaseService : IDatabaseService
    {
        private static InfluxDatabaseService? _instance;
        private static readonly object _lock = new object();
        private readonly InfluxDBClient _client;
        private readonly string _bucket = "IOT";
        private readonly string _org = "thu-de";  // Replace with your actual organization name

        protected InfluxDatabaseService(string url, string token)
        {
            _client = new InfluxDBClient(url, token);
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

        // Implement WriteData method
        public void WriteData(string measurement, Dictionary<string, object> fields, Dictionary<string, string> tags)
        {
            var point = PointData.Measurement(measurement).Timestamp(DateTime.UtcNow, WritePrecision.Ns);
            foreach (var tag in tags) point = point.Tag(tag.Key, tag.Value);
            foreach (var field in fields) point = point.Field(field.Key, field.Value);

            var writeApi = _client.GetWriteApi();
            writeApi.WritePoint(point, _bucket, _org);
        }

        // Implement ReadData method
        public List<string> ReadData(string query)
        {
            var queryApi = _client.GetQueryApi();
            var tables = queryApi.QueryAsync(query, _org).Result;

            var results = new List<string>();
            foreach (var table in tables)
            {
                foreach (var record in table.Records)
                {
                    results.Add(record.ToString());
                }
            }
            return results;
        }

        // High-level methods will be overridden by subclasses
        public virtual void CreateNewCampaign(string campaignName)
        {
            throw new NotImplementedException("This method must be implemented by the subclass.");
        }

        public virtual bool DoesCampaignExist(string campaignName)
        {
            throw new NotImplementedException("This method must be implemented by the subclass.");
        }
    }
}
