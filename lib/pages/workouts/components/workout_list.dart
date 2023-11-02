import 'package:flutter/material.dart';
import 'package:interval_timer/pages/workouts/components/workout_tile.dart';

class WorkoutList extends StatelessWidget {
  const WorkoutList({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        WorkoutTile(),
        Text('child 2')
      ],
    );
  }
}
