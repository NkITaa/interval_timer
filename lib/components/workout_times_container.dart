import 'package:flutter/material.dart';

import 'increment_decrement_button.dart';

class WorkoutTimesContainer extends StatefulWidget {
  final Function(Duration pause, Duration training, int sets) updateTime;

  const WorkoutTimesContainer({super.key, required this.updateTime});

  @override
  State<WorkoutTimesContainer> createState() => _WorkoutTimesContainerState();
}

class _WorkoutTimesContainerState extends State<WorkoutTimesContainer> {
  Duration minutesTraining = const Duration(minutes: 1, seconds: 15);

  Duration minutesPause = const Duration(seconds: 15);

  int sets = 3;

  update(String type, bool increment) {
    if (increment) {
      if (type == "training") {
        minutesTraining = minutesTraining + const Duration(seconds: 15);
      } else if (type == "pause") {
        minutesPause = minutesPause + const Duration(seconds: 15);
      } else {
        sets = sets + 1;
      }
    } else {
      if (type == "training") {
        minutesTraining = minutesTraining - const Duration(seconds: 15);
      } else if (type == "pause") {
        minutesPause = minutesPause - const Duration(seconds: 15);
      } else {
        sets = sets - 1;
      }
    }
    widget.updateTime(minutesPause, minutesTraining, sets);
    setState(() {});
  }

  setValue(String type, int value, bool? minute) {
    if (type == "training") {
      if (minute!) {
        minutesTraining = Duration(
            minutes: value, seconds: minutesTraining.inSeconds.remainder(60));
      } else {
        minutesTraining = Duration(
            minutes: minutesTraining.inMinutes.remainder(60), seconds: value);
      }
    } else if (type == "pause") {
      if (minute!) {
        minutesPause = Duration(
            minutes: value, seconds: minutesPause.inSeconds.remainder(60));
      } else {
        minutesPause = Duration(
            minutes: minutesPause.inMinutes.remainder(60), seconds: value);
      }
    } else {
      sets = value;
    }
    widget.updateTime(minutesPause, minutesTraining, sets);
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
