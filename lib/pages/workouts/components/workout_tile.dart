import 'package:flutter/material.dart';
import 'package:interval_timer/const.dart';
import 'package:interval_timer/workout.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../components/dialogs.dart';
import '../../../main.dart';
import '../../run/preparation.dart';

class WorkoutTile extends StatelessWidget {
  final Workout workout;
  final int index;
  final Function setListState;

  const WorkoutTile(
      {super.key,
      required this.workout,
      required this.index,
      required this.setListState});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: MyApp.of(context).isDarkMode() ? darkNeutral50 : lightNeutral0,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                workout.name.toString(),
                style: TextStyle(
                  color: MyApp.of(context).isDarkMode()
                      ? darkNeutral900
                      : lightNeutral850,
                ),
              ),
              IconButton(
                icon: Icon(
                  TablerIcons.dots,
                  color: MyApp.of(context).isDarkMode()
                      ? darkNeutral900
                      : lightNeutral850,
                ),
                onPressed: () {
                  showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (BuildContext context) =>
                        Dialogs.buildEditWorkoutDialog(
                            context, workout, index, setListState),
                  );
                },
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 14.0,
                    color: MyApp.of(context).isDarkMode()
                        ? darkNeutral900
                        : lightNeutral850,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                        text:
                            "${(workout.secondsTraining / 60).floor()}:${(workout.secondsTraining % 60).toString().padLeft(2, '0')} ",
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: AppLocalizations.of(context)!.training),
                  ],
                ),
              ),
              const SizedBox(width: 40),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 14.0,
                    color: MyApp.of(context).isDarkMode()
                        ? darkNeutral900
                        : lightNeutral850,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                        text:
                            "${(workout.secondsPause / 60).floor()}:${(workout.secondsPause % 60).toString().padLeft(2, '0')} ",
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: AppLocalizations.of(context)!.pause),
                  ],
                ),
              ),
              const SizedBox(width: 40),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 14.0,
                    color: MyApp.of(context).isDarkMode()
                        ? darkNeutral900
                        : lightNeutral850,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                        text: workout.sets.toString() + ' ',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: AppLocalizations.of(context)!.sets),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => Preparation(
                            time: [
                              workout.secondsTraining,
                              workout.secondsPause
                            ],
                            sets: workout.sets,
                            currentSet: 1,
                            indexTime: 0,
                          )));
                },
                style: ElevatedButton.styleFrom(
                  maximumSize: const Size(300, 50),
                ),
                child: Text(AppLocalizations.of(context)!.start_workout)),
          )
        ],
      ),
    );
  }
}
