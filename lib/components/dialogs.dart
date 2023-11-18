import 'package:flutter/material.dart';
import 'package:interval_timer/components/custom_textbox.dart';
import 'package:interval_timer/components/time_wheel.dart';
import 'package:interval_timer/components/workout_times_container.dart';
import 'package:hive/hive.dart';
import 'package:interval_timer/workout.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

import '../const.dart';

class Dialogs {
  static Widget buildAddWorkoutDialog(BuildContext context) {
    Duration workoutTime = const Duration(minutes: 4, seconds: 30);
    Duration minutesTraining = const Duration(minutes: 1, seconds: 15);
    Duration minutesPause = const Duration(seconds: 15);
    int sets = 3;

    return StatefulBuilder(builder: (context, setState) {
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
                minutes: value,
                seconds: minutesTraining.inSeconds.remainder(60));
          } else {
            minutesTraining = Duration(
                minutes: minutesTraining.inMinutes.remainder(60),
                seconds: value);
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

      return Container(
          padding: const EdgeInsets.all(24),
          height: 566,
          decoration: const BoxDecoration(
            color: lightNeutral50,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Workout Erstellen',
                    style: Theme.of(context).textTheme.headline6),
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      TablerIcons.x,
                    )),
              ],
            ),
            const CustomTextbox(
              label: "Bezeichnung",
            ),
            WorkoutTimesContainer(
              update: update,
              setValue: setValue,
              minutesTraining: minutesTraining,
              minutesPause: minutesPause,
              sets: sets,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                  "Workoutdauer ${workoutTime.toString().substring(2, 7)}"),
            ),
            SizedBox(
              height: 8,
            ),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Hive.box("workouts").add(Workout(
                      name: "Test",
                      secondsTraining: minutesTraining.inSeconds,
                      secondsPause: minutesPause.inSeconds,
                      sets: sets));
                },
                child: const Text('Workout Speichern',
                    style: TextStyle(fontSize: 16)),
              ),
            )
          ]));
    });
  }

  static Widget buildEditWorkoutDialog(
      BuildContext context, Workout workout, int index) {
    Duration workoutTime = Duration(
        seconds:
            workout.secondsTraining * workout.secondsTraining * workout.sets);
    Duration minutesTraining = Duration(seconds: workout.secondsTraining);
    Duration minutesPause = Duration(seconds: workout.secondsPause);
    int sets = workout.sets;

    return StatefulBuilder(builder: (context, setState) {
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
                minutes: value,
                seconds: minutesTraining.inSeconds.remainder(60));
          } else {
            minutesTraining = Duration(
                minutes: minutesTraining.inMinutes.remainder(60),
                seconds: value);
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

      return Container(
          padding: const EdgeInsets.all(24),
          height: 608,
          decoration: const BoxDecoration(
            color: lightNeutral50,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Workout Erstellen',
                    style: Theme.of(context).textTheme.headline6),
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      TablerIcons.x,
                    )),
              ],
            ),
            const CustomTextbox(
              label: "Bezeichnung",
            ),
            WorkoutTimesContainer(
              update: update,
              setValue: setValue,
              minutesTraining: minutesTraining,
              minutesPause: minutesPause,
              sets: sets,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                  "Workoutdauer ${workoutTime.toString().substring(2, 7)}"),
            ),
            SizedBox(
              height: 12,
            ),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Hive.box("workouts").add(Workout(
                      name: "Test",
                      secondsTraining: minutesTraining.inSeconds,
                      secondsPause: minutesPause.inSeconds,
                      sets: sets));
                },
                child: const Text('Workout Speichern',
                    style: TextStyle(fontSize: 16)),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Hive.box("workouts").deleteAt(index);
                },
                child: const Text('Löschen', style: TextStyle(fontSize: 16)),
              ),
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