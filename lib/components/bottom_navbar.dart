import 'package:flutter/material.dart';
import 'package:interval_timer/components/hide_widgets_on_scroll.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:interval_timer/l10n/app_localizations.dart';
import 'package:interval_timer/const.dart';

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
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
        child: BottomNavigationBar(
          onTap: (index) {
            widget.onTabTapped(index);
            setState(() {});
          },
          unselectedLabelStyle: footerBold(context),
          selectedLabelStyle: footerBold(context),
          selectedIconTheme: IconThemeData(color: context.colors.neutral850),
          unselectedIconTheme: IconThemeData(color: context.colors.subtleElement),
          selectedItemColor: context.colors.neutral850,
          unselectedItemColor: context.colors.subtleElement,
          currentIndex: widget.screenIndex,
          items: [
            BottomNavigationBarItem(
                icon: const Padding(
                  padding: EdgeInsets.only(top: 12.0, bottom: 2),
                  child: Icon(
                    TablerIcons.stretching,
                  ),
                ),
                label: AppLocalizations.of(context)!.title_workouts),
            BottomNavigationBarItem(
                icon: const Padding(
                  padding: EdgeInsets.only(top: 12.0, bottom: 2),
                  child: Icon(
                    TablerIcons.player_play,
                  ),
                ),
                label: AppLocalizations.of(context)!.title_jump_in),
            BottomNavigationBarItem(
              icon: const Padding(
                padding: EdgeInsets.only(top: 12.0, bottom: 2),
                child: Icon(
                  TablerIcons.user_circle,
                ),
              ),
              label: AppLocalizations.of(context)!.title_profile,
            ),
          ],
        ),
      ),
    );
  }
}
