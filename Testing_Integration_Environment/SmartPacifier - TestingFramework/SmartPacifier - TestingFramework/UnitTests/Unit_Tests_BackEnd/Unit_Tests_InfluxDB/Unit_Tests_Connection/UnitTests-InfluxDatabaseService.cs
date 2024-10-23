﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using InfluxDB.Client;
using SmartPacifier.BackEnd.Database.InfluxDB.Connection;
using Xunit;

namespace SmartPacifier___TestingFramework.UnitTests.Unit_Tests_BackEnd.Unit_Tests_InfluxDB.Unit_Tests_Connection
{

    public class UnitTests_InfluxDatabaseService
    {
        /*
                [Fact]
                public async Task Constructor_ShouldInitializeClient_AndAuthenticate_WithCorrectUrlAndToken()
                {
                    // Arrange
                    string url = "http://localhost:8086";
                    string validToken = "Ui71geKMxY2e7R5hcknCQivDIiK7drc3jJl5WZ6nIHMpGkzKAAPxLelsWePJUCt-qLPeB6k9z8YAXkcWZGM1qA==";

                    // Act
                    var service = InfluxDatabaseService.GetInstance(url, validToken);
                    var client = service.GetClient();

                    // Assert
                    Assert.NotNull(client);  // Ensure client is initialized
                    Assert.IsType<InfluxDBClient>(client);  // Ensure the client is of correct type

                    // Make a real query to ensure authentication
                    var pingResult = await client.PingAsync();  // Example ping or actual query

                    Assert.True(pingResult, "The service failed to authenticate or connect to the database.");
                }




            }
            

        [Fact]
        public void GetInstance_ShouldReturnSameInstance_WhenCalledMultipleTimes() // Removed async as it's not needed
        {
            // Arrange
            string url = "http://localhost:8086";
            string validToken = "U171geMKxY2e7RShcknCQiVDIiK7drc3jJ5WZ6nIHMPGkzKAAPxLeIsWePJUCt=qLP6k9z8YAXkcwLZGM1qA==";

            // Act
            var serviceInstance1 = InfluxDatabaseService.GetInstance(url, validToken);
            var serviceInstance2 = InfluxDatabaseService.GetInstance(url, validToken);

            // Assert
            Assert.NotNull(serviceInstance1); // Ensure first instance is created
            Assert.NotNull(serviceInstance2); // Ensure second instance is also not null
            Assert.Same(serviceInstance1, serviceInstance2); // Ensure both are the same instance
        }
        */

        [Fact]
        public void GetClient_ShouldReturnValidClient_WhenCalledAfterInitialization()
        {
            // Arrange
            string url = "http://localhost:8086";
            string validToken = "U171geMKxY2e7RShcknCQiVDIiK7drc3jJ5WZ6nIHMPGkzKAAPxLeIsWePJUCt=qLP6k9z8YAXkcwLZGM1qA==";

            // Act
            var service = InfluxDatabaseService.GetInstance(url, validToken); // Assuming GetInstance initializes the _client
            var client = service.GetClient(); // Calling GetClient

            // Assert
            Assert.NotNull(client); // Ensure that the client is not null
            Assert.IsType<InfluxDBClient>(client); // Ensure the returned object is of type InfluxDBClient
        }


    }
}