import 'package:flutter/material.dart';
import 'package:interval_timer/pages/direct_start.dart';
import 'package:interval_timer/pages/profile.dart';
import 'package:interval_timer/pages/workouts.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

import '../const.dart';
import '../widgets/hide_widgets_on_scroll.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late ScrollController controller;
  final List<Widget> screens = const [Workouts(), DirectStart(), Profile()];
  int screenIndex = 0;

  @override
  void initState() {
    super.initState();
    controller = ScrollController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[screenIndex],
      bottomNavigationBar: ScrollToHideWidget(
        controller: controller,
        child: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
                icon: IconButton(
                    onPressed: () => setState(() {
                          screenIndex = 0;
                        }),
                    icon: Icon(
                      TablerIcons.stretching,
                      color: screenIndex == 0 ? Colors.deepPurple : Colors.grey,
                    )),
                label: "Workouts"),
            BottomNavigationBarItem(
                icon: IconButton(
                    onPressed: () => setState(() {
                          screenIndex = 1;
                        }),
                    icon: Icon(
                      TablerIcons.player_play,
                      color: screenIndex == 1 ? Colors.deepPurple : Colors.grey,
                    )),
                label: "Direktstart"),
            BottomNavigationBarItem(
              icon: Column(
                children: [
                  IconButton(
                      onPressed: () => setState(() {
                            screenIndex = 2;
                          }),
                      icon: Icon(
                        TablerIcons.user_circle,
                        color:
                            screenIndex == 2 ? Colors.deepPurple : Colors.grey,
                      )),
                ],
              ),
              label: "Profil",
            ),
          ],
        ),
      ),
    );
  }
}
