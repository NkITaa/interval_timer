import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

import '../../../const.dart';

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
                    color: context.colors.bodyText),
                onTap: () => widget.onTap!(false),
              )
            : ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                leading: widget.icon,
                title: Text(widget.title, style: body1(context)),
                trailing: widget.switching
                    ? Switch(
                        inactiveThumbColor: Colors.white,
                        thumbColor: WidgetStateProperty.all<Color>(
                          Colors.white,
                        ),
                        trackOutlineColor: WidgetStateProperty.all<Color>(
                            Colors.transparent),
                        inactiveTrackColor: context.colors.subtleElement,
                        trackColor: WidgetStateProperty.resolveWith<Color?>(
                          (Set<WidgetState> states) {
                            if (states.contains(WidgetState.selected)) {
                              return Theme.of(context).brightness == Brightness.dark
                                  ? const Color(0xff5F8DEE)
                                  : const Color(0xff3772EE);
                            }
                            return null;
                          },
                        ),
                        value: Theme.of(context).brightness == Brightness.dark,
                        onChanged: (selected) {
                          widget.onTap!(selected);
                        })
                    : Icon(
                        TablerIcons.chevron_right,
                        color: context.colors.bodyText,
                      ),
                onTap: () => widget.onTap!(false),
              ),
        widget.last
            ? const SizedBox()
            : Divider(
                height: 0,
                thickness: 1,
                color: context.colors.neutral200,
              )
      ],
    );
  }
}
