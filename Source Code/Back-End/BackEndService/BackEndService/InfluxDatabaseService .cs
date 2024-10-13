using System;
using System.Collections.Generic;
using InfluxDB.Client;
using InfluxDB.Client.Api.Domain;
using InfluxDB.Client.Writes;
using Interface_NETInterop;

namespace BackEndService
{
    public class InfluxDatabaseService : IDatabaseService
    {
        private static InfluxDatabaseService _instance;
        private static readonly object _lock = new object();

        private readonly InfluxDBClient _client;
        private readonly string _bucket = "SmartPacifier-Bucket1";
        private readonly string _org = "thu-de";  // Replace with your actual organization name

        // Private constructor to prevent direct instantiation
        private InfluxDatabaseService(string url, string token)
        {
            _client = InfluxDBClientFactory.Create(url, token);
        }

        // Singleton method to get the instance of the service
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

        public void WriteData(string measurement, Dictionary<string, object> fields, Dictionary<string, string> tags)
        {
            try
            {
                var point = PointData.Measurement(measurement)
                    .Timestamp(DateTime.UtcNow, WritePrecision.Ns);

                foreach (var tag in tags)
                {
                    point = point.Tag(tag.Key, tag.Value);
                }

                foreach (var field in fields)
                {
                    point = point.Field(field.Key, field.Value);
                }

                using (var writeApi = _client.GetWriteApi())
                {
                    writeApi.WritePoint(point, _bucket, _org);
                }
            }
            catch (Exception ex)
            {
                throw new Exception($"Error writing data: {ex.Message}");
            }
        }

        public List<string> ReadData(string query)
        {
            try
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
            catch (Exception ex)
            {
                throw new UnauthorizedAccessException("Unauthorized access. Check token and permissions.", ex);
            }
        }
    }
}
