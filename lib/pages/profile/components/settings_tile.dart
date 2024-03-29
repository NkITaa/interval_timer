import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

import '../../../const.dart';
import '../../../main.dart';

class SettingsTile extends StatefulWidget {
  final Icon? icon;
  final String title;
  final bool switching;
  final bool last;
  final Function(bool?)? onTap;
  const SettingsTile(
      {super.key,
      this.icon,
      required this.title,
      this.onTap,
      this.last = false,
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
                contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                title: Text(widget.title, style: body1(context)),
                trailing: Icon(TablerIcons.chevron_right,
                    color: MyApp.of(context).isDarkMode()
                        ? darkNeutral900
                        : lightNeutral850),
                onTap: () => widget.onTap!(false),
              )
            : ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                leading: widget.icon,
                title: Text(widget.title, style: body1(context)),
                trailing: widget.switching
                    ? Switch(
                        inactiveThumbColor: Colors.white,
                        thumbColor: MaterialStateProperty.all<Color>(
                          Colors.white,
                        ),
                        trackOutlineColor: MaterialStateProperty.all<Color>(
                            Colors.transparent),
                        inactiveTrackColor: MyApp.of(context).isDarkMode()
                            ? darkNeutral500
                            : lightNeutral300,
                        trackColor: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.selected)) {
                              return MyApp.of(context).isDarkMode()
                                  ? const Color(0xff5F8DEE)
                                  : const Color(0xff3772EE);
                            }
                            return null;
                          },
                        ),
                        value: MyApp.of(context).isDarkMode(),
                        onChanged: (selected) {
                          widget.onTap!(selected);
                        })
                    : Icon(
                        TablerIcons.chevron_right,
                        color: MyApp.of(context).isDarkMode()
                            ? darkNeutral900
                            : lightNeutral850,
                      ),
                onTap: () => widget.onTap!(false),
              ),
        widget.last
            ? const SizedBox()
            : Divider(
                height: 0,
                thickness: 1,
                color: MyApp.of(context).isDarkMode()
                    ? darkNeutral200
                    : lightNeutral200,
              )
      ],
    );
  }
}
