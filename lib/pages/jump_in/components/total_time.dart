import 'package:flutter/material.dart';

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
          const Text('Gesamtzeit', style: TextStyle(fontSize: 20)),
          Text(
              "${(totalTime.inSeconds / 60).floor()}:${(totalTime.inSeconds % 60).toString().padLeft(2, '0')}",
              style: const TextStyle(fontSize: 50)),
        ],
      ),
    );
  }
}