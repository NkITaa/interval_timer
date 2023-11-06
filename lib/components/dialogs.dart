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
          WorkoutTimesContainer(),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Cancel'),
          ),
        ]));
  }

  static Widget buildSetTimesDialog(
      BuildContext context,
      String type,
      DateTime? minutes,
      int? sets,
      Function(String type, int value, bool? minute) setValue) {
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
                        TimeWheel(
                          type: type,
                          value: minutes!.minute,
                          setValue: setValue,
                          minute: true,
                        ),
                        Text(":"),
                        TimeWheel(
                          type: type,
                          value: minutes.second,
                          setValue: setValue,
                          minute: false,
                        ),
                      ],
                    )
                  : TimeWheel(
                      type: type,
                      value: sets!,
                      setValue: setValue,
                    ),
              Text("Workoutdauer 00:00:00"),
              TextButton(onPressed: () {}, child: Text("Workout Speichern")),
            ],
          ),
        ));
  }
}
