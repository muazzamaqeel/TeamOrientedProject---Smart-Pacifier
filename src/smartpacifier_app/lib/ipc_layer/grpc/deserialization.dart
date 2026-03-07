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

      /// IMU SENSOR
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

      /// AIRFLOW SENSOR
      case "airflow":
        final msg = protos.AIRFLOWData.fromBuffer(payload);

        values["voltage_l"] = msg.voltage10kL;
        values["voltage_r"] = msg.voltage10kR;
        values["voltage_e"] = msg.voltage10kE;

        values["temp_l"] = msg.tempL;
        values["temp_r"] = msg.tempR;
        values["temp_e"] = msg.tempE;

        values["raw_l"] = msg.rawL;
        values["raw_r"] = msg.rawR;
        values["raw_e"] = msg.rawE;

        break;

      /// PRESSURE + TEMPERATURE SENSOR (MS8607)
      case "pat":   // <---- THIS WAS MISSING
        final msg = protos.PTData.fromBuffer(payload);

        values["temperature"] = msg.temperature;
        values["pressure"] = msg.pressure;

        break;

      /// OPTIONAL PPG SENSOR
      case "ppg":
        final msg = protos.PPGData.fromBuffer(payload);

        values["led_1"] = msg.ledData.led1;
        values["led_2"] = msg.ledData.led2;
        values["led_3"] = msg.ledData.led3;

        if (msg.hasTemperatureData()) {
          values["temperature"] = msg.temperatureData.temperature;
        }

        break;

      default:
        // Unknown sensor type
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