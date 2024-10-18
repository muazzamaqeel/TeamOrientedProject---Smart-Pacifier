using System;
using Xunit;
using TestStack.White; // For UI testing
using TestStack.White.UIItems; // For interacting with UI items
using TestStack.White.UIItems.Finders; // For finding UI elements
using TestStack.White.UIItems.WindowItems; // For window operations
using TestStack.White.Factory; // For InitializeOption
using System.IO;

namespace SmartPacifier_UITests.FrontEnd.TestEnv_SmartPacifier.UI_WPF.Test_SettingsTab
{
    [Trait("Category", "SettingsTests")]
    public class Components_Settings
    {
        [Fact]
        public void ButtonText_ShouldMatchExpectedValue()
        {
            // Use the absolute path to the SmartPacifier.UI.exe
            var appPath = @"C:\programming\TeamOrientedProject---Smart-Pacifier\Source Code\Front-End\UI (WPF)\Smart Pacifier - Tool\bin\Debug\net5.0-windows\SmartPacifier.UI.exe";

            // Launch the SmartPacifier UI application
            TestStack.White.Application app = TestStack.White.Application.Launch(appPath);

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
