using FlaUI.Core;
using FlaUI.UIA3;
using Xunit;
using SmartPacifier___TestingFramework.UITests.UI_Templates;//Importing the Text Boxes class

namespace SmartPacifier___TestingFramework.Tests_FrontEnd.Tests_Tabs.Tests_SettingTab
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


        public void CheckTextBoxesExistenceInSettingsTab()
        {
            try
            {
                using (var automation = new UIA3Automation())
                {
                    Thread.Sleep(3000); // Ensure the UI is loaded properly
                    var mainWindow = app.GetMainWindow(automation);

                    var textBoxHelper = new Text_Boxes(); // Instance of the Text_Boxes class

                    // Check for the existence of text boxes in the Settings tab
                    var settingTextBox1 = textBoxHelper.FindTextBoxByName(mainWindow, "DeveloperModeText");

                    // Assert that each text box exists
                    Assert.NotNull(settingTextBox1);

                    // Observe the behavior of the text boxes
                    textBoxHelper.ObserveTextBoxBehavior(settingTextBox1);
                }
            }
            finally
            {
                // Note: Don't close the app here; it will be closed by Main_TestSuite
            }
        }

        public void CheckTextBlocksExistenceAndBehaviorInSettingsTab()
        {
            try
            {
                using (var automation = new UIA3Automation())
                {
                    Thread.Sleep(3000); // Ensure the UI is loaded properly
                    var mainWindow = app.GetMainWindow(automation);

                    var textBlockHelper = new TextBlocks(); // Instance of the TextBlocks class

                    // Check for the existence of text blocks in the Settings tab
                    var userModeTextBlock = textBlockHelper.FindTextBlockByName(mainWindow, "UserModeText");
                    var developerModeTextBlock = textBlockHelper.FindTextBlockByName(mainWindow, "DeveloperModeText");

                    // Assert that each text block exists
                    Assert.NotNull(userModeTextBlock);
                    Assert.NotNull(developerModeTextBlock);

                    // Observe the behavior of the text blocks (visibility, content, etc.)
                    textBlockHelper.ObserveTextBlockBehavior(userModeTextBlock);
                    textBlockHelper.ObserveTextBlockBehavior(developerModeTextBlock);

                    // Additional checks for visibility and text of status TextBlocks
                    var userModeStatus = textBlockHelper.FindTextBlockByName(mainWindow, "UserModeStatus");
                    var developerModeStatus = textBlockHelper.FindTextBlockByName(mainWindow, "DeveloperModeStatus");

                    Assert.NotNull(userModeStatus);
                    Assert.NotNull(developerModeStatus);
                }
            }
            finally
            {
                // Note: Don't close the app here; it will be closed by Main_TestSuite
            }
        }
    }
}
