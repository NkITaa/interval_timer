import 'package:flutter/material.dart';
import 'package:interval_timer/components/workout_times_container.dart';
import 'package:interval_timer/pages/jump_in/components/total_time.dart';

class JumpIn extends StatefulWidget {
  const JumpIn({super.key});

  @override
  State<JumpIn> createState() => _JumpInState();
}

class _JumpInState extends State<JumpIn> {
  void updateTime(Duration pause, Duration training, int sets) {
    workoutTime = (pause + training) * sets;
    setState(() {});
  }

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
    updateTime(minutesPause, minutesTraining, sets);
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
    updateTime(minutesPause, minutesTraining, sets);
    setState(() {});
  }

  Duration minutesTraining = const Duration(minutes: 1, seconds: 15);

  Duration minutesPause = const Duration(seconds: 15);
  Duration workoutTime = const Duration(seconds: 270);

  int sets = 3;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TotalTime(
          totalTime: workoutTime,
        ),
        WorkoutTimesContainer(
          update: update,
          setValue: setValue,
          minutesTraining: minutesTraining,
          minutesPause: minutesPause,
          sets: sets,
        ),
        TextButton(onPressed: () {}, child: const Text("Workout starten")),
        TextButton(onPressed: () {}, child: const Text("als Workout speichern"))
      ],
    );
  }
}
