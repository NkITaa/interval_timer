import 'package:flutter/material.dart';
import 'package:interval_timer/const.dart';
import 'package:interval_timer/pages/workouts/components/workout_tile.dart';
import 'package:hive/hive.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

import '../../../components/dialogs.dart';
import '../../../main.dart';

class WorkoutList extends StatelessWidget {
  final Function setListState;
  final List<dynamic>? results;
  const WorkoutList({
    super.key,
    required this.setListState,
    this.results,
  });

  @override
  Widget build(BuildContext context) {
    return Hive.box("workouts").values.isEmpty ||
            results != null && results!.isEmpty
        ? Column(
            children: [
              const SizedBox(
                width: 200,
                child: Image(
                  image: AssetImage('assets/images/no_workout.png'),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Text(AppLocalizations.of(context)!.workouts_search_no_results_one,
                  style: body1Bold(context)),
              Padding(
                padding: const EdgeInsets.only(
                  left: 24,
                  right: 24,
                  top: 8,
                ),
                child: Text(
                    textAlign: TextAlign.center,
                    AppLocalizations.of(context)!
                        .workouts_search_no_results_two,
                    style: body1(context)),
              ),
              const SizedBox(
                height: 24,
              ),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet(
                        isScrollControlled: true,
                        enableDrag: false,
                        context: context,
                        builder: (BuildContext context) =>
                            Dialogs.buildAddWorkoutDialog(
                                context, setListState),
                      );
                    },
                    child: Text(AppLocalizations.of(context)!.workouts_create,
                        style: body1Bold(context).copyWith(
                            color: MyApp.of(context).isDarkMode()
                                ? darkNeutral50
                                : lightNeutral50))),
              )
            ],
          )
        : ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) => const Divider(
                  color: Colors.transparent,
                  height: 12,
                ),
            itemCount: results != null
                ? results!.length
                : Hive.box("workouts").values.length,
            itemBuilder: (context, index) {
              return WorkoutTile(
                setListState: setListState,
                index: index,
                workout: results != null
                    ? results![index]
                    : Hive.box("workouts").getAt(index),
              );
            });
  }
}
