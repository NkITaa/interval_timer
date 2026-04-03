import 'package:flutter/material.dart';
import 'package:interval_timer/const.dart';
import 'package:interval_timer/pages/run/initialisation_screen.dart';
import 'package:interval_timer/workout.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:interval_timer/l10n/app_localizations.dart';

import '../../../components/dialogs.dart';
import 'package:interval_timer/services/haptic_service.dart';


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
    return InkWell(
      onTap: () {
        HapticService.selection();
        TextEditingController nameController =
            TextEditingController(text: workout.name);
        showModalBottomSheet(
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          enableDrag: false,
          context: context,
          builder: (BuildContext context) => Dialogs.buildEditWorkoutDialog(
              nameController, context, workout, index, setListState),
        );
      },
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.only(left: 12.0, right: 12, bottom: 12),
        decoration: BoxDecoration(
          color: context.colors.tileSurface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(workout.name.toString(), style: body1Bold(context)),
                IconButton(
                  padding: const EdgeInsets.all(0),
                  icon: Icon(
                    TablerIcons.dots,
                    color: context.colors.bodyText,
                  ),
                  onPressed: () {
                    HapticService.selection();
                    TextEditingController nameController =
                        TextEditingController(text: workout.name);
                    showModalBottomSheet(
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                      enableDrag: false,
                      context: context,
                      builder: (BuildContext context) =>
                          Dialogs.buildEditWorkoutDialog(nameController,
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
                    children: <TextSpan>[
                      TextSpan(
                          text:
                              "${(workout.secondsTraining / 60).floor()}:${(workout.secondsTraining % 60).toString().padLeft(2, '0')} ",
                          style: body2Bold(context)),
                      TextSpan(
                          text: AppLocalizations.of(context)!.training,
                          style: body2(context)),
                    ],
                  ),
                ),
                const SizedBox(width: 40),
                RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                          text:
                              "${(workout.secondsPause / 60).floor()}:${(workout.secondsPause % 60).toString().padLeft(2, '0')} ",
                          style: body2Bold(context)),
                      TextSpan(
                          text: AppLocalizations.of(context)!.pause,
                          style: body2(context)),
                    ],
                  ),
                ),
                const SizedBox(width: 40),
                RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                          text: '${workout.sets} ', style: body2Bold(context)),
                      TextSpan(
                          text: AppLocalizations.of(context)!.sets,
                          style: body2(context)),
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
                    HapticService.medium();
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => InitialisationScreen(
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
                  child: Text(AppLocalizations.of(context)!.start_workout,
                      style: body1Bold(context).copyWith(
                          color: context.colors.neutral50))),
            )
          ],
        ),
      ),
    );
  }
}
