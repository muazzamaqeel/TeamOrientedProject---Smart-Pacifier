using SmartPacifier.BackEnd.IOTProtocols;
using System;

class TestClass
{
    static async Task Main(string[] args)
    {
	Broker broker = Broker.Instance;
	await broker.ConnectBroker();
	await broker.SubscribeToAll();
	while(true){
	    //broker.ReadBrokerOutput();
	    Thread.Sleep(1000);
	}
    }
}
