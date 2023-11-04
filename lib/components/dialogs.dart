import 'package:flutter/material.dart';
import 'package:interval_timer/components/custom_textbox.dart';
import 'package:interval_timer/components/increment_decrement_button.dart';
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
          WorkoutTimesContainer(),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Cancel'),
          ),
        ]));
  }
}
