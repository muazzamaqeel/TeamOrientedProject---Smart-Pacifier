import '../../generated/sensor_data.pb.dart' as protos;
import 'sensor_packet.dart';

class SensorDeserializer {

  static SensorPacket parse(
      String topic,
      List<int> payload,
      ) {

    final parts = topic.split('/');

    final pacifierId = parts.length > 1 ? parts[1] : "0";
    final sensorType = parts.length > 2 ? parts[2] : "unknown";

    final group = parts.length > 0 ? parts[0] : "backend";

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

        values["temp_l"] = msg.tempL;
        values["temp_r"] = msg.tempR;
        values["temp_e"] = msg.tempE;

        break;

      case "pt":
        final msg = protos.PTData.fromBuffer(payload);

        values["temperature"] = msg.temperature;
        values["pressure"] = msg.pressure;

        break;

      default:
        break;
    }

    return SensorPacket(
      pacifierId: pacifierId,
      sensorType: sensorType,
      sensorGroup: group,
      values: values,
    );
  }
}