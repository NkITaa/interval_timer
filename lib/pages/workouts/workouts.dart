import 'package:flutter/material.dart';
import 'package:interval_timer/pages/workouts/components/workout_list.dart';
import 'package:interval_timer/pages/workouts/components/workouts_appbar.dart';

class Workouts extends StatelessWidget {
  const Workouts({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const WorkoutsAppbar(),
        body: Container(

          margin: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: const Wrap(
            runSpacing: 32,
            children: [
              SearchBar(),
              WorkoutList()
            ],
          ),
        ));
  }
}
