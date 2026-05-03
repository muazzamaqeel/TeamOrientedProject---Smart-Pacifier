// File: lib/ipc_layer/mqtt/sensor_deserializer.dart

import '../../generated/sensor_data.pb.dart' as protos;
import 'sensor_packet.dart';

class SensorDeserializer {
  static SensorPacket parse(
    String topic,
    List<int> payload,
  ) {
    final parts = topic.split('/');

    final rawPacifier = parts.length > 1 ? parts[1] : "0";

    final pacifierId = rawPacifier.contains('_')
        ? rawPacifier.split('_').last
        : rawPacifier;

    final sensorType = parts.length > 2 ? parts[2] : "unknown";

    final group = parts.isNotEmpty ? parts[0] : "backend";

    final values = <String, num>{};

    int? espTimestampMs;

    switch (sensorType) {
      case "imu":
        final msg = protos.IMUData.fromBuffer(payload);

        espTimestampMs = msg.timestampMs.toInt();

        values["temperature_c"] = msg.temperature;

        values["acc_x_g"] = msg.acc.x;
        values["acc_y_g"] = msg.acc.y;
        values["acc_z_g"] = msg.acc.z;

        values["gyro_x_dps"] = msg.gyro.x;
        values["gyro_y_dps"] = msg.gyro.y;
        values["gyro_z_dps"] = msg.gyro.z;

        break;

      case "airflow":
        final msg = protos.AIRFLOWData.fromBuffer(payload);

        espTimestampMs = msg.timestampMs.toInt();

        values["in0_c"] = msg.tempL;
        values["in1_c"] = msg.tempR;
        values["in2_c"] = msg.tempE;

        break;

      case "pat":
        final msg = protos.PTData.fromBuffer(payload);

        espTimestampMs = msg.timestampMs.toInt();

        values["temperature_c"] = msg.temperature;
        values["pressure_hpa"] = msg.pressure;

        break;

      case "ppg":
        final msg = protos.PPGData.fromBuffer(payload);

        espTimestampMs = msg.timestampMs.toInt();

        values["ID_${msg.sensorId}_led_1"] = msg.led1;
        values["ID_${msg.sensorId}_led_2"] = msg.led2;
        values["ID_${msg.sensorId}_led_3"] = msg.led3;
        values["ID_${msg.sensorId}_temperature_c"] = msg.temperature;

        break;

      default:
        break;
    }

    return SensorPacket(
      pacifierId: pacifierId,
      sensorType: sensorType,
      sensorGroup: group,
      values: values,
      timestamp: DateTime.now(),
      espTimestampMs: espTimestampMs,
    );
  }
}