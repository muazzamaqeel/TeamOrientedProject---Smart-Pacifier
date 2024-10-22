using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Diagnostics;

using MQTTnet;
using MQTTnet.Server;
using MQTTnet.Client;

namespace SmartPacifier.BackEnd.IOTProtocols
{
    internal class Broker
    {
        private static Broker _brokerInstance;
        private static readonly object _lock = new object();

	private readonly MqttClient _mqttClient;
        private readonly string _brokerAddress = "localhost";
        private readonly int _brokerPort = 1883;

        private Process _brokerProcess;

	/// <summary>
	/// Constructor for the Broker class
	/// </summary>
        private Broker()
        {
            StartBroker();
            _mqttClient = new MqttClient();
        }
	///<summary>
	/// Destructor to clean up the Broker
	///</summary>
        ~Broker()
        {
	    
            StopBroker();
        }

	/// <summary>
       	/// Gettingan Instance of the Broker. If there is no intance
       	/// yet, it will create one. This is threadsafe for
       	/// multithreading
	/// </summary>
        public static Broker Instance
        {
            get
            {
                lock (_lock)
                {
                    if (_brokerInstance == null)
                    {
                        _brokerInstance = new Broker();
                    }
                    return _brokerInstance;
                }
            }
        }

	/// <summary>
	/// Starting Mosquitto as a child process
	/// </summary>
	/// <returns>True if process started sucessfully, false otherwise</returns>
        bool StartBroker()
	{
	    var processStartInfo = new ProcessStartInfo();
	    processStartInfo.FileName = "mosquitto.exe"; // path to Mosquitto executable
	    processStartInfo.Arguments = "-c mosquitto.conf"; //Mosquitto command-line arguments
	    processStartInfo.UseShellExecute = false;
	    processStartInfo.RedirectStandardOutput = true;
	    processStartInfo.RedirectStandardError = true;

	    _brokerProcess = Process.Start(processStartInfo);
	    
	    if (_brokerProcess != null)
	    {
		// Optionally, you can read the output from the Mosquitto process
		var output = _brokerProcess.StandardOutput.ReadToEnd();
		var error = _brokerProcess.StandardError.ReadToEnd();
		Console.WriteLine("Mosquitto output:\n" + output);
		Console.WriteLine("Mosquitto errors:\n" + error);
                return true;
            }
	    else
	    {
		Console.WriteLine("Failed to start Mosquitto process.");
                return false;
            }
	}

        void StopBroker()
        {
            _brokerProcess.Close();
        }

        public async Task ConnectBroker()
	{
	    var options = new MqttClientOptions();
            options.Server = new MqttServer(_brokerAddress, _brokerPort);

            try
            {
                await _mqttClient.ConnectAsync(options);
            }
            catch (Exception ex)
            {
                Console.WriteLine("Failed to connect to MQTT broker: " + ex.Message);
                return;
            }
	    // Subscribe to all messages (adjust the topic filter as needed)
            await _mqttClient.SubscribeAsync(new TopicSubscriptionBuilder()
                .WithTopic("#") // Subscribe to all topics
                .WithQualityOfService(MqttQualityOfService.AtLeastOnce)
                .Build());

            _mqttClient.ApplicationMessageReceived += async (sender, e) =>
            {
                var message = e.ApplicationMessage;
                Console.WriteLine($"Received message: {message.Topic} - {message.Payload}");

                // TODO Store the message 
            };

	}
	public async Task SendMessageToAllSensorNodesAsync(string message)
	{
	    var topic = "to_all_sensor_nodes"; // Adjust the topic as needed
	    var mqttMessage = new MqttApplicationMessageBuilder()
		.WithTopic(topic)
		.WithPayload(message)
		.WithQualityOfService(MqttQualityOfService.AtLeastOnce)
		.Build();

	    try
	    {
		await _mqttClient.PublishAsync(mqttMessage);
		Console.WriteLine("Message sent to all sensor nodes.");
	    }
	    catch (Exception ex)
	    {
		Console.WriteLine("Failed to send message to sensor nodes: " + ex.Message);
	    }
	}
    }
}
