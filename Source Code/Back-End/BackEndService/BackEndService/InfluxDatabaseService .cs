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
        private readonly string _bucket = "SmartPacifier-Bucket1"; // Match with the bucket name in InfluxDB
        private readonly string _org = "thu-de";  // Match with your organization name

        public InfluxDatabaseService(string url, string token)
        {
            // Correct initialization of the InfluxDB client
            _client = new InfluxDBClient(url, token);
        }

        public void WriteData(string measurement, Dictionary<string, object> fields, Dictionary<string, string> tags)
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

        public List<string> ReadData(string query)
        {
            var queryApi = _client.GetQueryApi();
            var fluxQuery = queryApi.QueryAsync(query, _org);

            // Convert the query result to a list of strings
            return fluxQuery?.Result.Select(x => x.ToString()).ToList() ?? new List<string>();
        }
    }
}
