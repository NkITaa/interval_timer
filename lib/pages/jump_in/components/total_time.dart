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
          Text('Gesamtzeit', style: heading1(context)),
          Text(
              "${(totalTime.inSeconds / 60).floor()}:${(totalTime.inSeconds % 60).toString().padLeft(2, '0')}",
              style: display1(context).copyWith(
                color: MyApp.of(context).isDarkMode()
                    ? darkNeutral900
                    : lightNeutral900,
              )),
        ],
      ),
    );
  }
}
