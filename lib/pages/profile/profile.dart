import 'package:flutter/material.dart';
import 'package:interval_timer/l10n/app_localizations.dart';
import 'package:interval_timer/pages/profile/components/setting_rate.dart';
import 'package:interval_timer/pages/profile/components/settings_block.dart';
import 'package:interval_timer/pages/profile/components/settings_tile.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import '../../components/dialogs.dart';
import '../../const.dart';
import '../../main.dart';
import 'components/settins_page.dart';
import 'package:interval_timer/services/settings_service.dart';
import 'package:just_audio/just_audio.dart';

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
              const RateApp(version: '1.1.2'),
              SettingsBlock(
                title: AppLocalizations.of(context)!.profile_settings,
                tiles: [
                  SettingsTile(
                    title:
                        AppLocalizations.of(context)!.profile_settings_darkmode,
                    icon: Icon(TablerIcons.moon,
                        color: context.colors.iconSecondary),
                    switching: true,
                    onTap: (selected) {
                      selected!
                          ? MyApp.of(context).changeTheme(ThemeMode.dark)
                          : MyApp.of(context).changeTheme(ThemeMode.light);
                    },
                  ),
                  SettingsTile(
                      title: AppLocalizations.of(context)!
                          .profile_settings_language,
                      icon: Icon(TablerIcons.language,
                          color: context.colors.iconSecondary),
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
                          color: context.colors.iconSecondary),
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
                    title: AppLocalizations.of(context)!.profile_legal_imprint,
                    onTap: (selected) =>
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => SettingsPage(
                                  language:
                                      SettingsService.language,
                                  index: 1,
                                ))),
                  ),
                  SettingsTile(
                    last: true,
                    title: AppLocalizations.of(context)!.profile_legal_privacy,
                    onTap: (selected) =>
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => SettingsPage(
                                  language:
                                      SettingsService.language,
                                  index: 2,
                                ))),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text("Version 1.1.2", style: body1(context)),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}
