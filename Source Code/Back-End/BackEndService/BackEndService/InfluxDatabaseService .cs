using System;
using System.Collections.Generic;
using System.Linq;
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
        private readonly string _bucket = "SmartPacifier-Bucket1";  // Correct bucket name
        private readonly string _org = "thu-de";                    // Correct organization name

        // Private constructor to prevent multiple instances
        private InfluxDatabaseService(string url, string token)
        {
            _client = new InfluxDBClient(url, token);
        }

        // Singleton implementation
        public static InfluxDatabaseService GetInstance(string url, string token)
        {
            if (_instance == null)
            {
                lock (_lock) // Thread safety
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

                Console.WriteLine("Data written to InfluxDB.");
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error writing data to InfluxDB: {ex.Message}");
                throw;
            }
        }

        public List<string> ReadData(string query)
        {
            try
            {
                var queryApi = _client.GetQueryApi();
                var fluxQuery = queryApi.QueryAsync(query, _org);

                return fluxQuery?.Result.Select(x => x.ToString()).ToList() ?? new List<string>();
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error reading data from InfluxDB: {ex.Message}");
                throw new UnauthorizedAccessException("Unauthorized access. Check token and permissions.", ex);
            }
        }
    }
}
