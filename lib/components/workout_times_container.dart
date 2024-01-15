import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../const.dart';
import '../main.dart';
import 'increment_decrement_button.dart';

class WorkoutTimesContainer extends StatelessWidget {
  final Function(String type, bool increment) update;
  final Function(String type, int value, bool? minute) setValue;
  final Function? killVisible;
  final Duration minutesTraining;
  final Duration minutesPause;
  final bool visible;
  final int sets;

  const WorkoutTimesContainer(
      {super.key,
      required this.update,
      this.killVisible,
      required this.setValue,
      required this.minutesTraining,
      required this.minutesPause,
      required this.visible,
      required this.sets});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          boxShadow: [
            MyApp.of(context).isDarkMode()
                ? const BoxShadow(
                    color: Colors.transparent,
                    spreadRadius: 0,
                    blurRadius: 0,
                    offset: Offset(0, 0),
                  )
                : BoxShadow(
                    color: const Color(0xff1D1D1D).withOpacity(0.08),
                    spreadRadius: 0,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
          ],
          color:
              MyApp.of(context).isDarkMode() ? darkNeutral100 : lightNeutral0,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Wrap(spacing: 12, runSpacing: 12, children: [
          IncrementDecrementButton(
            killVisible: killVisible,
            visible: visible,
            type: "training",
            minutes: minutesTraining,
            otherMinutes: minutesPause,
            sets: sets,
            update: update,
            setValue: setValue,
          ),
          IncrementDecrementButton(
            visible: false,
            type: "pause",
            minutes: minutesPause,
            otherMinutes: minutesTraining,
            sets: sets,
            update: update,
            setValue: setValue,
          ),
          IncrementDecrementButton(
            visible: false,
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
