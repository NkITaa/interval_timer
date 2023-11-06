import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:interval_timer/pages/profile/components/settings_block.dart';
import 'package:interval_timer/pages/profile/components/settings_tile.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'components/settins_page.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.title_profile),
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
                title: AppLocalizations.of(context)!.title_profile,
                tiles: [
                  SettingsTile(
                    title: AppLocalizations.of(context)!.title_profile,
                    icon: const Icon(TablerIcons.moon),
                    switching: true,
                  ),
                  SettingsTile(
                    title: AppLocalizations.of(context)!.title_profile,
                    icon: const Icon(TablerIcons.settings),
                  ),
                  SettingsTile(
                      title: AppLocalizations.of(context)!.title_profile,
                      icon: const Icon(TablerIcons.user),
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const SettingsPage(
                                index: 0,
                              )))),
                ],
              ),
              SettingsBlock(
                title: AppLocalizations.of(context)!.title_profile,
                tiles: [
                  SettingsTile(
                    title: AppLocalizations.of(context)!.title_profile,
                    icon: const Icon(TablerIcons.user),
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const SettingsPage(
                              index: 1,
                            ))),
                  ),
                  SettingsTile(
                    title: AppLocalizations.of(context)!.title_profile,
                    icon: const Icon(TablerIcons.settings),
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const SettingsPage(
                              index: 2,
                            ))),
                  ),
                  SettingsTile(
                    title: AppLocalizations.of(context)!.title_profile,
                    icon: const Icon(TablerIcons.user),
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const SettingsPage(
                              index: 3,
                            ))),
                  ),
                ],
              ),
              SettingsBlock(
                title: AppLocalizations.of(context)!.title_profile,
                tiles: [
                  SettingsTile(
                    title: AppLocalizations.of(context)!.title_profile,
                    icon: const Icon(TablerIcons.user),
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const SettingsPage(
                              index: 4,
                            ))),
                  ),
                  SettingsTile(
                    title: AppLocalizations.of(context)!.title_profile,
                    icon: const Icon(TablerIcons.settings),
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const SettingsPage(
                              index: 5,
                            ))),
                  ),
                  SettingsTile(
                    title: AppLocalizations.of(context)!.title_profile,
                    icon: const Icon(TablerIcons.user),
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
