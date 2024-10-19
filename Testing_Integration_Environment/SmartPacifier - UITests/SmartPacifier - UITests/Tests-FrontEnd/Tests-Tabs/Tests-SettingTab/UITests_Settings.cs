using FlaUI.Core;
using FlaUI.UIA3;
using Xunit;
using SmartPacifier___UITests.Templates; // Importing the Buttons class

namespace SmartPacifier___UITests.Tests_FrontEnd.Tests_Tabs.Tests_SettingTab
{
    public class UITests_Settings
    {
        public readonly Application app;

        // Constructor to pass the launched application
        public UITests_Settings(Application app)
        {
            this.app = app;
        }

        public void CheckButtonsExistenceInSettingsTab()
        {
            try
            {
                using (var automation = new UIA3Automation())
                {
                    Thread.Sleep(3000); // Ensure the UI is loaded properly
                    var mainWindow = app.GetMainWindow(automation);

                    var buttonsHelper = new Buttons(); // Instance of the Buttons class

                    // Check for the existence of buttons in the Settings tab
                    var switchModeButton = buttonsHelper.FindButtonByName(mainWindow, "SwitchModeButton");
                    var themeButton = buttonsHelper.FindButtonByName(mainWindow, "ThemeButton");
                    var userModeButton = buttonsHelper.FindButtonByName(mainWindow, "UserModeButton");
                    var developerModeButton = buttonsHelper.FindButtonByName(mainWindow, "DeveloperModeButton");

                    // Assert that each button exists
                    Assert.NotNull(switchModeButton);
                    Assert.NotNull(themeButton);
                    Assert.NotNull(userModeButton);
                    Assert.NotNull(developerModeButton);
                }
            }
            finally
            {
                // Note: Don't close the app here; it will be closed by Main_TestSuite
            }
        }
    }
}
