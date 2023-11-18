import 'package:flutter/material.dart';
import 'package:interval_timer/pages/workouts/components/workout_tile.dart';
import 'package:hive/hive.dart';

class WorkoutList extends StatelessWidget {
  final Function setListState;
  const WorkoutList({
    super.key,
    required this.setListState,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        separatorBuilder: (context, index) => const Divider(
              color: Colors.transparent,
              height: 12,
            ),
        itemCount: Hive.box("workouts").values.length,
        itemBuilder: (context, index) {
          return WorkoutTile(
            setListState: setListState,
            index: index,
            workout: Hive.box("workouts").getAt(index),
          );
        });
  }
}
