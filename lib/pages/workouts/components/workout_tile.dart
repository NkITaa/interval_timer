import 'package:flutter/material.dart';
import 'package:interval_timer/workout.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

import '../../../components/dialogs.dart';

class WorkoutTile extends StatelessWidget {
  final Workout workout;
  final int index;
  final Function setListState;

  const WorkoutTile(
      {super.key,
      required this.workout,
      required this.index,
      required this.setListState});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(workout.name.toString()),
              IconButton(
                icon: const Icon(TablerIcons.dots),
                onPressed: () {
                  showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (BuildContext context) =>
                        Dialogs.buildEditWorkoutDialog(
                            context, workout, index, setListState),
                  );
                },
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                        text:
                            (workout.secondsTraining / 60).floor().toString() +
                                ":" +
                                (workout.secondsTraining % 60)
                                    .toString()
                                    .padLeft(2, '0'),
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    const TextSpan(text: ' Training'),
                  ],
                ),
              ),
              const SizedBox(width: 40),
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                        text: (workout.secondsPause / 60).floor().toString() +
                            ":" +
                            (workout.secondsPause % 60)
                                .toString()
                                .padLeft(2, '0'),
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    const TextSpan(text: ' Pause'),
                  ],
                ),
              ),
              const SizedBox(width: 40),
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                        text: workout.sets.toString(),
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    const TextSpan(text: ' Sets'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  maximumSize: const Size(300, 50),
                ),
                child: const Text("do asdfasd")),
          )
        ],
      ),
    );
  }
}
