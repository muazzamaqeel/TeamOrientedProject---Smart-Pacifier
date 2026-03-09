import 'package:flutter/material.dart';
import 'package:smartpacifier_app/client_layer/connector.dart';
import 'package:smartpacifier_app/components/sidebar/sidebar.dart';
import 'package:smartpacifier_app/ipc_layer/mqtt/mqtt_service.dart';
import 'package:smartpacifier_app/screens/active_monitoring/activemonitoring.dart';
import 'package:smartpacifier_app/screens/campaign_monitoring/campaigncreation.dart';
import 'package:smartpacifier_app/screens/historic_data/historicdata.dart';
import 'package:smartpacifier_app/screens/settings/settings.dart';

class AppShell extends StatefulWidget {
  final bool isDark;
  final ValueChanged<bool> onThemeChanged;

  const AppShell({
    Key? key,
    required this.isDark,
    required this.onThemeChanged,
  }) : super(key: key);

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  final Connector _connector = Connector();
  List<String> _clients = [];
  String? _selectedClient;
  SidebarItem _selectedItem = SidebarItem.activeMonitoring;
  bool _railExtended = true;

  @override
  void initState() {
    super.initState();

    _connector.clientsStream.listen((list) {
      if (!mounted) return;
      setState(() {
        _clients = list;
        _selectedClient ??= list.isNotEmpty ? list.first : null;
      });
    });
  }

  Widget _buildContent() {
    if (_selectedItem == SidebarItem.historicData) {
      return const HistoricData();
    }

    if (_selectedClient == null) {
      return Center(
        child: ValueListenableBuilder<String>(
          valueListenable: mqttService.statusMessage,
          builder: (_, status, __) => Text(
            'No backend selected\n$status',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    switch (_selectedItem) {
      case SidebarItem.activeMonitoring:
        return ActiveMonitoring(backend: _selectedClient!);
      case SidebarItem.campaignCreation:
        return CampaignCreation(backend: _selectedClient!);
      case SidebarItem.historicData:
        return const SizedBox();
      case SidebarItem.settings:
        return Settings(
          backend: _selectedClient!,
          isDark: widget.isDark,
          onThemeChanged: widget.onThemeChanged,
        );
    }
  }

  Color _statusColor(MqttConnectionStatus status) {
    switch (status) {
      case MqttConnectionStatus.connected:
        return Colors.green;
      case MqttConnectionStatus.connecting:
        return Colors.orange;
      case MqttConnectionStatus.error:
        return Colors.red;
      case MqttConnectionStatus.disconnected:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Sidebar(
            clients: _clients,
            selectedClient: _selectedClient,
            onClientSelected: (c) => setState(() {
              _selectedClient = c;
              _selectedItem = SidebarItem.activeMonitoring;
            }),
            selectedItem: _selectedItem,
            onItemSelected: (s) => setState(() => _selectedItem = s),
            isExtended: _railExtended,
            onToggle: () => setState(() => _railExtended = !_railExtended),
          ),
          Expanded(
            child: Column(
              children: [
                ValueListenableBuilder<MqttConnectionStatus>(
                  valueListenable: mqttService.connectionStatus,
                  builder: (_, status, __) {
                    return ValueListenableBuilder<String>(
                      valueListenable: mqttService.statusMessage,
                      builder: (_, text, __) => Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        color: _statusColor(status).withOpacity(0.15),
                        child: Row(
                          children: [
                            Icon(Icons.circle, size: 12, color: _statusColor(status)),
                            const SizedBox(width: 8),
                            Expanded(child: Text(text)),
                            TextButton(
                              onPressed: mqttService.connect,
                              child: const Text('Reconnect'),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                Expanded(child: _buildContent()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}