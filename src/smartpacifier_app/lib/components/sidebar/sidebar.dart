import 'package:flutter/material.dart';

enum SidebarItem { activeMonitoring, campaignCreation, historicData, settings }

class Sidebar extends StatelessWidget {
  final List<String> clients;
  final String? selectedClient;
  final ValueChanged<String> onClientSelected;
  final SidebarItem selectedItem;
  final ValueChanged<SidebarItem> onItemSelected;
  final bool isExtended;
  final VoidCallback onToggle;

  const Sidebar({
    super.key,
    required this.clients,
    required this.selectedClient,
    required this.onClientSelected,
    required this.selectedItem,
    required this.onItemSelected,
    required this.isExtended,
    required this.onToggle,
  });

  Widget _tile({
    required BuildContext context,
    required IconData icon,
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: Material(
        color: selected ? scheme.primary.withOpacity(0.15) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: selected ? scheme.primary : Colors.white70,
                ),
                if (isExtended) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      label,
                      style: TextStyle(
                        fontWeight:
                            selected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isExtended ? 240 : 70,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        border: const Border(
          right: BorderSide(color: Color(0xFF2B3240)),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),

          Row(
            mainAxisAlignment:
                isExtended ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
            children: [
              if (isExtended)
                const Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: Text(
                    "SmartPacifier",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              IconButton(
                icon: Icon(isExtended ? Icons.chevron_left : Icons.menu),
                onPressed: onToggle,
              ),
            ],
          ),

          const Divider(),

          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [

                for (var c in clients)
                  _tile(
                    context: context,
                    icon: Icons.sensors_outlined,
                    label: c,
                    selected: c == selectedClient,
                    onTap: () => onClientSelected(c),
                  ),

                const Divider(),

                _tile(
                  context: context,
                  icon: Icons.show_chart,
                  label: 'Active Monitoring',
                  selected: selectedItem == SidebarItem.activeMonitoring,
                  onTap: () => onItemSelected(SidebarItem.activeMonitoring),
                ),

                _tile(
                  context: context,
                  icon: Icons.campaign,
                  label: 'Campaign',
                  selected: selectedItem == SidebarItem.campaignCreation,
                  onTap: () => onItemSelected(SidebarItem.campaignCreation),
                ),

                _tile(
                  context: context,
                  icon: Icons.history,
                  label: 'Historic Data',
                  selected: selectedItem == SidebarItem.historicData,
                  onTap: () => onItemSelected(SidebarItem.historicData),
                ),

                _tile(
                  context: context,
                  icon: Icons.settings,
                  label: 'Settings',
                  selected: selectedItem == SidebarItem.settings,
                  onTap: () => onItemSelected(SidebarItem.settings),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}