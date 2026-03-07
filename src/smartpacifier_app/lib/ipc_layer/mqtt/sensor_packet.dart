class SensorPacket {
  final String pacifierId;
  final String sensorType;
  final String sensorGroup;
  final Map<String, num> values;

  SensorPacket({
    required this.pacifierId,
    required this.sensorType,
    required this.sensorGroup,
    required this.values,
  });
}