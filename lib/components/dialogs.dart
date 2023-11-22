import 'package:flutter/material.dart';
import 'package:interval_timer/components/custom_textbox.dart';
import 'package:interval_timer/components/time_wheel.dart';
import 'package:interval_timer/components/workout_times_container.dart';
import 'package:hive/hive.dart';
import 'package:interval_timer/workout.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../const.dart';
import '../main.dart';

class Dialogs {
  static Widget buildAddWorkoutDialog(
      BuildContext context, Function setListState) {
    Duration workoutTime = const Duration(minutes: 4, seconds: 30);
    Duration minutesTraining = const Duration(minutes: 1, seconds: 15);
    Duration minutesPause = const Duration(seconds: 15);
    TextEditingController nameController = TextEditingController();
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
          decoration: BoxDecoration(
            color:
                MyApp.of(context).isDarkMode() ? darkNeutral0 : lightNeutral100,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppLocalizations.of(context)!.workouts_create,
                    style: TextStyle(
                      color: MyApp.of(context).isDarkMode()
                          ? darkNeutral900
                          : lightNeutral900,
                      fontSize: 24,
                    )),
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      TablerIcons.x,
                    )),
              ],
            ),
            CustomTextbox(
              label: AppLocalizations.of(context)!.workouts_name,
              nameController: nameController,
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
                  "${AppLocalizations.of(context)!.workouts_duration} ${workoutTime.toString().substring(2, 7)}"),
            ),
            const SizedBox(
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
                      name: nameController.text.trim(),
                      secondsTraining: minutesTraining.inSeconds,
                      secondsPause: minutesPause.inSeconds,
                      sets: sets));

                  Navigator.pop(context);
                  setListState();
                },
                child: Text(AppLocalizations.of(context)!.save_workout,
                    style: const TextStyle(fontSize: 16)),
              ),
            )
          ]));
    });
  }

  static Widget buildEditWorkoutDialog(BuildContext context, Workout workout,
      int? index, Function? setListState) {
    Duration minutesTraining = Duration(seconds: workout.secondsTraining);
    Duration minutesPause = Duration(seconds: workout.secondsPause);
    TextEditingController nameController =
        TextEditingController(text: workout.name);
    int sets = workout.sets;
    Duration workoutTime = Duration(
        seconds: (minutesTraining.inSeconds + minutesPause.inSeconds) * sets);

    return StatefulBuilder(builder: (context, setState) {
      void updateTime(Duration pause, Duration training, int sets) {
        workoutTime = (pause + training) * sets;
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
          decoration: BoxDecoration(
            color:
                MyApp.of(context).isDarkMode() ? darkNeutral0 : lightNeutral100,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context)!.workouts_edit,
                  style: TextStyle(
                    color: MyApp.of(context).isDarkMode()
                        ? darkNeutral900
                        : lightNeutral900,
                    fontSize: 24,
                  ),
                ),
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      TablerIcons.x,
                    )),
              ],
            ),
            CustomTextbox(
              label: AppLocalizations.of(context)!.workouts_name,
              nameController: nameController,
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
                  "${AppLocalizations.of(context)!.workouts_duration} ${workoutTime.toString().substring(2, 7)}"),
            ),
            const SizedBox(
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
                  index != null
                      ? Hive.box("workouts").putAt(
                          index,
                          Workout(
                              name: nameController.text.trim(),
                              secondsTraining: minutesTraining.inSeconds,
                              secondsPause: minutesPause.inSeconds,
                              sets: sets))
                      : Hive.box("workouts").add(Workout(
                          name: nameController.text.trim(),
                          secondsTraining: minutesTraining.inSeconds,
                          secondsPause: minutesPause.inSeconds,
                          sets: sets));
                  setListState != null ? setListState() : null;
                  Navigator.pop(context);
                },
                child: Text(AppLocalizations.of(context)!.save_workout,
                    style: const TextStyle(fontSize: 16)),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            index != null && setListState != null
                ? SizedBox(
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
                        setListState();
                        Navigator.pop(context);
                      },
                      child: Text(AppLocalizations.of(context)!.workouts_delete,
                          style: const TextStyle(fontSize: 16)),
                    ),
                  )
                : const SizedBox(),
          ]));
    });
  }

  static Widget buildSetTimesDialog(
      BuildContext context,
      String type,
      Duration minutes,
      Duration otherMinutes,
      int sets,
      Function(String type, int value, bool? minute) setValue) {
    late int workoutTime = (minutes.inSeconds + otherMinutes.inSeconds) * sets;

    return AlertDialog(
        backgroundColor:
            MyApp.of(context).isDarkMode() ? darkNeutral0 : lightNeutral100,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(type == "set"
            ? AppLocalizations.of(context)!.workout_sets
            : type == "pause"
                ? AppLocalizations.of(context)!.workout_pause_time
                : AppLocalizations.of(context)!.workout_training_time),
        content: StatefulBuilder(builder: (context, setState) {
          void updateTime(Duration minutes, Duration otherMinutes, int sets) {
            workoutTime = (minutes.inSeconds + otherMinutes.inSeconds) * sets;
          }

          setValueLocal(String type, int value, bool? minute) {
            if (type != "set") {
              if (minute!) {
                minutes = Duration(
                    minutes: value, seconds: minutes.inSeconds.remainder(60));
              } else {
                minutes = Duration(
                    minutes: minutes.inMinutes.remainder(60), seconds: value);
              }
            } else {
              sets = value;
            }
            updateTime(minutes, otherMinutes, sets);
            setState(() {});
          }

          return SizedBox(
            height: 327,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                type != "set"
                    ? Container(
                        decoration: BoxDecoration(
                          color: MyApp.of(context).isDarkMode()
                              ? darkNeutral100
                              : lightNeutral0,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TimeWheel(
                              type: type,
                              value: minutes.inMinutes.remainder(60),
                              setValue: setValue,
                              minute: true,
                              setValueLocal: setValueLocal,
                            ),
                            SizedBox(width: 18),
                            const Text(":", style: TextStyle(fontSize: 32)),
                            SizedBox(width: 18),
                            TimeWheel(
                              type: type,
                              value: minutes.inSeconds.remainder(60),
                              setValue: setValue,
                              minute: false,
                              setValueLocal: setValueLocal,
                            ),
                          ],
                        ),
                      )
                    : TimeWheel(
                        type: type,
                        value: sets,
                        setValue: setValue,
                        setValueLocal: setValueLocal,
                      ),
                const SizedBox(height: 18),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                      "${AppLocalizations.of(context)!.workouts_duration} ${(workoutTime / 60).floor()}:${(workoutTime % 60).toString().padLeft(2, '0')}"),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(type == "set"
                          ? AppLocalizations.of(context)!.workout_sets_save
                          : type == "pause"
                              ? AppLocalizations.of(context)!
                                  .workout_pause_time_save
                              : AppLocalizations.of(context)!
                                  .workout_training_time_save)),
                ),
              ],
            ),
          );
        }));
  }
}
