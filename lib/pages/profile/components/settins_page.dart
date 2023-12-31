import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:interval_timer/const.dart';
import 'package:interval_timer/main.dart';
import 'settings_page_legal.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

class SettingsPage extends StatelessWidget {
  final int index;
  const SettingsPage({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            index == 1
                ? 'Imprint'
                : index == 2
                    ? 'Privacy'
                    : 'Terms',
          ),
          titleTextStyle: heading3Bold(context),
          centerTitle: true,
          surfaceTintColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(TablerIcons.chevron_left,
                color: MyApp.of(context).isDarkMode()
                    ? darkNeutral850
                    : lightNeutral700),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: (() {
          switch (index) {
            case 1:
              return SettingsPageLegal(
                  data: rootBundle.loadString('assets/legal/imprint.md'));
            case 2:
              return SettingsPageLegal(
                  data: rootBundle.loadString('assets/legal/privacy.md'));
            case 3:
              return SettingsPageLegal(
                  data: rootBundle.loadString('assets/legal/terms.md'));
          }
        }()));
  }
}
