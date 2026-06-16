import 'dart:io';

import 'package:flutter/foundation.dart';

class LocalMosquittoBroker {
  Process? _process;

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
  }

  Future<void> stop() async {
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
