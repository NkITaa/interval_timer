import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:interval_timer/pages/workouts/components/workout_list.dart';

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
        searchController: controller,
        viewHintText: 'Search',
        builder: (context, controller) {
          return SearchBar(
            hintText: 'Search',
            controller: controller,
            trailing: [
              IconButton(
                  onPressed: () {
                    controller.clear();
                  },
                  icon: const Icon(Icons.close))
            ],
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
            results.isEmpty
                ? const Center(
                    child: Text(
                      'No results found !',
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 24.0),
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
