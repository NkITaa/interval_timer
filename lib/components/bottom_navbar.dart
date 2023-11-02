import 'package:flutter/material.dart';
import 'package:interval_timer/components/hide_widgets_on_scroll.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BottomNavBar extends StatelessWidget {

  final ScrollController controller;
  final int screenIndex;
  final Function(int) onTabTapped;


  const BottomNavBar({super.key, required this.controller, required this.screenIndex, required this.onTabTapped});

  @override
  Widget build(BuildContext context) {
    return ScrollToHideWidget(
      controller: controller,
      child: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: IconButton(
                  onPressed: () => onTabTapped(0),
                  icon: Icon(
                    TablerIcons.stretching,
                    color: screenIndex == 0 ? Colors.deepPurple : Colors.grey,
                  )),
              label: AppLocalizations.of(context)!.title_workouts),
          BottomNavigationBarItem(
              icon: IconButton(
                  onPressed: () => onTabTapped(1),
                  icon: Icon(
                    TablerIcons.player_play,
                    color: screenIndex == 1 ? Colors.deepPurple : Colors.grey,
                  )),
              label: AppLocalizations.of(context)!.title_jump_in),
          BottomNavigationBarItem(
            icon: Column(
              children: [
                IconButton(
                    onPressed: () => onTabTapped(2),
                    icon: Icon(
                      TablerIcons.user_circle,
                      color:
                      screenIndex == 2 ? Colors.deepPurple : Colors.grey,
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
