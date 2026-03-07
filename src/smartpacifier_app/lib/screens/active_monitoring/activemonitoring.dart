import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../ipc_layer/mqtt/sensor_packet.dart';
import '../../client_layer/connector.dart';
import 'graphcreation.dart';

class ActiveMonitoring extends StatefulWidget {
  final String backend;
  const ActiveMonitoring({super.key, required this.backend});

  @override
  State<ActiveMonitoring> createState() => _ActiveMonitoringState();
}

class _ActiveMonitoringState extends State<ActiveMonitoring>
    with TickerProviderStateMixin {

  StreamSubscription<SensorPacket>? _sub;

  final Map<String, Map<String, Map<String, List<FlSpot>>>> _buffers = {};
  final Set<String> _selectedPacifiers = {};
  final List<String> _logs = [];

  late final TabController _tabController;
  int _nextX = 0;

  int _packetCount = 0;
  final ValueNotifier<double> _hzNotifier = ValueNotifier(0);
  Timer? _hzTimer;

  int _frameCount = 0;
  final ValueNotifier<double> _fpsNotifier = ValueNotifier(0);
  Timer? _fpsTimer;

  late final Ticker _ticker;
  bool _needsRebuild = false;

  final List<Color> _palette = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.amber,
    Colors.indigo,
    Colors.cyan,
    Colors.lime,
  ];

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);

    _ticker = createTicker((_) {
      if (_needsRebuild && mounted) {
        _frameCount++;
        setState(() => _needsRebuild = false);
      }
    })..start();

    _hzTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _hzNotifier.value = _packetCount.toDouble();
      _packetCount = 0;
    });

    _fpsTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _fpsNotifier.value = _frameCount.toDouble();
      _frameCount = 0;
    });

    _subscribe();
  }

  void _subscribe() {
    _sub = Connector()
        .dataStreamFor(widget.backend)
        .listen(
      (SensorPacket packet) {

        _packetCount++;

        _handleSensorData(packet);

        _needsRebuild = true;

        final line =
            '[${DateTime.now().toIso8601String()}] '
            '[${packet.sensorGroup}] '
            'pacifier=${packet.pacifierId}, '
            'type=${packet.sensorType}, '
            'values=${packet.values}';

        _logs.add(line);

        if (_logs.length > 200) {
          _logs.removeAt(0);
        }
      },
      onError: (e) {
        _logs.add('[${DateTime.now().toIso8601String()}] Error: $e');
        if (_logs.length > 200) _logs.removeAt(0);
        _stopMonitoring('Backend error – monitoring stopped');
      },
      onDone: () {
        _stopMonitoring('Backend disconnected – monitoring stopped');
      },
    );
  }

  void _stopMonitoring(String message) {
    _sub?.cancel();
    _hzTimer?.cancel();
    _fpsTimer?.cancel();
    _ticker.stop();

    if (mounted) {
      setState(() {
        _needsRebuild = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  void _handleSensorData(SensorPacket packet) {

    final t = (_nextX++).toDouble();

    final typeMap = _buffers.putIfAbsent(
      packet.sensorType,
      () => <String, Map<String, List<FlSpot>>>{},
    );

    final groupName =
        '${packet.sensorGroup}_${packet.pacifierId}';

    final groupMap = typeMap.putIfAbsent(
      groupName,
      () => <String, List<FlSpot>>{},
    );

    packet.values.forEach((key, value) {

      final series =
          groupMap.putIfAbsent(key, () => <FlSpot>[]);

      series.add(FlSpot(t, value.toDouble()));

      if (series.length > 50) {
        series.removeAt(0);
      }
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    _ticker.dispose();
    _hzTimer?.cancel();
    _fpsTimer?.cancel();
    _hzNotifier.dispose();
    _fpsNotifier.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final pacifierIds = <String>{};

    _buffers.values.forEach((groups) {
      groups.keys.forEach((g) {
        pacifierIds.add(g.split('_').last);
      });
    });

    pacifierIds.removeWhere((id) => id.isEmpty);

    final pacifierList = pacifierIds.toList()
      ..sort((a, b) =>
          int.tryParse(a)!.compareTo(int.tryParse(b)!));

    return Scaffold(
      appBar: AppBar(
        title: Text('Active Monitoring — ${widget.backend}'),
        actions: [

          ValueListenableBuilder<double>(
            valueListenable: _fpsNotifier,
            builder: (_, fps, __) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Center(
                child: Text(
                  'FPS: ${fps.toStringAsFixed(0)}',
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Graphs'),
            Tab(text: 'Logs')
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [

          RepaintBoundary(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [

                if (pacifierList.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: pacifierList.map((id) {

                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: FilterChip(
                              label: Text('Pacifier $id'),
                              selected: _selectedPacifiers.contains(id),
                              onSelected: (sel) {

                                setState(() {
                                  sel
                                      ? _selectedPacifiers.add(id)
                                      : _selectedPacifiers.remove(id);
                                });
                              },
                            ),
                          );

                        }).toList(),
                      ),
                    ),
                  ),

                Expanded(
                  child: _selectedPacifiers.isEmpty
                      ? const Center(
                          child: Text(
                              'Select a chip to show graphs'))
                      : ListView(
                          children: [

                            for (final id in _selectedPacifiers) ...[

                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8),
                                child: Text(
                                  'Pacifier $id',
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight:
                                          FontWeight.bold),
                                ),
                              ),

                              Builder(builder: (_) {

                                final filtered = <
                                    String,
                                    Map<String,
                                        Map<String,
                                            List<FlSpot>>>>{};

                                _buffers.forEach((stype, groups) {

                                  final sub = <
                                      String,
                                      Map<String,
                                          List<FlSpot>>>{};

                                  groups.forEach((gname, series) {

                                    if (gname.endsWith('_$id')) {
                                      sub[gname] = series;
                                    }

                                  });

                                  if (sub.isNotEmpty) {
                                    filtered[stype] = sub;
                                  }

                                });

                                return GraphCreation.buildGraphs(
                                    filtered, _palette);

                              }),

                            ],

                          ],
                        ),
                ),

              ],
            ),
          ),

          RepaintBoundary(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: _logs.length,
              itemBuilder: (_, i) =>
                  Text(_logs[i],
                      style:
                          const TextStyle(fontSize: 12)),
            ),
          ),

        ],
      ),
    );
  }
}