import 'package:flutter/material.dart';
import 'package:interval_timer/pages/profile/components/setings_page_contact.dart';
import 'package:interval_timer/pages/profile/components/settings_page_about.dart';
import 'package:interval_timer/pages/profile/components/settings_page_faq.dart';

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
              return const SettingsPageFAQ();
            case 2:
              return const SettingsPageContact();
            case 3:
              return const SettingsPageAbout();
            case 4:
              return const SettingsPageLegal();
            case 5:
              return const SettingsPageLegal();
            case 6:
              return const SettingsPageLegal();
          }
        }()));
  }
}
