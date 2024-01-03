import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:interval_timer/pages/profile/components/setting_rate.dart';
import 'package:interval_timer/pages/profile/components/settings_block.dart';
import 'package:interval_timer/pages/profile/components/settings_tile.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import '../../components/dialogs.dart';
import '../../const.dart';
import '../../main.dart';
import 'components/settins_page.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:hive/hive.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? version;
  final player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      setState(() {
        version = packageInfo.version;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 24),
          child: Text(
            AppLocalizations.of(context)!.title_profile,
            style: heading2Bold(context),
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(left: 24.0, right: 24),
          child: Column(
            children: [
              RateApp(version: version),
              SettingsBlock(
                title: AppLocalizations.of(context)!.profile_settings,
                tiles: [
                  SettingsTile(
                    title:
                        AppLocalizations.of(context)!.profile_settings_darkmode,
                    icon: Icon(TablerIcons.moon,
                        color: MyApp.of(context).isDarkMode()
                            ? darkNeutral700
                            : lightNeutral600),
                    switching: true,
                    onTap: () {
                      setState(() {});
                    },
                  ),
                  SettingsTile(
                      title: AppLocalizations.of(context)!
                          .profile_settings_language,
                      icon: Icon(TablerIcons.language,
                          color: MyApp.of(context).isDarkMode()
                              ? darkNeutral700
                              : lightNeutral600),
                      onTap: () => showModalBottomSheet(
                            isScrollControlled: true,
                            enableDrag: false,
                            context: context,
                            builder: (BuildContext context) =>
                                Dialogs.buildChangeLanguageDialog(
                                    context, setState),
                          )),
                  SettingsTile(
                      title:
                          AppLocalizations.of(context)!.profile_settings_sound,
                      icon: Icon(TablerIcons.volume,
                          color: MyApp.of(context).isDarkMode()
                              ? darkNeutral700
                              : lightNeutral600),
                      last: true,
                      onTap: () {
                        showModalBottomSheet(
                          isScrollControlled: true,
                          enableDrag: false,
                          context: context,
                          builder: (BuildContext context) =>
                              Dialogs.buildChangeSoundDialog(
                                  player, context, setState),
                        ).whenComplete(() => player.stop());
                      }),
                ],
              ),
              SettingsBlock(
                title: AppLocalizations.of(context)!.profile_legal,
                tiles: [
                  SettingsTile(
                    title: AppLocalizations.of(context)!.profile_legal_imprint,
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SettingsPage(
                              language: Hive.box("settings").get("language"),
                              index: 1,
                            ))),
                  ),
                  SettingsTile(
                    title: AppLocalizations.of(context)!.profile_legal_privacy,
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SettingsPage(
                              language: Hive.box("settings").get("language"),
                              index: 2,
                            ))),
                  ),
                  SettingsTile(
                    last: true,
                    title: AppLocalizations.of(context)!.profile_legal_terms,
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SettingsPage(
                              language: Hive.box("settings").get("language"),
                              index: 3,
                            ))),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text("Version ${version ?? ''}", style: body1(context)),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}
