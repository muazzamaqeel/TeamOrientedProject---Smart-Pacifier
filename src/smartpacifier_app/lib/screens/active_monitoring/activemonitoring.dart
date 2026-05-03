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

  final ScrollController _logScroll = ScrollController();

  late final TabController _tabController;
  int _packetCount = 0;
  final ValueNotifier<double> _hzNotifier = ValueNotifier(0);
  Timer? _hzTimer;

  int _frameCount = 0;
  final ValueNotifier<double> _fpsNotifier = ValueNotifier(0);
  Timer? _fpsTimer;

  late final Ticker _ticker;
  bool _needsRebuild = false;

  /// 🔴 Live values for badges
  final Map<String, double> _liveValues = {};

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

    /// GPU smooth rendering ticker
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

        /// schedule UI rebuild via ticker (NOT per packet)
        _needsRebuild = true;

        final line =
            '[ESP=${packet.espTimeLabel}] '
            '[${packet.sensorGroup}] '
            'topic=${packet.topic ?? "-"}, '
            'pacifier=${packet.pacifierId}, '
            'type=${packet.sensorType}, '
            'values=${packet.values}';

        _logs.add(line);

        if (_logs.length > 200) {
          _logs.removeAt(0);
        }

        SchedulerBinding.instance.addPostFrameCallback((_) {
          if (_logScroll.hasClients) {
            _logScroll.jumpTo(
              _logScroll.position.maxScrollExtent,
            );
          }
        });
      },
      onError: (e) {
        _logs.add('[ERROR] $e');
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

    final t = packet.graphTimeSeconds;

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

      /// keep sliding window (oscilloscope style)
      if (series.length > 150) {
        series.removeAt(0);
      }

      /// update live value
      _liveValues['${packet.sensorType}_$key'] =
          value.toDouble();
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
    _logScroll.dispose();
    super.dispose();
  }

  Widget _buildLiveBadge(String label) {

    final value = _liveValues[label];

    if (value == null) return const SizedBox();

    return Container(
      margin: const EdgeInsets.only(left: 8),
      padding: const EdgeInsets.symmetric(
          horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        value.toStringAsFixed(2),
        style: const TextStyle(
            fontSize: 11,
            color: Colors.white,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildLogCard(String line) {

    final espMatch = RegExp(r'\[ESP=(.*?)\]').firstMatch(line);

    final ts = espMatch != null
        ? 'ESP ${espMatch.group(1)}'
        : '';

    final pacMatch = RegExp(r'pacifier=(\d+)').firstMatch(line);
    final pacifier = pacMatch?.group(1) ?? '?';

    final typeMatch = RegExp(r'type=(\w+)').firstMatch(line);
    final type = typeMatch?.group(1) ?? 'unknown';

    final valuesMatch = RegExp(r'values=\{(.*)\}').firstMatch(line);
    final values = valuesMatch?.group(1) ?? '';

    Color typeColor;

    switch (type) {
      case 'pat':
        typeColor = Colors.orange;
        break;
      case 'airflow':
        typeColor = Colors.green;
        break;
      case 'imu':
        typeColor = Colors.blue;
        break;
      default:
        typeColor = Colors.grey;
    }

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 3),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: typeColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                type.toUpperCase(),
                style: TextStyle(
                  color: typeColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    'Pacifier $pacifier',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 2),

                  Text(
                    values,
                    style: const TextStyle(fontSize: 12),
                  ),

                  const SizedBox(height: 2),

                  Text(
                    ts,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
                          child: Row(
                            children: [
                              Text(
                                'Pacifier $id',
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight:
                                    FontWeight.bold),
                              ),
                              const SizedBox(width: 10),
                                _buildLiveBadge('pat_pressure_hpa'),
                                _buildLiveBadge('pat_temperature_c'),

                                _buildLiveBadge('airflow_in0_c'),
                                _buildLiveBadge('airflow_in1_c'),
                                _buildLiveBadge('airflow_in2_c'),

                                _buildLiveBadge('ppg_ID_1_led_1'),
                                _buildLiveBadge('ppg_ID_1_led_2'),
                                _buildLiveBadge('ppg_ID_1_led_3'),
                                _buildLiveBadge('ppg_ID_1_temperature_c'),
                            ],
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
              controller: _logScroll,
              padding: const EdgeInsets.all(8),
              itemCount: _logs.length,
              itemBuilder: (_, i) => _buildLogCard(_logs[i]),
            ),
          ),

        ],
      ),
    );
  }
}