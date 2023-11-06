import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

import '../../../main.dart';

class SettingsTile extends StatefulWidget {
  final Icon icon;
  final String title;
  final bool switching;
  final Function()? onTap;
  const SettingsTile(
      {super.key,
      required this.icon,
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
        ListTile(
          leading: widget.icon,
          title: const Text("data"),
          trailing: widget.switching
              ? Switch(
                  value: MyApp.of(context).isDarkMode(),
                  onChanged: (selected) {
                    selected
                        ? MyApp.of(context).changeTheme(ThemeMode.dark)
                        : MyApp.of(context).changeTheme(ThemeMode.light);
                    setState(() {});
                  })
              : const Icon(TablerIcons.chevron_right),
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
