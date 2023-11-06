import 'package:flutter/material.dart';

import 'increment_decrement_button.dart';

class WorkoutTimesContainer extends StatefulWidget {
  WorkoutTimesContainer({super.key});

  @override
  State<WorkoutTimesContainer> createState() => _WorkoutTimesContainerState();
}

class _WorkoutTimesContainerState extends State<WorkoutTimesContainer> {
  DateTime minutesTraining = DateTime(0, 0, 0, 0, 1, 15);

  DateTime minutesPause = DateTime(0, 0, 0, 0, 0, 15);

  int sets = 3;

  update(String type, bool increment) {
    if (increment) {
      if (type == "training") {
        minutesTraining = minutesTraining!.add(const Duration(seconds: 15));
      } else if (type == "pause") {
        minutesPause = minutesPause!.add(const Duration(seconds: 15));
      } else {
        sets = sets! + 1;
      }
    } else {
      if (type == "training") {
        minutesTraining =
            minutesTraining!.subtract(const Duration(seconds: 15));
      } else if (type == "pause") {
        minutesPause = minutesPause!.subtract(const Duration(seconds: 15));
      } else {
        sets = sets! - 1;
      }
    }
    setState(() {});
  }

  setValue(String type, int value, bool? minute) {
    if (type == "training") {
      if (minute!)
        minutesTraining = DateTime(0, 0, 0, 0, value, minutesTraining.second);
      else
        minutesTraining = DateTime(0, 0, 0, 0, minutesTraining.minute, value);
    } else if (type == "pause") {
      if (minute!)
        minutesPause = DateTime(0, 0, 0, 0, value, minutesPause.second);
      else
        minutesPause = DateTime(0, 0, 0, 0, minutesPause.minute, value);
    } else {
      sets = value;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          IncrementDecrementButton(
            type: "training",
            minutes: minutesTraining,
            update: update,
            setValue: setValue,
          ),
          IncrementDecrementButton(
            type: "pause",
            minutes: minutesPause,
            update: update,
            setValue: setValue,
          ),
          IncrementDecrementButton(
            type: "set",
            sets: sets,
            update: update,
            setValue: setValue,
          ),
        ],
      ),
    );
  }
}
