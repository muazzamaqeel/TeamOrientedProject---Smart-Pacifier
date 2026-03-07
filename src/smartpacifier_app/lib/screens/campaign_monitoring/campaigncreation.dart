// File: lib/screens/campaign_monitoring/campaigncreation.dart

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../client_layer/connector.dart';
import '../../ipc_layer/mqtt/sensor_packet.dart';
import '../active_monitoring/graphcreation.dart';

class CampaignCreation extends StatefulWidget {
  final String backend;

  const CampaignCreation({super.key, required this.backend});

  @override
  State<CampaignCreation> createState() => _CampaignCreationState();
}

class _CampaignCreationState extends State<CampaignCreation>
    with SingleTickerProviderStateMixin {

  final _campaignController = TextEditingController();

  final _available = <String>{};
  final _selected = <String>{};

  bool _inCampaign = false;

  StreamSubscription<SensorPacket>? _sub;

  Timer? _renderTimer;

  late final TabController _tabs;

  int _nextX = 0;

  final _buffers = <String, Map<String, Map<String, List<FlSpot>>>>{};

  final _logs = <String>[];

  final _palette = [
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

    _tabs = TabController(length: 2, vsync: this);

    /// detect pacifiers automatically
    Connector().dataStreamFor(widget.backend).listen((packet) {

      final id = packet.pacifierId;

      if (_available.add(id)) {
        setState(() {});
      }

    });
  }

  void _startCampaign() {

    if (_campaignController.text.trim().isEmpty || _selected.isEmpty) {
      return;
    }

    _buffers.clear();
    _logs.clear();
    _nextX = 0;

    _sub = Connector()
        .dataStreamFor(widget.backend)
        .listen(

      _onData,

      onError: (e) => _onDoneOrError(
          'Error: $e\nCampaign stopped'),

      onDone: () => _onDoneOrError(
          'Backend disconnected\nCampaign stopped'),
    );

    _renderTimer?.cancel();

    _renderTimer = Timer.periodic(
      const Duration(milliseconds: 33),
          (_) {
        if (mounted) setState(() {});
      },
    );

    setState(() => _inCampaign = true);
  }

  void _onData(SensorPacket packet) {

    final t = (_nextX++).toDouble();

    if (!_selected.contains(packet.pacifierId)) {
      return;
    }

    final typeMap =
    _buffers.putIfAbsent(packet.sensorType, () => {});

    final groupName =
        '${packet.sensorGroup}_${packet.pacifierId}';

    final groupMap =
    typeMap.putIfAbsent(groupName, () => {});

    /// add sensor values
    packet.values.forEach((key, value) {

      final s = groupMap.putIfAbsent(key, () => []);

      s.add(FlSpot(t, value.toDouble()));

      if (s.length > 50) {
        s.removeAt(0);
      }

    });

    /// logging
    _logs.add(
      '[${DateTime.now().toIso8601String()}] '
          'pacifier=${packet.pacifierId}, '
          'type=${packet.sensorType}, '
          'group=${packet.sensorGroup}, '
          'values=${packet.values}',
    );
  }

  void _onDoneOrError(String message) {

    _sub?.cancel();

    _renderTimer?.cancel();

    if (mounted) {

      setState(() {

        _inCampaign = false;

        _selected.clear();

        _buffers.clear();

        _logs.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  Future<void> _endCampaign() async {

    final pathCtrl = TextEditingController();

    String? errorText;

    final result = await showDialog<String>(

      context: context,

      builder: (ctx) => StatefulBuilder(

        builder: (ctx2, setInner) => AlertDialog(

          title: const Text('Save Campaign Logs'),

          content: TextField(
            controller: pathCtrl,
            decoration: InputDecoration(
              labelText: 'Full file path',
              hintText:
              '/home/user/camp.txt or C:\\Logs\\camp.txt',
              errorText: errorText,
            ),
          ),

          actions: [

            TextButton(
                onPressed: () => Navigator.pop(ctx2),
                child: const Text('Cancel')),

            ElevatedButton(
              onPressed: () {

                final p = pathCtrl.text.trim();

                if (p.isEmpty ||
                    !p.toLowerCase().endsWith('.txt')) {

                  setInner(() => errorText =
                  'Path must end with ".txt"');

                  return;
                }

                final dir = Directory(p).parent;

                if (!dir.existsSync()) {

                  setInner(() => errorText =
                  'Directory does not exist');

                  return;
                }

                Navigator.pop(ctx2, p);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );

    if (result == null) return;

    try {

      File(result)
        ..createSync(recursive: true)
        ..writeAsStringSync(
          _logs.join('\n') + '\n',
          mode: FileMode.append,
        );

      _onDoneOrError('Logs saved, campaign ended');

    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Save failed: $e')),
      );
    }
  }

  @override
  void dispose() {

    _campaignController.dispose();

    _sub?.cancel();

    _renderTimer?.cancel();

    _tabs.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    if (!_inCampaign) {

      return Padding(

        padding: const EdgeInsets.all(16),

        child: Column(

          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            const Text(
              'Create New Campaign',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: _campaignController,
              decoration: const InputDecoration(
                  labelText: 'Campaign Name'),
            ),

            const SizedBox(height: 16),

            const Text('Select Pacifiers:'),

            const SizedBox(height: 8),

            Wrap(
              spacing: 12,
              children: _available.map((id) {

                final sel = _selected.contains(id);

                return FilterChip(

                  label: Text('Pacifier $id'),

                  selected: sel,

                  onSelected: (_) => setState(() {
                    sel
                        ? _selected.remove(id)
                        : _selected.add(id);
                  }),
                );
              }).toList(),
            ),

            const SizedBox(height: 24),

            ElevatedButton(
                onPressed: _startCampaign,
                child: const Text('Start Campaign')),
          ],
        ),
      );
    }

    final pacs = _selected.toList()
      ..sort((a, b) => int.parse(a)
          .compareTo(int.parse(b)));

    return Scaffold(

      appBar: AppBar(

        title: Text(
            'Campaign — ${widget.backend} (${_campaignController.text})'),

        actions: [

          TextButton(
            onPressed: _endCampaign,
            child: const Text('End'),
            style: TextButton.styleFrom(
                foregroundColor: Colors.red),
          ),
        ],

        bottom: TabBar(
            controller: _tabs,
            tabs: const [
              Tab(text: 'Graphs'),
              Tab(text: 'Logs')
            ]),
      ),

      body: TabBarView(
        controller: _tabs,

        children: [

          Column(
            children: [

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.all(8),

                child: Row(
                  children: pacs.map((id) {

                    return Padding(

                      padding:
                      const EdgeInsets.only(right: 8),

                      child: FilterChip(
                          label: Text('Pacifier $id'),
                          selected: true,
                          onSelected: (_) {}),
                    );

                  }).toList(),
                ),
              ),

              Expanded(
                child: ListView(
                  children: pacs.expand((id) {

                    return [

                      Padding(
                        padding:
                        const EdgeInsets.symmetric(
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

                        final filtered = <String,
                            Map<String,
                                Map<String,
                                    List<FlSpot>>>>{};

                        _buffers.forEach((stype, groups) {

                          final sub =
                          <String,
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

                        return GraphCreation
                            .buildGraphs(
                            filtered, _palette);
                      }),
                    ];

                  }).toList(),
                ),
              ),
            ],
          ),

          ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: _logs.length,
            itemBuilder: (_, i) =>
                Text(_logs[i],
                    style:
                    const TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }
}