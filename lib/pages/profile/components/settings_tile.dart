import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

import '../../../const.dart';
import '../../../main.dart';

class SettingsTile extends StatefulWidget {
  final Icon? icon;
  final String title;
  final bool switching;
  final Function()? onTap;
  const SettingsTile(
      {super.key,
      this.icon,
      required this.title,
      this.onTap,
      this.switching = false});

  @override
  State<SettingsTile> createState() => _SettingsTileState();
}

class _SettingsTileState extends State<SettingsTile> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        widget.icon == null
            ? ListTile(
                title: Text(widget.title,
                    style: TextStyle(
                        color: MyApp.of(context).isDarkMode()
                            ? darkNeutral900
                            : lightNeutral850)),
                trailing: Icon(TablerIcons.chevron_right,
                    color: MyApp.of(context).isDarkMode()
                        ? darkNeutral900
                        : lightNeutral850),
                onTap: widget.onTap,
              )
            : ListTile(
                leading: widget.icon,
                title: Text(widget.title,
                    style: TextStyle(
                        color: MyApp.of(context).isDarkMode()
                            ? darkNeutral900
                            : lightNeutral850)),
                trailing: widget.switching
                    ? Switch(
                        value: MyApp.of(context).isDarkMode(),
                        onChanged: (selected) {
                          selected
                              ? MyApp.of(context).changeTheme(ThemeMode.dark)
                              : MyApp.of(context).changeTheme(ThemeMode.light);
                          widget.onTap!();
                        })
                    : Icon(
                        TablerIcons.chevron_right,
                        color: MyApp.of(context).isDarkMode()
                            ? darkNeutral900
                            : lightNeutral850,
                      ),
                onTap: widget.onTap,
              ),
        const Divider(
          height: 0,
          thickness: 1,
        )
      ],
    );
  }
}
