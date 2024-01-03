import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:interval_timer/const.dart';
import 'package:interval_timer/main.dart';
import 'settings_page_legal.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsPage extends StatelessWidget {
  final int index;
  final String language;
  const SettingsPage({super.key, required this.index, required this.language});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            index == 1
                ? AppLocalizations.of(context)!.profile_legal_imprint
                : index == 2
                    ? AppLocalizations.of(context)!.profile_legal_privacy
                    : AppLocalizations.of(context)!.profile_legal_terms,
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
                  data: rootBundle.loadString(language == "de"
                      ? 'assets/legal/imprint_de.md'
                      : 'assets/legal/imprint_en.md'));
            case 2:
              return SettingsPageLegal(
                  data: rootBundle.loadString(language == "de"
                      ? 'assets/legal/privacy_de.md'
                      : 'assets/legal/privacy_en.md'));
            case 3:
              return SettingsPageLegal(
                  data: rootBundle.loadString(language == "de"
                      ? 'assets/legal/terms_de.md'
                      : 'assets/legal/terms_en.md'));
          }
        }()));
  }
}
