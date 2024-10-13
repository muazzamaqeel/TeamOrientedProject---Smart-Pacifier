using System.Windows;
using Interface_NETInterop;
using AlgorithmLayer;  // Ensure AlgorithmLayer is imported correctly
using Smart_Pacifier___Tool.Temp;

namespace Smart_Pacifier___Tool
{
    public partial class App : Application
    {
        protected override void OnStartup(StartupEventArgs e)
        {
            base.OnStartup(e);

            // Create service factory instance
            IServiceFactory serviceFactory = new ServiceFactory();

            // Open the AlgoTest window
            AlgoTest algoTestWindow = new AlgoTest(serviceFactory);
            algoTestWindow.Show();

            // Uncomment the following if you want to open the Test window as well:
            Test testWindow = new Test(serviceFactory);
            testWindow.Show();
        }
    }
}
