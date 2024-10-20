using System;
using System.Windows;
using SmartPacifier.Interface.Services;
using InfluxDB.Client.Writes;
using InfluxDB.Client.Api.Domain;

namespace Smart_Pacifier___Tool.Temp
{
    public partial class Test : Window
    {
        private readonly IDatabaseService _databaseService;

        public Test(IDatabaseService databaseService)
        {
            InitializeComponent();
            _databaseService = databaseService;
        }


        private async void OnWriteDataButtonClick(object sender, RoutedEventArgs e)
        {
            // Define the campaign and pacifier details
            var campaignName = "TestCampaign";
            var pacifierId = "TestPacifier";

            // Simulated sensor types for the pacifier
            var sensorTypePPG = "PPG_sensor";
            var sensorTypeIMU = "IMU_sensor";

            // Simulated sensor data for PPG (1-3 floating point values)
            var ppgValue1 = 0.85f;
            var ppgValue2 = 0.90f;
            var ppgValue3 = 0.88f;

            // Simulated sensor data for IMU (6-9 floating point values)
            var imuAccelX = 0.001f;
            var imuAccelY = 0.002f;
            var imuAccelZ = 0.003f;
            var imuGyroX = 0.004f;
            var imuGyroY = 0.005f;
            var imuGyroZ = 0.006f;

            // Create the fields dictionary to store PPG sensor values
            var fieldsPPG = new Dictionary<string, object>
            {
                { "ppg_value1", ppgValue1 },
                { "ppg_value2", ppgValue2 },
                { "ppg_value3", ppgValue3 }
            };

                    // Create the fields dictionary to store IMU sensor values
                    var fieldsIMU = new Dictionary<string, object>
            {
                { "imu_accel_x", imuAccelX },
                { "imu_accel_y", imuAccelY },
                { "imu_accel_z", imuAccelZ },
                { "imu_gyro_x", imuGyroX },
                { "imu_gyro_y", imuGyroY },
                { "imu_gyro_z", imuGyroZ }
            };

                    // Create the tags dictionary for metadata
                    var tags = new Dictionary<string, string>
            {
                { "campaign_name", campaignName },
                { "pacifier_id", pacifierId }
            };

            try
            {
                // Write PPG data to the database
                tags["sensor_type"] = sensorTypePPG;  // Add PPG sensor type tag
                await _databaseService.WriteDataAsync("sensor_data", fieldsPPG, tags);

                // Write IMU data to the database
                tags["sensor_type"] = sensorTypeIMU;  // Update sensor type to IMU
                await _databaseService.WriteDataAsync("sensor_data", fieldsIMU, tags);

                // Show success message
                MessageBox.Show("PPG and IMU data written to the database successfully!");
            }
            catch (Exception ex)
            {
                // Handle errors and show the message box if there's a failure
                MessageBox.Show($"Error writing data: {ex.Message}");
            }
        }



    }
}
