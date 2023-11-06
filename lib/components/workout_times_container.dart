import 'package:flutter/material.dart';

import 'increment_decrement_button.dart';

class WorkoutTimesContainer extends StatelessWidget {
  const WorkoutTimesContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        children: [
          IncrementDecrementButton(
            type: "training",
          ),
          IncrementDecrementButton(
            type: "pause",
          ),
          IncrementDecrementButton(
            type: "set",
          ),
        ],
      ),
    );
  }
}
