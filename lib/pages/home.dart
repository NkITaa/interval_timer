import 'package:flutter/material.dart';
import 'package:interval_timer/components/bottom_navbar.dart';
import 'package:interval_timer/pages/jump_in/jump_in.dart';
import 'package:interval_timer/pages/profile/profile.dart';
import 'package:interval_timer/pages/workouts/workouts.dart';

class Home extends StatefulWidget {
  final int screenIndex;
  const Home({super.key, required this.screenIndex});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late ScrollController controller;
  late List<Widget> screens;
  late int screenIndex = widget.screenIndex;

  @override
  void initState() {
    super.initState();
    controller = ScrollController();
    screens = [
      Workouts(
        controller: controller,
      ),
      const JumpIn(),
      const Profile(),
    ];
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
        bottomNavigationBar: BottomNavBar(
          controller: controller,
          screenIndex: screenIndex,
          onTabTapped: (int index) {
            setState(() {
              screenIndex = index;
            });
          },
        ));
  }
}
