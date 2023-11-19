import 'package:flutter/material.dart';
import 'package:interval_timer/pages/workouts/components/workout_tile.dart';
import 'package:hive/hive.dart';

import '../../../workout.dart';

class WorkoutList extends StatelessWidget {
  final Function setListState;
  final List<dynamic>? results;
  const WorkoutList({
    super.key,
    required this.setListState,
    this.results,
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
        itemCount: results != null
            ? results!.length
            : Hive.box("workouts").values.length,
        itemBuilder: (context, index) {
          return WorkoutTile(
            setListState: setListState,
            index: index,
            workout: results != null
                ? results![index]
                : Hive.box("workouts").getAt(index),
          );
        });
  }
}
