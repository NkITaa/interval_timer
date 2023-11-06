import 'package:flutter/material.dart';

class SettingsBlock extends StatelessWidget {
  final List<Widget> tiles;
  final String title;
  const SettingsBlock({super.key, required this.tiles, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(top: 24.0, bottom: 8.0),
          child: Row(
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.headline6,
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(16),
          ),
          padding: EdgeInsets.only(left: 24.0, right: 24),
          child: ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return tiles[index];
            },
            itemCount: tiles.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
          ),
        ),
      ],
    );
  }
}
