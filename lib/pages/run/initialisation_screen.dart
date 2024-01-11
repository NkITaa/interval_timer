import 'package:flutter/material.dart';
import 'package:interval_timer/pages/run/preparation.dart';

import 'AudioHandler.dart';

class InitialisationScreen extends StatelessWidget {
  final List<int> time;
  final int sets;
  final int currentSet;
  final int indexTime;
  const InitialisationScreen(
      {super.key,
      required this.time,
      required this.sets,
      required this.currentSet,
      required this.indexTime});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: initialize(time, sets),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            AudioReturn data = snapshot.data!;

            int totalDuration = 0;
            for (int i = 0; i < sets * 2 - 1; i++) {
              totalDuration += time[i % 2];
            }

            if (data.ffmpegOutput[0] == "0" || data.ffmpegOutput[1] == "0") {
              return Preparation(
                  totalDuration: totalDuration,
                  time: time,
                  sets: sets,
                  currentSet: currentSet,
                  indexTime: indexTime,
                  player: data.player);
            } else {
              return const Center(
                child: Text("Not Enough Space"),
              );
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
