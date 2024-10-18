using System;
using Xunit;
using TestStack.White; // For UI testing
using TestStack.White.UIItems; // For interacting with UI items
using TestStack.White.UIItems.Finders; // For finding UI elements
using TestStack.White.UIItems.WindowItems; // For window operations
using TestStack.White.Factory; // For InitializeOption

namespace SmartPacifier_UITests.FrontEnd.TestEnv_SmartPacifier.UI_WPF.Test_SettingsTab
{
    internal class Components_Settings
    {
        [Fact]
        public void ButtonText_ShouldMatchExpectedValue()
        {
            // Arrange: Set a relative path based on the current directory
            var baseDirectory = AppDomain.CurrentDomain.BaseDirectory;

            // Navigate to the location of the executable relative to the test project's bin folder
            var applicationPath = System.IO.Path.Combine(baseDirectory, @"..\..\..\..\UI (WPF)\Smart Pacifier - Tool\bin\Debug\net5.0-windows\SmartPacifier.UI.exe");

            // Launch the SmartPacifier UI application
            TestStack.White.Application app = TestStack.White.Application.Launch(applicationPath);

            // Find the main window of the application
            Window mainWindow = app.GetWindow("MainWindow", InitializeOption.NoCache);

            // Act: Find the button inside the main window
            Button myButton = mainWindow.Get<Button>(SearchCriteria.ByAutomationId("MyButtonAutomationId"));

            // Assert: Verify the button's text
            Assert.Equal("Click Me", myButton.Text);

            // Cleanup: Close the application after the test
            app.Close();
        }
    }
}
