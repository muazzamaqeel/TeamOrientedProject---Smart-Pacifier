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
        private readonly InfluxDBClient _client;
        private readonly string _bucket = "SmartPacifier-Bucket1";  // Correct bucket name
        private readonly string _org = "thu-de";                    // Correct organization name

        public InfluxDatabaseService(string url, string token)
        {
            // Initialize the InfluxDB client with the correct URL and token
            _client = new InfluxDBClient(url, token);
        }

        public void WriteData(string measurement, Dictionary<string, object> fields, Dictionary<string, string> tags)
        {
            try
            {
                // Create a new PointData for the measurement
                var point = PointData.Measurement(measurement)
                                     .Timestamp(DateTime.UtcNow, WritePrecision.Ns);

                // Add each tag to the point
                foreach (var tag in tags)
                {
                    point = point.Tag(tag.Key, tag.Value);
                }

                // Add each field to the point
                foreach (var field in fields)
                {
                    point = point.Field(field.Key, field.Value);
                }

                using (var writeApi = _client.GetWriteApi())
                {
                    // Write the point to InfluxDB using the correct arguments
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

                // Convert the query result to a list of strings
                return fluxQuery?.Result.Select(x => x.ToString()).ToList() ?? new List<string>();
            }
            catch (Exception ex)
            {
                // Log more detailed error message
                Console.WriteLine($"Error reading data from InfluxDB: {ex.Message}");
                throw new UnauthorizedAccessException("Unauthorized access. Check token and permissions.", ex);
            }
        }
    }
}
