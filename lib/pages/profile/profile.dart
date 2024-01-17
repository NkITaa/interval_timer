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
import 'package:hive/hive.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  void initState() {
    super.initState();
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
              RateApp(version: '1.1.0'),
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
                    onTap: (selected) {
                      showModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          isScrollControlled: true,
                          enableDrag: false,
                          context: context,
                          builder: (BuildContext context) => Container(
                                height: 150,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color: MyApp.of(context).isDarkMode()
                                      ? darkNeutral0
                                      : lightNeutral100,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    topRight: Radius.circular(16),
                                  ),
                                ),
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          MyApp.of(context).isDarkMode()
                                              ? darkNeutral0
                                              : lightNeutral100,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    onPressed: () {
                                      selected!
                                          ? MyApp.of(context)
                                              .changeTheme(ThemeMode.dark)
                                          : MyApp.of(context)
                                              .changeTheme(ThemeMode.light);

                                      Phoenix.rebirth(context);
                                    },
                                    child: Text(
                                      AppLocalizations.of(context)!.restart_app,
                                      style: body1Bold(context),
                                    )),
                              ));
                    },
                  ),
                  SettingsTile(
                      title: AppLocalizations.of(context)!
                          .profile_settings_language,
                      icon: Icon(TablerIcons.language,
                          color: MyApp.of(context).isDarkMode()
                              ? darkNeutral700
                              : lightNeutral600),
                      onTap: (selected) => showModalBottomSheet(
                            backgroundColor: Colors.transparent,
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
                      onTap: (selected) async {
                        final player = AudioPlayer();
                        // ignore: use_build_context_synchronously
                        showModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          isScrollControlled: true,
                          enableDrag: false,
                          context: context,
                          builder: (BuildContext context) =>
                              Dialogs.buildChangeSoundDialog(
                                  player, context, setState),
                        ).whenComplete(() => player.dispose());
                      }),
                ],
              ),
              SettingsBlock(
                title: AppLocalizations.of(context)!.profile_legal,
                tiles: [
                  SettingsTile(
                    last: true,
                    title: AppLocalizations.of(context)!.profile_legal_imprint,
                    onTap: (selected) =>
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => SettingsPage(
                                  language:
                                      Hive.box("settings").get("language"),
                                  index: 1,
                                ))),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text("Version 1.1.0", style: body1(context)),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}
