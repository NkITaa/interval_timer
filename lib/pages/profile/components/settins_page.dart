import 'package:flutter/material.dart';
import 'package:interval_timer/pages/profile/components/setings_page_contact.dart';
import 'package:interval_timer/pages/profile/components/settings_page_about.dart';
import 'package:interval_timer/pages/profile/components/settings_page_faq.dart';
import 'package:interval_timer/pages/profile/components/settings_page_sound.dart';

import 'settings_page_legal.dart';

class SettingsPage extends StatelessWidget {
  final int index;
  const SettingsPage({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Settings Page'),
        ),
        body: (() {
          switch (index) {
            case 0:
              return SettingsPageSound();
            case 1:
              return SettingsPageFAQ();
            case 2:
              return SettingsPageContact();
            case 3:
              return SettingsPageAbout();
            case 4:
              return SettingsPageLegal();
            case 5:
              return SettingsPageLegal();
            case 6:
              return SettingsPageLegal();
          }
        }()));
  }
}
