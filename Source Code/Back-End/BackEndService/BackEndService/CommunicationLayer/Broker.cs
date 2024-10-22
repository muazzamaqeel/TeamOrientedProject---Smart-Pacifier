using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Diagnostics;

using MQTTnet;
using MQTTnet.Protocol;
using MQTTnet.Client;

namespace SmartPacifier.BackEnd.IOTProtocols
{
    public class Broker
    {
        private static Broker _brokerInstance;
        private static readonly object _lock = new object();

	private IMqttClient _mqttClient;
	//private readonly MQTTnet.Server.MqttClient _mqttServer;
	
        private readonly string _brokerAddress = "localhost";
        private readonly int _brokerPort = 1883;

        private Process _brokerProcess;
	private Task _brokerTask;
	private bool _isBrokerRunning = false;

	/// <summary>
	/// Constructor for the Broker class
	/// </summary>
        private Broker()
        {
	    var factory = new MqttFactory();
	    _mqttClient = factory.CreateMqttClient();
	    StartBroker();
	    //ConnectBroker();
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
        public void StartBroker()
	{
	    _brokerTask = Task.Run(() =>
	    {
		_isBrokerRunning = true;
		var processStartInfo = new ProcessStartInfo();
		processStartInfo.FileName = "mosquitto"; // path to Mosquitto executable
		processStartInfo.Arguments = ""; //Mosquitto command-line arguments
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
		    // return true;
		}
		else
		{
		    Console.WriteLine("Failed to start Mosquitto process.");
		    _isBrokerRunning = false;
		    //return false;
		}
	    });
	    //return false;
	    MonitorTaskStatus();
	}
	/// <summary>
        /// Prints the task status periodically.
        /// </summary>
        public void MonitorTaskStatus()
        {
            Task.Run(() =>
            {
                while (_isBrokerRunning)
                {
                    Console.WriteLine("Broker process is still running...");
                    Thread.Sleep(1000); // Wait 1 second before checking again
                }

                Console.WriteLine("Broker process has stopped.");
            });
        }

        public void StopBroker()
        {
            _brokerProcess.Close();
        }

        public async Task ConnectBroker()
	{
	    // Use TCP connection.
	    var options = new MqttClientOptionsBuilder()
		.WithTcpServer("broker.hivemq.com", 1883) // Optional port
		.Build();
	    
	    try
	    {
		await _mqttClient.ConnectAsync(options);
	    }
	    catch (Exception ex)
	    {
		Console.WriteLine("Failed to connect to MQTT broker: " + ex.Message);
		return;
	    }
	   Console.WriteLine("Sucessfully Connected to MQTT broker "); 
	}
	// public async Task SendMessageToAllSensorNodesAsync(string message)
	// {
	//     var topic = "to_all_sensor_nodes"; // Adjust the topic as needed
	//     var mqttMessage = new MqttApplicationMessageBuilder()
	// 	.WithTopic(topic)
	// 	.WithPayload(message)
	// 	.WithQualityOfService(MqttQualityOfService.AtLeastOnce)
	// 	.Build();

	//     try
	//     {
	// 	await _mqttClient.PublishAsync(mqttMessage);
	// 	Console.WriteLine("Message sent to all sensor nodes.");
	//     }
	//     catch (Exception ex)
	//     {
	// 	Console.WriteLine("Failed to send message to sensor nodes: " + ex.Message);
	//     }
	// }
    }
}
