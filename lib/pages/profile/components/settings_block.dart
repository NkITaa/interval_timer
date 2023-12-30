import 'package:flutter/material.dart';

import '../../../const.dart';
import '../../../main.dart';

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
              Text(title, style: body1(context)),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            boxShadow: [
              MyApp.of(context).isDarkMode()
                  ? const BoxShadow(
                      color: Colors.transparent,
                      spreadRadius: 0,
                      blurRadius: 0,
                      offset: Offset(0, 4), // changes position of shadow
                    )
                  : BoxShadow(
                      color: MyApp.of(context).isDarkMode()
                          ? darkNeutral900.withOpacity(0.2)
                          : lightNeutral850.withOpacity(0.2),
                      spreadRadius: 0,
                      blurRadius: 16,
                      offset: const Offset(0, 1), // changes position of shadow
                    ),
            ],
            color:
                MyApp.of(context).isDarkMode() ? darkNeutral50 : lightNeutral50,
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.only(left: 24.0, right: 24),
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
