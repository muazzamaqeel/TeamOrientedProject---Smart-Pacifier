import 'dart:async';
import 'dart:io';

class LocalBrokerManager {
  Process? _process;

  Future<void> start() async {
    if (!Platform.isWindows && !Platform.isLinux && !Platform.isMacOS) {
      throw UnsupportedError('Local broker is only supported on desktop.');
    }

    final exePath = _brokerExecutablePath();
    final configPath = _brokerConfigPath();

    if (!File(exePath).existsSync()) {
      throw Exception('Mosquitto executable not found: $exePath');
    }

    if (!File(configPath).existsSync()) {
      throw Exception('Mosquitto config not found: $configPath');
    }

    if (await _isBrokerRunning()) {
      return;
    }

    _process = await Process.start(
      exePath,
      ['-c', configPath, '-v'],
      runInShell: false,
    );

    _process!.stdout.transform(SystemEncoding().decoder).listen((line) {
      print('[BROKER] $line');
    });

    _process!.stderr.transform(SystemEncoding().decoder).listen((line) {
      print('[BROKER ERROR] $line');
    });

    await _waitUntilReady();
  }

  Future<bool> _isBrokerRunning() async {
    try {
      final socket = await Socket.connect(
        '127.0.0.1',
        1883,
        timeout: const Duration(milliseconds: 500),
      );
      socket.destroy();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> _waitUntilReady() async {
    for (int i = 0; i < 20; i++) {
      if (await _isBrokerRunning()) return;
      await Future.delayed(const Duration(milliseconds: 300));
    }

    throw Exception('Local MQTT broker did not start.');
  }

  String _brokerExecutablePath() {
    final base = Directory.current.path;

    if (Platform.isWindows) {
      return '$base/broker/windows/mosquitto.exe';
    }

    if (Platform.isLinux) {
      return '$base/broker/linux/mosquitto';
    }

    if (Platform.isMacOS) {
      return '$base/broker/macos/mosquitto';
    }

    throw UnsupportedError('Unsupported platform');
  }

  String _brokerConfigPath() {
    return '${Directory.current.path}/broker/mosquitto.conf';
  }

  void stop() {
    _process?.kill();
    _process = null;
  }
}

final localBrokerManager = LocalBrokerManager();