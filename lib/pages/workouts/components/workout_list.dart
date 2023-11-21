import 'package:flutter/material.dart';
import 'package:interval_timer/pages/workouts/components/workout_tile.dart';
import 'package:hive/hive.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
              SizedBox(
                height: 100,
              ),
              Text(
                AppLocalizations.of(context)!.workouts_search_no_results_one,
                style: TextStyle(fontSize: 24),
              ),
              Text(
                AppLocalizations.of(context)!.workouts_search_no_results_two,
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(
                height: 100,
              ),
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
