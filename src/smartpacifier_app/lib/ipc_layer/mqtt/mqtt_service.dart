import 'dart:async';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

import 'sensor_packet.dart';
import 'sensor_deserializer.dart';

class MQTTService {

  late MqttServerClient client;

  final StreamController<SensorPacket> _controller =
      StreamController.broadcast();

  Stream<SensorPacket> get stream => _controller.stream;

  Future<void> connect() async {

    client = MqttServerClient('192.168.0.101', 'flutter_client');

    client.port = 1883;
    client.keepAlivePeriod = 20;
    client.logging(on: false);

    final connMess = MqttConnectMessage()
        .withClientIdentifier('flutter_client')
        .startClean();

    client.connectionMessage = connMess;

    await client.connect();

    if (client.connectionStatus!.state !=
        MqttConnectionState.connected) {

      throw Exception("MQTT connection failed");
    }

    print("MQTT connected");

    client.subscribe("Pacifier/#", MqttQos.atLeastOnce);

    client.updates!.listen((events) {

      final rec = events.first.payload as MqttPublishMessage;

      final payload = rec.payload.message;

      final topic = events.first.topic;

      try {

        final packet =
            SensorDeserializer.parse(topic, payload);

        _controller.add(packet);

      } catch (e) {

        print("Decode error: $e");
      }
    });
  }
}

final mqttService = MQTTService();