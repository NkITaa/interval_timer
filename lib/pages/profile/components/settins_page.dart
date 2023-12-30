import 'package:flutter/material.dart';
import 'settings_page_legal.dart';

class SettingsPage extends StatelessWidget {
  final int index;
  const SettingsPage({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Settings Page'),
        ),
        body: (() {
          switch (index) {
            case 1:
              return const SettingsPageLegal();
            case 2:
              return const SettingsPageLegal();
            case 3:
              return const SettingsPageLegal();
          }
        }()));
  }
}
