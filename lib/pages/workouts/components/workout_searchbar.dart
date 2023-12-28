import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:interval_timer/pages/workouts/components/workout_list.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

import '../../../const.dart';
import '../../../main.dart';

class WorkoutSearchBar extends StatefulWidget {
  const WorkoutSearchBar({
    super.key,
  });

  @override
  State<WorkoutSearchBar> createState() => _WorkoutSearchBarState();
}

class _WorkoutSearchBarState extends State<WorkoutSearchBar> {
  final SearchController controller = SearchController();

  setListState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, bottom: 32.0),
      child: SearchAnchor(
        viewLeading: IconButton(
          icon: Icon(
            TablerIcons.chevron_left, // Replace with the icon you want to use
            color: MyApp.of(context).isDarkMode()
                ? darkNeutral850
                : lightNeutral700,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        viewSurfaceTintColor: Colors.transparent,
        searchController: controller,
        headerHintStyle: body2(context).copyWith(
          color:
              MyApp.of(context).isDarkMode() ? darkNeutral700 : lightNeutral700,
        ),
        viewHintText: AppLocalizations.of(context)!.workouts_search,
        viewBackgroundColor:
            MyApp.of(context).isDarkMode() ? darkNeutral0 : lightNeutral100,
        builder: (context, controller) {
          return SearchBar(
            shadowColor:
                MaterialStateColor.resolveWith((states) => Colors.transparent),
            shape: MaterialStateProperty.resolveWith<OutlinedBorder?>(
              (Set<MaterialState> states) {
                return RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                );
              },
            ),
            leading: Icon(
              Icons.search,
              color: MyApp.of(context).isDarkMode()
                  ? darkNeutral850
                  : lightNeutral700,
            ),
            hintText: AppLocalizations.of(context)!.workouts_search,
            hintStyle: MaterialStateProperty.all<TextStyle>(
              body2(context).copyWith(
                  color: MyApp.of(context).isDarkMode()
                      ? darkNeutral700
                      : lightNeutral700),
            ),
            backgroundColor: MaterialStateProperty.all<Color>(
                MyApp.of(context).isDarkMode()
                    ? darkNeutral100
                    : lightNeutral0),
            surfaceTintColor:
                MaterialStateProperty.all<Color>(Colors.transparent),
            controller: controller,
            onTap: () {
              controller.openView();
            },
          );
        },
        suggestionsBuilder: (context, controller) {
          var results = controller.text.trim().isEmpty
              ? Hive.box('workouts').values.toList() // whole list
              : Hive.box('workouts')
                  .values
                  .where((c) => c.name
                      .toLowerCase()
                      .contains(controller.text.trim().toLowerCase()))
                  .toList();
          return [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
              child: WorkoutList(
                setListState: setListState,
                results: results,
              ),
            )
          ];
        },
      ),
    );
  }
}
