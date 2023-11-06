import 'package:flutter/material.dart';
import 'package:interval_timer/components/custom_textbox.dart';
import 'package:interval_timer/components/time_wheel.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';
import 'package:interval_timer/components/workout_times_container.dart';

class Dialogs {
  static Widget buildAddWorkoutDialog(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(24),
        color: Colors.amber,
        child: Column(children: [
          const Text('Workout Erstellen'),
          const CustomTextbox(
            label: "Bezeichnung",
          ),
          const WorkoutTimesContainer(),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Cancel'),
          ),
        ]));
  }

  static Widget buildSetTimesDialog(BuildContext context, String type) {
    return AlertDialog(
        title: const Text('Set Times'),
        content: SizedBox(
          height: 300,
          child: Column(
            children: [
              type != "set"
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TimeWheel(),
                        Text(":"),
                        TimeWheel(),
                      ],
                    )
                  : TimeWheel(),
              Text("Workoutdauer 00:00:00"),
              TextButton(onPressed: () {}, child: Text("Workout Speichern")),
            ],
          ),
        ));
  }
}
