using System;
using System.Diagnostics;
using FlaUI.Core;
using FlaUI.UIA3;
using Xunit;
using SmartPacifier___TestingFramework.Tests_FrontEnd.Tests_Tabs.Tests_SettingTab;

namespace SmartPacifier___TestingFramework
{
    public class Main_UITests
    {
        private Application? app;

        /// <summary>
        /// This function is used to launch the application for all UI Tests.
        /// </summary>
        /// <returns></returns>
        private Application LaunchApplication()
        {
            string applicationPath = @"C:\programming\TeamOrientedProject---Smart-Pacifier\Source Code\Front-End\UI (WPF)\Smart Pacifier - Tool\Smart Pacifier - Tool\bin\Debug\net8.0-windows\SmartPacifier.UI (WPF).exe";
            var processStartInfo = new ProcessStartInfo(applicationPath)
            {
                WorkingDirectory = @"C:\programming\TeamOrientedProject---Smart-Pacifier\Source Code\Front-End\UI (WPF)\Smart Pacifier - Tool\Smart Pacifier - Tool\bin\Debug\net8.0-windows\"
            };

            app = Application.Launch(processStartInfo);
            return app;
        }

        /// <summary>
        /// Manually run the CheckButtonsExistenceInSettingsTab test from the UITests_Settings class.
        /// </summary>
        [Fact]
        public void RunSettingsTabTests()
        {
            // Launch the application once here
            app = LaunchApplication();

            try
            {
                // Pass the launched application to UITests_Settings
                var settingsTests = new UITests_Settings(app);

                // Run the settings tab tests
                //settingsTests.CheckButtonsExistenceInSettingsTab();
                settingsTests.CheckTextBoxesExistenceInSettingsTab();

            }
            finally
            {
                // Close the application after running tests
                app.Close();
            }
        }
    }
}
