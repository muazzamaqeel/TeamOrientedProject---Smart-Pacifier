﻿using System.Windows;
using System.Windows.Controls;

namespace Smart_Pacifier___Tool
{
    public partial class MainWindow : Window
    {
        public MainWindow()
        {
            InitializeComponent();
        }

        public void NavigateTo(UserControl newView)
        {
            MainContent.Content = newView;
        }
    }
}