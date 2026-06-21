// File: lib/ipc_layer/mqtt/sensor_deserializer.dart

import '../../generated/sensor_data.pb.dart' as protos;
import 'sensor_packet.dart';

class SensorDeserializer {
  static int? _validTimestampMs(int value) {
    return value > 0 ? value : null;
  }
  static SensorPacket? parse(
    String topic,
    List<int> payload,
  ) {
    final parts = topic.split('/');

    // Expected topics:
    // Pacifier/0_1/imu
    // Pacifier/0_1/airflow
    // Pacifier/0_1/pat
    // Pacifier/0_1/ppg
    if (parts.length < 3) {
      return null;
    }

    final group = parts[0];
    final rawPacifier = parts[1];
    final sensorType = parts[2];

    const allowedSensorTypes = {
      'imu',
      'airflow',
      'pat',
      'ppg',
    };

    if (!allowedSensorTypes.contains(sensorType)) {
      return null;
    }

    final topicParts = rawPacifier.split('_');

    /*
    * Topic examples:
    *
    * Pacifier/0_1/imu
    * Pacifier/0_1/pat
    * Pacifier/0_1/airflow
    *
    * For PPG:
    * Pacifier/0_1/ppg
    * Pacifier/0_2/ppg
    * Pacifier/0_3/ppg
    * Pacifier/0_4/ppg
    *
    * The second number is the PPG sensor ID, not a separate pacifier.
    * Therefore all PPG sensors must stay under the same frontend pacifier.
    */
    final pacifierId = sensorType == 'ppg'
        ? '1'
        : rawPacifier.contains('_')
            ? rawPacifier.split('_').last
            : rawPacifier;

    final ppgSensorId = rawPacifier.contains('_')
        ? rawPacifier.split('_').last
        : rawPacifier;

    if (int.tryParse(pacifierId) == null) {
      return null;
    }

    final values = <String, num>{};
    int? espTimestampMs;

    try {
      switch (sensorType) {
        case 'imu':
          final msg = protos.IMUData.fromBuffer(payload);

          espTimestampMs = _validTimestampMs(msg.timestampMs.toInt());

          values['temperature'] = msg.temperature;

          values['acc_x'] = msg.acc.x;
          values['acc_y'] = msg.acc.y;
          values['acc_z'] = msg.acc.z;

          values['gyro_x'] = msg.gyro.x;
          values['gyro_y'] = msg.gyro.y;
          values['gyro_z'] = msg.gyro.z;

          break;

        case 'airflow':
          final msg = protos.AIRFLOWData.fromBuffer(payload);

          espTimestampMs = _validTimestampMs(msg.timestampMs.toInt());
          values['temp_l'] = msg.tempL;
          values['temp_r'] = msg.tempR;
          values['temp_e'] = msg.tempE;

          break;

        case 'pat':
          final msg = protos.PTData.fromBuffer(payload);

          espTimestampMs = _validTimestampMs(msg.timestampMs.toInt());

          values['temperature_c'] = msg.temperature;
          values['pressure_hpa'] = msg.pressure;

          break;

        case 'ppg':
        final msg = protos.PPGData.fromBuffer(payload);

        espTimestampMs = _validTimestampMs(msg.timestampMs.toInt());

        /*
        * All four MAX30101 sensors belong to the same frontend pacifier.
        *
        * MQTT topics:
        * Pacifier/0_1/ppg -> PPG sensor ID 1
        * Pacifier/0_2/ppg -> PPG sensor ID 2
        * Pacifier/0_3/ppg -> PPG sensor ID 3
        * Pacifier/0_4/ppg -> PPG sensor ID 4
        */
        final ppgId = ppgSensorId;

        values['ID${ppgId}_LED1'] = msg.led.led1;
        values['ID${ppgId}_LED2'] = msg.led.led2;
        values['ID${ppgId}_LED3'] = msg.led.led3;
        values['ID${ppgId}_TEMP'] = msg.temperature.temperature;

        print(
          'PPG topic=$topic '
          'frontendPacifierId=$pacifierId '
          'ppgSensorId=$ppgSensorId '
          'ID${ppgId}_LED1=${msg.led.led1} '
          'ID${ppgId}_LED2=${msg.led.led2} '
          'ID${ppgId}_LED3=${msg.led.led3} '
          'ID${ppgId}_TEMP=${msg.temperature.temperature}',
        );

        break;
      }
    } catch (_) {
      return null;
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