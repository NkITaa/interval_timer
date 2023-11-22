import 'package:flutter/material.dart';
import 'package:interval_timer/components/workout_times_container.dart';
import 'package:interval_timer/pages/jump_in/components/total_time.dart';
import 'package:interval_timer/pages/run/preparation.dart';
import 'package:interval_timer/workout.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../components/dialogs.dart';
import '../../const.dart';
import '../../main.dart';

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
      if (type == "training" && minutesTraining.inSeconds < 3585) {
        minutesTraining = minutesTraining + const Duration(seconds: 15);
      } else if (type == "pause" && minutesPause.inSeconds < 3585) {
        minutesPause = minutesPause + const Duration(seconds: 15);
      } else if (sets < 99 && type == "set") {
        sets = sets + 1;
      }
    } else {
      if (type == "training" && minutesTraining.inSeconds > 15) {
        minutesTraining = minutesTraining - const Duration(seconds: 15);
      } else if (type == "pause" && minutesPause.inSeconds > 15) {
        minutesPause = minutesPause - const Duration(seconds: 15);
      } else if (sets > 1 && type == "set") {
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
    return Container(
      margin: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: Column(
        children: [
          const SizedBox(
            height: 48,
          ),
          TotalTime(
            totalTime: workoutTime,
          ),
          const SizedBox(
            height: 48,
          ),
          WorkoutTimesContainer(
            update: update,
            setValue: setValue,
            minutesTraining: minutesTraining,
            minutesPause: minutesPause,
            sets: sets,
          ),
          const SizedBox(
            height: 24,
          ),
          SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => Preparation(
                              time: [
                                minutesTraining.inSeconds,
                                minutesPause.inSeconds
                              ],
                              sets: sets,
                              currentSet: 1,
                              indexTime: 0,
                            )));
                  },
                  child: Text(AppLocalizations.of(context)!.start_workout))),
          const SizedBox(
            height: 12,
          ),
          SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MyApp.of(context).isDarkMode()
                        ? darkNeutral100
                        : lightNeutral0,
                  ),
                  onPressed: () {
                    showModalBottomSheet(
                      isScrollControlled: true,
                      enableDrag: false,
                      context: context,
                      builder: (BuildContext context) =>
                          Dialogs.buildEditWorkoutDialog(
                              context,
                              Workout(
                                  secondsTraining: minutesTraining.inSeconds,
                                  secondsPause: minutesPause.inSeconds,
                                  sets: sets,
                                  name: ""),
                              null,
                              null),
                    );
                  },
                  child: Text(
                    AppLocalizations.of(context)!.jump_in_save_workout,
                    style: TextStyle(
                      color: MyApp.of(context).isDarkMode()
                          ? darkNeutral900
                          : lightNeutral900,
                    ),
                  ))),
        ],
      ),
    );
  }
}
