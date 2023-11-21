import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:interval_timer/pages/profile/components/settings_block.dart';
import 'package:interval_timer/pages/profile/components/settings_tile.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import '../../const.dart';
import '../../main.dart';
import 'components/settins_page.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.title_profile,
            style: TextStyle(
              color: MyApp.of(context).isDarkMode()
                  ? darkNeutral900
                  : lightNeutral900,
              fontWeight: FontWeight.bold,
              fontSize: 22.0,
            )),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(left: 24.0, right: 24),
          child: Column(
            children: [
              SettingsTile(
                title: AppLocalizations.of(context)!.title_profile,
                icon: const Icon(TablerIcons.bell),
              ),
              SettingsBlock(
                title: AppLocalizations.of(context)!.profile_settings,
                tiles: [
                  SettingsTile(
                    title:
                        AppLocalizations.of(context)!.profile_settings_darkmode,
                    icon: const Icon(TablerIcons.moon),
                    switching: true,
                  ),
                  SettingsTile(
                    title:
                        AppLocalizations.of(context)!.profile_settings_language,
                    icon: const Icon(TablerIcons.language),
                  ),
                  SettingsTile(
                      title:
                          AppLocalizations.of(context)!.profile_settings_sound,
                      icon: const Icon(TablerIcons.volume),
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const SettingsPage(
                                index: 0,
                              )))),
                ],
              ),
              SettingsBlock(
                title: AppLocalizations.of(context)!.profile_help,
                tiles: [
                  SettingsTile(
                    title: AppLocalizations.of(context)!.profile_help_faq,
                    icon: const Icon(TablerIcons.help),
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const SettingsPage(
                              index: 1,
                            ))),
                  ),
                  SettingsTile(
                    title: AppLocalizations.of(context)!.profile_help_feedback,
                    icon: const Icon(TablerIcons.message_circle),
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const SettingsPage(
                              index: 2,
                            ))),
                  ),
                  SettingsTile(
                    title: AppLocalizations.of(context)!.profile_help_info,
                    icon: const Icon(TablerIcons.info_circle),
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const SettingsPage(
                              index: 3,
                            ))),
                  ),
                ],
              ),
              SettingsBlock(
                title: AppLocalizations.of(context)!.profile_legal,
                tiles: [
                  SettingsTile(
                    title: AppLocalizations.of(context)!.profile_legal_imprint,
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const SettingsPage(
                              index: 4,
                            ))),
                  ),
                  SettingsTile(
                    title: AppLocalizations.of(context)!.profile_legal_privacy,
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const SettingsPage(
                              index: 5,
                            ))),
                  ),
                  SettingsTile(
                    title: AppLocalizations.of(context)!.profile_legal_terms,
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const SettingsPage(
                              index: 6,
                            ))),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
