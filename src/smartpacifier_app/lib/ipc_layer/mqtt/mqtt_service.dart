import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

import '../../screens/settings/configuration/configextractor.dart';
import 'sensor_packet.dart';
import 'sensor_deserializer.dart';

enum MqttConnectionStatus {
  disconnected,
  connecting,
  connected,
  error,
}

class MQTTService {
  late MqttServerClient client;

  final StreamController<SensorPacket> _controller =
      StreamController<SensorPacket>.broadcast();

  final ValueNotifier<MqttConnectionStatus> connectionStatus =
      ValueNotifier<MqttConnectionStatus>(MqttConnectionStatus.disconnected);

  final ValueNotifier<String> statusMessage =
      ValueNotifier<String>('Disconnected');

  Stream<SensorPacket> get stream => _controller.stream;

  bool _isConnecting = false;
  bool _initialized = false;

  Future<void> connect() async {
    if (_isConnecting) return;
    _isConnecting = true;

    try {
      connectionStatus.value = MqttConnectionStatus.connecting;
      statusMessage.value =
          'Connecting to ${ConfigExtractor.host}:${ConfigExtractor.port}...';

      client = MqttServerClient(ConfigExtractor.host, 'flutter_client');
      client.port = ConfigExtractor.port;
      client.keepAlivePeriod = 20;
      client.logging(on: false);
      client.autoReconnect = true;
      client.resubscribeOnAutoReconnect = true;

      client.onConnected = _onConnected;
      client.onDisconnected = _onDisconnected;
      client.onSubscribed = (topic) {
        statusMessage.value = 'Subscribed to $topic';
      };
      client.onAutoReconnect = () {
        connectionStatus.value = MqttConnectionStatus.connecting;
        statusMessage.value = 'Reconnecting...';
      };
      client.onAutoReconnected = () {
        connectionStatus.value = MqttConnectionStatus.connected;
        statusMessage.value = 'Reconnected';
      };

      final connMess = MqttConnectMessage()
          .withClientIdentifier('flutter_client')
          .startClean();

      client.connectionMessage = connMess;

      await client.connect();

      if (client.connectionStatus?.state != MqttConnectionState.connected) {
        connectionStatus.value = MqttConnectionStatus.error;
        statusMessage.value =
            'MQTT connection failed: ${client.connectionStatus?.state}';
        return;
      }

      if (!_initialized) {
        _listenToMessages();
        _initialized = true;
      }

      client.subscribe('Pacifier/#', MqttQos.atLeastOnce);
    } catch (e) {
      connectionStatus.value = MqttConnectionStatus.error;
      statusMessage.value = 'MQTT connection error: $e';

      try {
        client.disconnect();
      } catch (_) {}
    } finally {
      _isConnecting = false;
    }
  }

  void _onConnected() {
    connectionStatus.value = MqttConnectionStatus.connected;
    statusMessage.value =
        'Connected to ${ConfigExtractor.host}:${ConfigExtractor.port}';
  }

  void _onDisconnected() {
    connectionStatus.value = MqttConnectionStatus.disconnected;
    statusMessage.value = 'Disconnected from broker';
  }

  void _listenToMessages() {
    client.updates?.listen((events) {
      if (events.isEmpty) return;

      final rec = events.first.payload as MqttPublishMessage;
      final payload = rec.payload.message;
      final topic = events.first.topic;

      try {
        final packet = SensorDeserializer.parse(topic, payload);
        _controller.add(packet);
      } catch (e) {
        debugPrint('Decode error: $e');
      }
    });
  }

  void disconnect() {
    try {
      client.disconnect();
    } catch (_) {}
  }

  void dispose() {
    _controller.close();
    connectionStatus.dispose();
    statusMessage.dispose();
  }
}

final mqttService = MQTTService();