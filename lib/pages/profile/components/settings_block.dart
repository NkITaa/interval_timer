import 'package:flutter/material.dart';
import 'package:interval_timer/pages/profile/components/settings_tile.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

class SettingsBlock extends StatelessWidget {
  const SettingsBlock({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: EdgeInsets.only(left: 24.0, right: 24),
      child: Column(
        children: [
          SettingsTile(
              icon: Icon(TablerIcons.bell),
              title: "Benachrichtigungen",
              switching: true),
          SettingsTile(
              icon: Icon(TablerIcons.bell), title: "Benachrichtigungen"),
        ],
      ),
    );
  }
}
