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
  MqttServerClient? client;

  StreamSubscription? _mqttSub;

  final StreamController<SensorPacket> _controller =
      StreamController<SensorPacket>.broadcast();

  final ValueNotifier<MqttConnectionStatus> connectionStatus =
      ValueNotifier<MqttConnectionStatus>(MqttConnectionStatus.disconnected);

  final ValueNotifier<String> statusMessage =
      ValueNotifier<String>('Disconnected');

  Stream<SensorPacket> get stream => _controller.stream;

  bool _isConnecting = false;

  Future<void> connect() async {
    if (_isConnecting) return;
    _isConnecting = true;

    try {
      connectionStatus.value = MqttConnectionStatus.connecting;
      statusMessage.value =
          'Connecting to ${ConfigExtractor.host}:${ConfigExtractor.port}...';

      await _cleanupOldClient();

      final newClient = MqttServerClient(
        ConfigExtractor.host,
        'flutter_client_${DateTime.now().millisecondsSinceEpoch}',
      );

      newClient.port = ConfigExtractor.port;
      newClient.keepAlivePeriod = 20;
      newClient.logging(on: false);
      newClient.autoReconnect = true;
      newClient.resubscribeOnAutoReconnect = true;

      newClient.onConnected = _onConnected;
      newClient.onDisconnected = _onDisconnected;

      newClient.onSubscribed = (topic) {
        statusMessage.value = 'Subscribed to $topic';
      };

      newClient.onAutoReconnect = () {
        connectionStatus.value = MqttConnectionStatus.connecting;
        statusMessage.value = 'Reconnecting...';
      };

      newClient.onAutoReconnected = () {
        connectionStatus.value = MqttConnectionStatus.connected;
        statusMessage.value = 'Reconnected to Pacifier/#';

        try {
          newClient.subscribe('Pacifier/#', MqttQos.atLeastOnce);
        } catch (_) {}
      };

      final connMess = MqttConnectMessage()
          .withClientIdentifier(
            'flutter_client_${DateTime.now().millisecondsSinceEpoch}',
          )
          .startClean();

      newClient.connectionMessage = connMess;

      client = newClient;

      await newClient.connect();

      if (newClient.connectionStatus?.state != MqttConnectionState.connected) {
        connectionStatus.value = MqttConnectionStatus.error;
        statusMessage.value =
            'MQTT connection failed: ${newClient.connectionStatus?.state}';
        return;
      }

      _listenToMessages(newClient);

      newClient.subscribe('Pacifier/#', MqttQos.atLeastOnce);
    } catch (e) {
      connectionStatus.value = MqttConnectionStatus.error;
      statusMessage.value = 'MQTT connection error: $e';

      try {
        client?.disconnect();
      } catch (_) {}
    } finally {
      _isConnecting = false;
    }
  }

  Future<void> reconnect() async {
    await connect();
  }

  Future<void> _cleanupOldClient() async {
    try {
      await _mqttSub?.cancel();
    } catch (_) {}

    _mqttSub = null;

    try {
      client?.disconnect();
    } catch (_) {}

    client = null;
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

  void _listenToMessages(MqttServerClient activeClient) {
    _mqttSub = activeClient.updates?.listen((events) {
      if (events.isEmpty) return;

      final rec = events.first.payload as MqttPublishMessage;
      final payload = rec.payload.message;
      final topic = events.first.topic;

      try {
        final packet = SensorDeserializer.parse(topic, payload);

        if (packet == null) {
          return;
        }

        packet.rawPayload = payload;
        packet.topic = topic;

        _controller.add(packet);
      } catch (e) {
        debugPrint('Decode error on topic $topic: $e');
      }
    });
  }

  void disconnect() {
    _cleanupOldClient();
  }

  void dispose() {
    _cleanupOldClient();
    _controller.close();
    connectionStatus.dispose();
    statusMessage.dispose();
  }
}

final mqttService = MQTTService();