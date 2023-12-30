import 'package:flutter/material.dart';

import '../const.dart';
import '../main.dart';
import 'increment_decrement_button.dart';

class WorkoutTimesContainer extends StatelessWidget {
  final Function(String type, bool increment) update;
  final Function(String type, int value, bool? minute) setValue;
  final Duration minutesTraining;
  final Duration minutesPause;
  final int sets;

  const WorkoutTimesContainer(
      {super.key,
      required this.update,
      required this.setValue,
      required this.minutesTraining,
      required this.minutesPause,
      required this.sets});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color:
              MyApp.of(context).isDarkMode() ? darkNeutral100 : lightNeutral0,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Wrap(spacing: 12, runSpacing: 12, children: [
          IncrementDecrementButton(
            type: "training",
            minutes: minutesTraining,
            otherMinutes: minutesPause,
            sets: sets,
            update: update,
            setValue: setValue,
          ),
          IncrementDecrementButton(
            type: "pause",
            minutes: minutesPause,
            otherMinutes: minutesTraining,
            sets: sets,
            update: update,
            setValue: setValue,
          ),
          IncrementDecrementButton(
            type: "set",
            sets: sets,
            minutes: minutesTraining,
            otherMinutes: minutesPause,
            update: update,
            setValue: setValue,
          ),
        ]));
  }
}
