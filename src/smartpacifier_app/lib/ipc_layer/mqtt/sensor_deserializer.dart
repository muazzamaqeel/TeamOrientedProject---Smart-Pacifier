import 'package:flutter/foundation.dart';

import '../../generated/sensor_data.pb.dart' as protos;
import 'sensor_packet.dart';

class SensorDeserializer {
  static int _ppgPacketCount = 0;

  static int? _validTimestampMs(int value) {
    return value > 0 ? value : null;
  }

  static SensorPacket? parse(String topic, List<int> payload) {
    final parts = topic.split('/').where((part) => part.isNotEmpty).toList();

    /*
     * Expected topics:
     *
     * Pacifier/0_1/imu
     * Pacifier/0_1/airflow
     * Pacifier/0_1/pat
     * Pacifier/0_1/ppg/1
     * Pacifier/0_1/ppg/2
     * Pacifier/0_1/ppg/3
     * Pacifier/0_1/ppg/4
     */
    if (parts.length < 3) {
      return null;
    }

    final group = parts[0];
    final rawPacifier = parts[1];
    final sensorType = parts[2].toLowerCase();

    const allowedSensorTypes = {'imu', 'airflow', 'pat', 'ppg'};

    if (!allowedSensorTypes.contains(sensorType)) {
      return null;
    }

    /*
     * "0_1" means frontend pacifier 1.
     * The PPG sensor ID is the component after "ppg".
     */
    final pacifierId =
        rawPacifier.contains('_') ? rawPacifier.split('_').last : rawPacifier;

    if (int.tryParse(pacifierId) == null) {
      return null;
    }

    final topicPpgSensorId =
        sensorType == 'ppg' && parts.length > 3 ? int.tryParse(parts[3]) : null;

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

          if (!msg.hasLed() || !msg.hasTemperature()) {
            debugPrint('Incomplete PPG message received on $topic');
            return null;
          }

          /*
           * Prefer sensor_id inside protobuf.
           * Fall back to the final topic component.
           */
          final ppgId =
              msg.sensorId > 0 ? msg.sensorId : (topicPpgSensorId ?? 1);

          values['ID${ppgId}_LED1'] = msg.led.led1;
          values['ID${ppgId}_LED2'] = msg.led.led2;
          values['ID${ppgId}_LED3'] = msg.led.led3;
          values['ID${ppgId}_TEMP'] = msg.temperature.temperature;

          /*
           * PPG runs near 100 Hz. Do not print every packet.
           */
          _ppgPacketCount++;

          if (_ppgPacketCount == 1 || _ppgPacketCount % 100 == 0) {
            debugPrint(
              'PPG received: topic=$topic '
              'sensorId=$ppgId '
              'LED=(${msg.led.led1},'
              '${msg.led.led2},'
              '${msg.led.led3}) '
              'temperature=${msg.temperature.temperature} '
              'total=$_ppgPacketCount',
            );
          }

          break;
      }
    } catch (error, stackTrace) {
      debugPrint('Failed to decode $sensorType on $topic: $error');
      debugPrintStack(stackTrace: stackTrace);
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
