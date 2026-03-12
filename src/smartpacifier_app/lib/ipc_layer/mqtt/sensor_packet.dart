class SensorPacket {
  final String pacifierId;
  final String sensorType;
  final String sensorGroup;
  final Map<String, num> values;

  /// timestamp when packet was received by the app
  final DateTime timestamp;

  SensorPacket({
    required this.pacifierId,
    required this.sensorType,
    required this.sensorGroup,
    required this.values,
    required this.timestamp,
  });
}