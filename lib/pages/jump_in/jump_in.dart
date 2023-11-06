import 'package:flutter/material.dart';
import 'package:interval_timer/components/workout_times_container.dart';

class JumpIn extends StatelessWidget {
  const JumpIn({super.key});

  updateTime(String type, bool increment) {}
  setValue(String type, int value, bool? minute) {}

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Gesamtzeit'),
        const Text('12:30'),
        WorkoutTimesContainer(
          update: updateTime,
          setValue: setValue,
          minutesTraining: const Duration(minutes: 1, seconds: 15),
          minutesPause: const Duration(seconds: 15),
          sets: 3,
        ),
        TextButton(onPressed: () {}, child: const Text("Workout starten")),
        TextButton(onPressed: () {}, child: const Text("als Workout speichern"))
      ],
    );
  }
}
