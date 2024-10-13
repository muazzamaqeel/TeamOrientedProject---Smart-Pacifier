using System;
using System.Windows;
using Interface_NETInterop;  // Reference to interface

namespace Smart_Pacifier___Tool.Temp
{
    public partial class AlgoTest : Window
    {
        private readonly IAlgorithmService _algorithmService;

        public AlgoTest(IServiceFactory serviceFactory)
        {
            InitializeComponent();

            // Use the factory to create the algorithm service
            _algorithmService = serviceFactory.CreateAlgorithmService();
        }

        private void RunPythonButton_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                // Get Python code from input
                string pythonCode = PythonCodeInput.Text;

                // Run the Python code
                string output = _algorithmService.RunPythonCode(pythonCode);

                // Display the output in the TextBox
                OutputTextBox.Text = output;
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Error running Python code: {ex.Message}");
            }
        }
    }
}
