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

    switch (sensorType) {

      case "imu":

        final msg = protos.IMUData.fromBuffer(payload);

        values["temperature"] = msg.temperature;

        values["acc_x"] = msg.acc.x;
        values["acc_y"] = msg.acc.y;
        values["acc_z"] = msg.acc.z;

        values["gyro_x"] = msg.gyro.x;
        values["gyro_y"] = msg.gyro.y;
        values["gyro_z"] = msg.gyro.z;

        break;

      case "airflow":

        final msg = protos.AIRFLOWData.fromBuffer(payload);

        values["voltage_l"] = msg.voltage10kL;
        values["voltage_r"] = msg.voltage10kR;
        values["voltage_e"] = msg.voltage10kE;

        values["raw_l"] = msg.rawL;
        values["raw_r"] = msg.rawR;
        values["raw_e"] = msg.rawE;

        values["temp_l"] = msg.tempL;
        values["temp_r"] = msg.tempR;
        values["temp_e"] = msg.tempE;

        break;

      case "pat":

        final msg = protos.PTData.fromBuffer(payload);

        values["temperature"] = msg.temperature;
        values["pressure"] = msg.pressure;

        break;

      /// ✅ FIX: ADD PPG SUPPORT
      case "ppg":

        final msg = protos.PPGData.fromBuffer(payload);

        // 🔥 extract sensor_id from topic if present
        final sensorId = parts.length > 3
            ? parts[3]
            : msg.sensorId.toString();

        values["ID_${sensorId}_led_1"] = msg.led1;
        values["ID_${sensorId}_led_2"] = msg.led2;
        values["ID_${sensorId}_led_3"] = msg.led3;

        values["ID_${sensorId}_temperature"] = msg.temperature;

        break;
    }

    return SensorPacket(
      pacifierId: pacifierId,
      sensorType: sensorType,
      sensorGroup: group,
      values: values,
      timestamp: DateTime.now(),   // keep this
    );
  }
}