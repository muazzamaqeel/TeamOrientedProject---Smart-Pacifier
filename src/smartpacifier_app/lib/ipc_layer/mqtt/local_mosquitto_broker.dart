import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:nsd/nsd.dart';

class LocalMosquittoBroker {
  Process? _process;
  Registration? _registration;

  bool get isRunning => _process != null;

  Future<void> start() async {
    if (!Platform.isWindows) {
      debugPrint('Local Mosquitto auto-start is only enabled on Windows.');
      return;
    }

    if (_process != null) return;

    final brokerDir = _findMosquittoDirectory();

    final exePath = '${brokerDir.path}\\mosquitto.exe';
    final configPath = '${brokerDir.path}\\mosquitto.conf';

    if (!File(exePath).existsSync()) {
      throw FileSystemException('mosquitto.exe not found', exePath);
    }

    if (!File(configPath).existsSync()) {
      throw FileSystemException('mosquitto.conf not found', configPath);
    }

    _process = await Process.start(
      exePath,
      ['-c', configPath],
      workingDirectory: brokerDir.path,
      runInShell: false,
    );

    _process!.stdout.transform(systemEncoding.decoder).listen((line) {
      debugPrint('[mosquitto] $line');
    });

    _process!.stderr.transform(systemEncoding.decoder).listen((line) {
      debugPrint('[mosquitto] $line');
    });

    _process!.exitCode.then((code) {
      debugPrint('Mosquitto exited with code $code');
      _process = null;
    });

    await _advertiseBroker();
  }

  /// Advertises the broker as "broker._mqtt._tcp" on the LAN so the ESP32
  /// can find it via mDNS (broker.local) regardless of the PC's current IP.
  Future<void> _advertiseBroker() async {
    if (_registration != null) return;
    try {
      _registration = await register(
        const Service(
          name: 'broker',
          type: '_mqtt._tcp',
          port: 1883,
        ),
      );
      debugPrint('[mosquitto] mDNS advertised: broker._mqtt._tcp:1883');
    } catch (e) {
      debugPrint('[mosquitto] mDNS advertise failed: $e');
    }
  }

  Future<void> stop() async {
    if (_registration != null) {
      await unregister(_registration!);
      _registration = null;
    }
    _process?.kill();
    _process = null;
  }

  Directory _findMosquittoDirectory() {
    final exeDir = File(Platform.resolvedExecutable).parent.path;

    final candidates = <Directory>[
      Directory('${Directory.current.path}\\assets\\mosquitto'),
      Directory('$exeDir\\mosquitto'),
      Directory('$exeDir\\data\\flutter_assets\\assets\\mosquitto'),
    ];

    for (final dir in candidates) {
      if (File('${dir.path}\\mosquitto.exe').existsSync()) {
        return dir;
      }
    }

    throw FileSystemException(
      'Could not find bundled Mosquitto folder. Checked:',
      candidates.map((d) => d.path).join('\n'),
    );
  }
}

final localMosquittoBroker = LocalMosquittoBroker();