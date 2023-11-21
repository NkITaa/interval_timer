import 'package:flutter/material.dart';
import 'package:interval_timer/components/hide_widgets_on_scroll.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:interval_timer/const.dart';
import 'package:interval_timer/main.dart';

class BottomNavBar extends StatefulWidget {
  final ScrollController controller;
  final int screenIndex;
  final Function(int) onTabTapped;

  const BottomNavBar(
      {super.key,
      required this.controller,
      required this.screenIndex,
      required this.onTabTapped});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return ScrollToHideWidget(
      controller: widget.controller,
      child: BottomNavigationBar(
        selectedIconTheme: MyApp.of(context).isDarkMode()
            ? const IconThemeData(color: darkNeutral850)
            : const IconThemeData(color: lightNeutral850),
        unselectedIconTheme: MyApp.of(context).isDarkMode()
            ? const IconThemeData(color: darkNeutral500)
            : const IconThemeData(color: lightNeutral300),
        selectedItemColor:
            MyApp.of(context).isDarkMode() ? darkNeutral850 : lightNeutral850,
        unselectedItemColor:
            MyApp.of(context).isDarkMode() ? darkNeutral500 : lightNeutral300,
        currentIndex: widget.screenIndex,
        items: [
          BottomNavigationBarItem(
              icon: IconButton(
                  visualDensity: VisualDensity.compact,
                  onPressed: () => {widget.onTabTapped(0), setState(() {})},
                  icon: const Icon(
                    TablerIcons.stretching,
                  )),
              label: AppLocalizations.of(context)!.title_workouts),
          BottomNavigationBarItem(
              icon: IconButton(
                  visualDensity: VisualDensity.compact,
                  onPressed: () => {widget.onTabTapped(1), setState(() {})},
                  icon: const Icon(
                    TablerIcons.player_play,
                  )),
              label: AppLocalizations.of(context)!.title_jump_in),
          BottomNavigationBarItem(
            icon: Column(
              children: [
                IconButton(
                    visualDensity: VisualDensity.compact,
                    onPressed: () => widget.onTabTapped(2),
                    icon: const Icon(
                      TablerIcons.user_circle,
                    )),
              ],
            ),
            label: AppLocalizations.of(context)!.title_profile,
          ),
        ],
      ),
    );
  }
}
