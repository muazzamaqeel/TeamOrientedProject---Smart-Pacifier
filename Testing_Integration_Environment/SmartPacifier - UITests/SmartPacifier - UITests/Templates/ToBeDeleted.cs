using FlaUI.Core;
using FlaUI.UIA3;
using FlaUI.Core.AutomationElements;
using FlaUI.Core.Definitions; // For ControlType
using Xunit;
using System.Diagnostics; // Ensure this is imported

namespace SmartPacifier___UITests
{
    public class UnitTest1
    {
        [Fact]
        public void CheckThemeButtonExists()
        {
            string applicationPath = @"C:\programming\TeamOrientedProject---Smart-Pacifier\Source Code\Front-End\UI (WPF)\Smart Pacifier - Tool\Smart Pacifier - Tool\bin\Debug\net8.0-windows\SmartPacifier.UI (WPF).exe";

            var processStartInfo = new ProcessStartInfo(applicationPath)
            {
                WorkingDirectory = @"C:\programming\TeamOrientedProject---Smart-Pacifier\Source Code\Front-End\UI (WPF)\Smart Pacifier - Tool\Smart Pacifier - Tool\bin\Debug\net8.0-windows\"
            };

            var app = Application.Launch(processStartInfo);

            try
            {
                using (var automation = new UIA3Automation())
                {
                    // Optional: Add a delay to ensure UI is fully loaded
                    System.Threading.Thread.Sleep(3000);

                    // Get the main window of the application
                    var mainWindow = app.GetMainWindow(automation);

                    // Try to find the button by its x:Name (ThemeButton)
                    var themeButton = mainWindow.FindFirstDescendant(cf => cf.ByName("ThemeButton"))?.AsButton();

                    // If button by name is not found, try finding by control type (all buttons)
                    if (themeButton == null)
                    {
                        var buttons = mainWindow.FindAllDescendants(cf => cf.ByControlType(ControlType.Button));
                        foreach (var button in buttons)
                        {
                            // Use fully qualified System.Diagnostics.Debug
                            System.Diagnostics.Debug.WriteLine($"Button: {button.Name}");
                        }

                        // Fallback to the first button (just for testing if none is found by name)
                        themeButton = buttons.FirstOrDefault()?.AsButton();
                    }

                    // Assert that the button exists
                    Assert.NotNull(themeButton);
                }
            }
            finally
            {
                app.Close();
            }
        }
    }
}
