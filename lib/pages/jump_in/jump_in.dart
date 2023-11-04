import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:interval_timer/components/workout_times_container.dart';

class JumpIn extends StatelessWidget {
  const JumpIn({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Gesamtzeit'),
        Text('12:30'),
        WorkoutTimesContainer(),
        TextButton(onPressed: () {}, child: Text("Workout starten")),
        TextButton(onPressed: () {}, child: Text("als Workout speichern"))
      ],
    );
  }
}
