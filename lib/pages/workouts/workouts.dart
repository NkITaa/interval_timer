import 'package:flutter/material.dart';
import 'package:interval_timer/pages/workouts/components/workout_list.dart';
import 'package:interval_timer/pages/workouts/components/workout_searchbar.dart';
import 'package:interval_timer/pages/workouts/components/workouts_appbar.dart';

class Workouts extends StatelessWidget {
  final ScrollController controller;
  const Workouts({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const WorkoutsAppbar(),
        body: Container(
            margin: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: SingleChildScrollView(
              controller: controller,
              child: const Column(
                children: [WorkoutSearchBar(), WorkoutList()],
              ),
            )));
  }
}
