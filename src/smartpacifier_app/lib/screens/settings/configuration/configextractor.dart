// File: lib/screens/settings/configuration/configextractor.dart

import 'package:flutter/services.dart' show rootBundle;
import 'package:yaml/yaml.dart';

/// Loads and exposes values from config.yml
class ConfigExtractor {
  /// The frontend always talks to the broker running on this same machine,
  /// so the host is fixed to localhost and never depends on the changing
  /// ethernet IP. Only the ESP32 reaches the broker over the network
  /// (via broker.local / mDNS).
  static const String host = '127.0.0.1';

  static late final int port;

  /// Call once before runApp (or before you need the values).
  static Future<void> init() async {
    final yamlString = await rootBundle.loadString(
      'lib/screens/settings/configuration/config.yml',
    );
    final doc = loadYaml(yamlString) as YamlMap;
    port = doc['port'] as int;
  }
}