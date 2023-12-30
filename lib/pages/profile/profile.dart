import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:interval_timer/pages/profile/components/settings_block.dart';
import 'package:interval_timer/pages/profile/components/settings_tile.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import '../../components/dialogs.dart';
import '../../const.dart';
import '../../main.dart';
import 'components/settins_page.dart';
import 'package:package_info_plus/package_info_plus.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? version;

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
          padding: const EdgeInsets.only(left: 8.0),
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
              Container(
                height: 68,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  boxShadow: [
                    MyApp.of(context).isDarkMode()
                        ? const BoxShadow(
                            color: Colors.transparent,
                            spreadRadius: 0,
                            blurRadius: 0,
                            offset: Offset(0, 4), // changes position of shadow
                          )
                        : BoxShadow(
                            color: MyApp.of(context).isDarkMode()
                                ? darkNeutral900.withOpacity(0.2)
                                : lightNeutral850.withOpacity(0.2),
                            spreadRadius: 0,
                            blurRadius: 16,
                            offset: const Offset(
                                0, 1), // changes position of shadow
                          ),
                  ],
                  color: MyApp.of(context).isDarkMode()
                      ? darkNeutral50
                      : lightNeutral50,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Image(
                        image: AssetImage('assets/images/logo.png'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Simply Timer",
                            style: body2Bold(context),
                          ),
                          Text("V.${version ?? ''}", style: body2(context)),
                        ]),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.only(
                            left: 12.0, right: 12.0, top: 6.0, bottom: 6.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.profile_rate_us,
                        style: body2Bold(context).copyWith(
                          color: MyApp.of(context).isDarkMode()
                              ? darkNeutral50
                              : lightNeutral50,
                        ),
                      ),
                    )
                  ],
                ),
              ),
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
                      onTap: () => showModalBottomSheet(
                            isScrollControlled: true,
                            enableDrag: false,
                            context: context,
                            builder: (BuildContext context) =>
                                Dialogs.buildChangeSoundDialog(
                                    context, setState),
                          )),
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
                    last: true,
                    title: AppLocalizations.of(context)!.profile_legal_terms,
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const SettingsPage(
                              index: 6,
                            ))),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text("Version ${version ?? ''}", style: body1(context)),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}
