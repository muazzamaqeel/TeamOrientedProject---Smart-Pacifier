// File: lib/ipc_layer/mqtt/sensor_packet.dart

class SensorPacket {
  final String pacifierId;
  final String sensorType;
  final String sensorGroup;
  final Map<String, num> values;

  /// Time when packet was received by Flutter app
  final DateTime timestamp;

  /// ESP timestamp from protobuf timestamp_ms.
  /// If ESP sends 0 or null, we ignore it and use app-relative time instead.
  final int? espTimestampMs;

  /// Raw MQTT payload
  List<int>? rawPayload;

  /// Original MQTT topic
  String? topic;

  static final DateTime _graphStartTime = DateTime.now();

  SensorPacket({
    required this.pacifierId,
    required this.sensorType,
    required this.sensorGroup,
    required this.values,
    required this.timestamp,
    this.espTimestampMs,
  });

  bool get hasValidEspTimestamp {
    return espTimestampMs != null && espTimestampMs! > 0;
  }

  /// Timestamp used for graph x-axis and HDF5.
  ///
  /// Important:
  /// ESP currently sends timestamp_ms as 0, so using it directly breaks
  /// the graph and puts all points at x = 0.
  ///
  /// Therefore:
  /// - use ESP timestamp only if it is > 0
  /// - otherwise use app-relative receive time
  double get graphTimeSeconds {
    if (hasValidEspTimestamp) {
      return espTimestampMs! / 1000.0;
    }

    return timestamp.difference(_graphStartTime).inMilliseconds / 1000.0;
  }

  /// Pretty timestamp label.
  /// Uses ESP time if valid, otherwise app-relative time.
  String get espTimeLabel {
    final Duration d;

    if (hasValidEspTimestamp) {
      d = Duration(milliseconds: espTimestampMs!);
    } else {
      d = timestamp.difference(_graphStartTime);
    }

    final hours = d.inHours.toString().padLeft(2, '0');
    final minutes = (d.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (d.inSeconds % 60).toString().padLeft(2, '0');
    final millis = (d.inMilliseconds % 1000).toString().padLeft(3, '0');

    return '$hours:$minutes:$seconds.$millis';
  }
}