import 'dart:async';

import '../ipc_layer/mqtt/mqtt_service.dart';
import '../ipc_layer/mqtt/sensor_packet.dart';

class Connector {

  Connector._internal() {
    _initDetection();
  }

  static final Connector _instance = Connector._internal();

  factory Connector() => _instance;

  final Set<String> _clients = {};

  final _ctrl = StreamController<List<String>>.broadcast();

  Stream<List<String>> get clientsStream => _ctrl.stream;

  List<String> get clients => List.unmodifiable(_clients);

  void _initDetection() {

    mqttService.stream.listen((packet) {

      final backend = packet.sensorGroup;

      if (backend.isNotEmpty) {
        addClient(backend);
      }
    });
  }

  void addClient(String name) {

    if (_clients.add(name)) {

      _ctrl.add(_clients.toList());
    }
  }

  Stream<SensorPacket> dataStreamFor(String clientId) {

    return mqttService.stream.where((sd) {

      return sd.sensorGroup == clientId;
    });
  }
}