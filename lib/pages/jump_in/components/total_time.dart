import 'package:flutter/material.dart';

import '../../../const.dart';
import '../../../main.dart';

class TotalTime extends StatelessWidget {
  final Duration totalTime;
  const TotalTime({super.key, required this.totalTime});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 80),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text('Gesamtzeit',
              style: TextStyle(
                fontSize: 26,
                color: MyApp.of(context).isDarkMode()
                    ? darkNeutral900
                    : lightNeutral900,
              )),
          Text(
              "${(totalTime.inSeconds / 60).floor()}:${(totalTime.inSeconds % 60).toString().padLeft(2, '0')}",
              style: TextStyle(
                fontSize: 100,
                fontWeight: FontWeight.bold,
                color: MyApp.of(context).isDarkMode()
                    ? darkNeutral900
                    : lightNeutral900,
              )),
        ],
      ),
    );
  }
}
