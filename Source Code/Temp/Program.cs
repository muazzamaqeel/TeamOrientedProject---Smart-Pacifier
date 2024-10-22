using SmartPacifier.BackEnd.IOTProtocols;

class TestClass
{
    static async Task Main(string[] args)
    {
	Broker broker = Broker.Instance;
	await broker.ConnectBroker();
    }
}
