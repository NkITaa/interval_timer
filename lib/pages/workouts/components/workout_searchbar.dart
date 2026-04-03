import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:interval_timer/pages/workouts/components/workout_list.dart';
import 'package:interval_timer/l10n/app_localizations.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

import '../../../const.dart';


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
        dividerColor: context.colors.neutral200,
        viewLeading: IconButton(
          icon: Icon(
            TablerIcons.chevron_left,
            color: context.colors.iconPrimary,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        viewSurfaceTintColor: Colors.transparent,
        searchController: controller,
        headerHintStyle: body2(context).copyWith(
          color: context.colors.neutral700,
        ),
        headerTextStyle: body2(context).copyWith(
          color: context.colors.neutral850,
        ),
        viewHintText: AppLocalizations.of(context)!.workouts_search,
        viewBackgroundColor: context.colors.scaffoldSurface,
        builder: (context, controller) {
          return SearchBar(
            shadowColor:
                WidgetStateColor.resolveWith((states) => Colors.transparent),
            shape: WidgetStateProperty.resolveWith<OutlinedBorder?>(
              (Set<WidgetState> states) {
                return RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                );
              },
            ),
            leading: Padding(
              padding: const EdgeInsets.only(left: 4.0),
              child: Icon(
                Icons.search,
                color: context.colors.iconPrimary,
              ),
            ),
            hintText: AppLocalizations.of(context)!.workouts_search,
            hintStyle: WidgetStateProperty.all<TextStyle>(
              body2(context).copyWith(
                  color: context.colors.neutral700),
            ),
            textStyle: WidgetStateProperty.all<TextStyle>(
              body2(context).copyWith(
                  color: context.colors.neutral850),
            ),
            backgroundColor: WidgetStateProperty.all<Color>(
                context.colors.cardSurface),
            surfaceTintColor:
                WidgetStateProperty.all<Color>(Colors.transparent),
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
            InkWell(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 32.0, horizontal: 24.0),
                child: WorkoutList(
                  setListState: setListState,
                  results: results,
                ),
              ),
            )
          ];
        },
      ),
    );
  }
}
