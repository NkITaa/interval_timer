import 'package:flutter/material.dart';
import 'package:interval_timer/components/workout_times_container.dart';

class JumpIn extends StatelessWidget {
  const JumpIn({super.key});

  updateTime(Duration pause, Duration training, int sets) {}

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Gesamtzeit'),
        const Text('12:30'),
        WorkoutTimesContainer(updateTime: updateTime),
        TextButton(onPressed: () {}, child: const Text("Workout starten")),
        TextButton(onPressed: () {}, child: const Text("als Workout speichern"))
      ],
    );
  }
}
