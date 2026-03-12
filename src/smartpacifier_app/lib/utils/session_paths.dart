import 'dart:io';
import 'package:path/path.dart' as p;

class SessionPaths {

  static final base = Directory(
    'lib/screens/campaign_monitoring/sessions',
  );

  static Directory get dataDir =>
      Directory(p.join(base.path, 'data'));

  static Directory get metadataDir =>
      Directory(p.join(base.path, 'metadata'));

  static Future<void> ensure() async {
    if (!await dataDir.exists()) {
      await dataDir.create(recursive: true);
    }

    if (!await metadataDir.exists()) {
      await metadataDir.create(recursive: true);
    }
  }
}