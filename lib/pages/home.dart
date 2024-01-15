import 'package:flutter/material.dart';
import 'package:interval_timer/components/bottom_navbar.dart';
import 'package:interval_timer/pages/jump_in/jump_in.dart';
import 'package:interval_timer/pages/profile/profile.dart';
import 'package:interval_timer/pages/workouts/workouts.dart';
import 'package:hive/hive.dart';

class Home extends StatefulWidget {
  final int screenIndex;
  final bool visible;
  const Home({super.key, required this.screenIndex, this.visible = false});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late ScrollController controller;
  late List<Widget> screens;
  late int screenIndex = widget.screenIndex;
  late bool visible = widget.visible;

  @override
  void initState() {
    super.initState();
    controller = ScrollController();
    screens = [
      Workouts(
        controller: controller,
      ),
      JumpIn(
        visible: visible,
        killVisible: killVisible,
      ),
      const Profile(),
    ];
  }

  killVisible() {
    Hive.box("settings").put("visible", false);
    setState(() {
      visible = false;
      screens[1] = JumpIn(
        visible: visible,
        killVisible: killVisible,
      );
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
            body: screens[screenIndex],
            bottomNavigationBar: BottomNavBar(
              controller: controller,
              screenIndex: screenIndex,
              onTabTapped: (int index) {
                setState(() {
                  screenIndex = index;
                });
              },
            )),
        visible
            ? Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: Colors.black.withOpacity(0.9))
            : Container(),
      ],
    );
  }
}
