// File: lib/screens/campaign_monitoring/campaigncreation.dart

import 'dart:async';
import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:uuid/uuid.dart';

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

  final ScrollController _logScroll = ScrollController();

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

  /// SESSION VARIABLES
  String? _sessionId;
  String? _hdf5FileName;
  DateTime? _startTime;
  File? _hdf5File;

  Process? _pythonRecorder;

  final Directory _sessionBase =
      Directory('lib/screens/campaign_monitoring/sessions');

  Directory get _dataDir =>
      Directory('${_sessionBase.path}/data');

  Directory get _metaDir =>
      Directory('${_sessionBase.path}/metadata');

  Future<void> _ensureFolders() async {

    if (!await _dataDir.exists()) {
      await _dataDir.create(recursive: true);
    }

    if (!await _metaDir.exists()) {
      await _metaDir.create(recursive: true);
    }
  }

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

  /// ================================
  /// START CAMPAIGN
  /// ================================

  void _startCampaign() async {

    if (_campaignController.text.trim().isEmpty || _selected.isEmpty) {
      return;
    }

    await _ensureFolders();
    _pythonRecorder = await Process.start(
      "python",
      [
        "lib/screens/campaign_monitoring/sessions/python_scripts/recorder.py"
      ],
      mode: ProcessStartMode.detached,
    );

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

  /// ================================
  /// WRITE DATA
  /// ================================

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

    packet.values.forEach((key, value) {

      final s = groupMap.putIfAbsent(key, () => []);

      s.add(FlSpot(t, value.toDouble()));

      if (s.length > 300) {
        s.removeAt(0);
      }

    });

    /// log line
    final line =
        '[${DateTime.now().toIso8601String()}] '
        '[${packet.sensorGroup}] '
        'pacifier=${packet.pacifierId}, '
        'type=${packet.sensorType}, '
        'values=${packet.values}';

    _logs.add(line);

    if (_logs.length > 500) {
      _logs.removeAt(0);
    }

    /// auto scroll logs
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_logScroll.hasClients) {
        _logScroll.jumpTo(
          _logScroll.position.maxScrollExtent,
        );
      }
    });
  }

  /// ================================
  /// WRITE METADATA
  /// ================================

  Future<void> _writeMetadata() async {

    final end = DateTime.now();

    final yaml = '''
session_id: $_sessionId
start_ts: '${_startTime!.toLocal().toString().split(' ')[1]}'
end_ts: '${end.toLocal().toString().split(' ')[1]}'
patient:
  patient_id: '0001'
  patient_name: ${_campaignController.text}
  age: 21
  nationality: DE
protobuf:
  name: sensor_data.proto
  version: 1.0.0
hdf5_file: $_hdf5FileName
''';

    final file = File(
        "${_metaDir.path}/${_campaignController.text}.yaml");

    await file.writeAsString(yaml);
  }

  void _onDoneOrError(String message) {

    _sub?.cancel();

    _renderTimer?.cancel();

    _pythonRecorder?.kill();

    _writeMetadata(); 

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

  /// ================================
  /// SAVE CAMPAIGN
  /// ================================

  Future<void> _endCampaign() async {

    final platform = await showDialog<String>(

      context: context,

      builder: (ctx) => AlertDialog(

        title: const Text("Where are you saving?"),

        content: const Text(
            "Select your operating system"),

        actions: [

          TextButton(
              onPressed: () => Navigator.pop(ctx, "windows"),
              child: const Text("Windows")),

          TextButton(
              onPressed: () => Navigator.pop(ctx, "linux"),
              child: const Text("Linux")),
        ],
      ),
    );

    if (platform == null) return;

    if (platform == "windows") {

      await _saveWindows();

    } else {

      await _saveLinux();
    }
  }

  /// Windows file browser
  Future<void> _saveWindows() async {

    const typeGroup = XTypeGroup(
      label: 'text',
      extensions: ['txt'],
    );

    final file = await getSaveLocation(
      suggestedName: 'campaign_logs.txt',
      acceptedTypeGroups: [typeGroup],
    );

    if (file == null) return;

    final path = file.path;

    try {

      File(path).writeAsStringSync(
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

  /// Linux manual path
  Future<void> _saveLinux() async {

    final pathCtrl = TextEditingController();

    final result = await showDialog<String>(

      context: context,

      builder: (ctx) => AlertDialog(

        title: const Text("Enter Linux file path"),

        content: TextField(
          controller: pathCtrl,
          decoration: const InputDecoration(
            hintText: "/home/user/logs/campaign.txt",
          ),
        ),

        actions: [

          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Cancel")),

          ElevatedButton(
            onPressed: () {

              final p = pathCtrl.text.trim();

              if (!p.endsWith(".txt")) return;

              Navigator.pop(ctx, p);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );

    if (result == null) return;

    try {

      File(result).writeAsStringSync(
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

  /// ================================
  /// UI (UNCHANGED)
  /// ================================

  Widget _buildLogCard(String line) {

    final tsMatch = RegExp(r'^\[(.*?)\]').firstMatch(line);
    final ts = tsMatch?.group(1) ?? '';

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
  void dispose() {

    _campaignController.dispose();

    _sub?.cancel();

    _renderTimer?.cancel();

    _tabs.dispose();

    _logScroll.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final pacs = _selected.toList()
      ..sort((a, b) => int.parse(a)
          .compareTo(int.parse(b)));

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

          ListView(
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

          ListView.builder(
            controller: _logScroll,
            padding: const EdgeInsets.all(8),
            itemCount: _logs.length,
            itemBuilder: (_, i) =>
                _buildLogCard(_logs[i]),
          ),
        ],
      ),
    );
  }
}