import 'package:flutter/material.dart';

class WorkoutSearchBar extends StatelessWidget {
  const WorkoutSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, bottom: 32.0),
      child: SearchAnchor(
        builder: (BuildContext context, SearchController controller) {
          return const SearchBar();
        },
        suggestionsBuilder:
            (BuildContext context, SearchController controller) {
          return List<ListTile>.generate(5, (int index) {
            final String item = 'item $index';
            return ListTile(
              title: Text(item),
              onTap: () {},
            );
          });
        },
      ),
    );
  }
}
