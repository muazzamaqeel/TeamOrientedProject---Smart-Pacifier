// File: lib/ipc_layer/mqtt/sensor_packet.dart

class SensorPacket {
  final String pacifierId;
  final String sensorType;
  final String sensorGroup;
  final Map<String, num> values;

  /// Time when packet was received by Flutter app
  final DateTime timestamp;

  /// ESP timestamp from protobuf timestamp_ms
  final int? espTimestampMs;

  /// Raw MQTT payload
  List<int>? rawPayload;

  /// Original MQTT topic
  String? topic;

  SensorPacket({
    required this.pacifierId,
    required this.sensorType,
    required this.sensorGroup,
    required this.values,
    required this.timestamp,
    this.espTimestampMs,
  });

  /// Timestamp used for graph x-axis and HDF5.
  /// Prefer ESP time. Fallback to Flutter receive time.
  double get graphTimeSeconds {
    if (espTimestampMs != null) {
      return espTimestampMs! / 1000.0;
    }
    return timestamp.millisecondsSinceEpoch / 1000.0;
  }

  /// Pretty ESP timestamp like 00:07:53.271
  String get espTimeLabel {
    if (espTimestampMs == null) {
      return timestamp.toIso8601String();
    }

    final d = Duration(milliseconds: espTimestampMs!);

    final hours = d.inHours.toString().padLeft(2, '0');
    final minutes = (d.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (d.inSeconds % 60).toString().padLeft(2, '0');
    final millis = (d.inMilliseconds % 1000).toString().padLeft(3, '0');

    return '$hours:$minutes:$seconds.$millis';
  }
}