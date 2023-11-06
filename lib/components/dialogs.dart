import 'package:flutter/material.dart';
import 'package:interval_timer/components/custom_textbox.dart';
import 'package:interval_timer/components/time_wheel.dart';
import 'package:interval_timer/components/workout_times_container.dart';

class Dialogs {
  static Widget buildAddWorkoutDialog(BuildContext context) {
    Duration workoutTime = const Duration(minutes: 4, seconds: 30);
    return StatefulBuilder(builder: (context, setState) {
      void updateTime(Duration pause, Duration training, int sets) {
        workoutTime = (pause + training) * sets;
        setState(() {});
      }

      return Container(
          padding: const EdgeInsets.all(24),
          color: Colors.amber,
          child: Column(children: [
            const Text('Workout Erstellen'),
            const CustomTextbox(
              label: "Bezeichnung",
            ),
            WorkoutTimesContainer(
              updateTime: updateTime,
            ),
            Text("Workoutdauer ${workoutTime.toString().substring(2, 7)}"),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Speichern'),
            ),
          ]));
    });
  }

  static Widget buildSetTimesDialog(
      BuildContext context,
      String type,
      Duration? minutes,
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
                          value: minutes!.inMinutes.remainder(60),
                          setValue: setValue,
                          minute: true,
                        ),
                        const Text(":"),
                        TimeWheel(
                          type: type,
                          value: minutes.inSeconds.remainder(60),
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
              const Text("Workoutdauer 00:00:00"),
              TextButton(
                  onPressed: () {}, child: const Text("Workout Speichern")),
            ],
          ),
        ));
  }
}
