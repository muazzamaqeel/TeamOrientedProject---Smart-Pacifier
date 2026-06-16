import 'package:flutter/material.dart';

import 'ipc_layer/mqtt/mqtt_service.dart';
import 'ipc_layer/mqtt/local_mosquitto_broker.dart';
import 'components/theme/lighttheme.dart';
import 'components/theme/darktheme.dart';
import 'components/sidebar/app_shell.dart';
import 'screens/settings/configuration/configextractor.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await ConfigExtractor.init();

  runApp(const MyApp());

  try {
    await localMosquittoBroker.start();
  } catch (e) {
    debugPrint('Failed to start local Mosquitto: $e');
  }

  await mqttService.connect();
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDark = true;

  void _toggleTheme(bool isDark) {
    setState(() => _isDark = isDark);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartPacifier App',
      theme: _isDark ? darkTheme : lightTheme,
      home: AppShell(
        isDark: _isDark,
        onThemeChanged: _toggleTheme,
      ),
    );
  }
}
