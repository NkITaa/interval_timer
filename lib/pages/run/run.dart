import 'package:flutter/material.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:interval_timer/pages/run/preparation.dart';

import 'congrats.dart';

class Run extends StatefulWidget {
  final List<int> time;
  final int sets;
  final int currentSet;
  final int indexTime;

  const Run({
    super.key,
    required this.time,
    required this.sets,
    required this.currentSet,
    required this.indexTime,
  });

  @override
  State<Run> createState() => _RunState();
}

class _RunState extends State<Run> {
  next() {
    if (widget.indexTime == 0 && widget.sets == widget.currentSet) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const Congrats()));
    } else {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Run(
                time: widget.time,
                sets: widget.sets,
                currentSet: widget.indexTime == 1
                    ? widget.currentSet + 1
                    : widget.currentSet,
                indexTime: widget.indexTime == 1 ? 0 : 1,
              )));
    }
  }

  back() {
    if (widget.indexTime == 0 && widget.currentSet == 1) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Preparation(
              time: widget.time,
              sets: widget.sets,
              currentSet: 1,
              indexTime: 0)));
    } else {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Run(
                time: widget.time,
                sets: widget.sets,
                currentSet: widget.indexTime == 0
                    ? widget.currentSet - 1
                    : widget.currentSet,
                indexTime: widget.indexTime == 0 ? 1 : 0,
              )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 48,
        ),
        CircularCountDownTimer(
          duration: widget.time[widget.indexTime],
          initialDuration: 0,
          onComplete: () {
            next();
          },
          width: MediaQuery.of(context).size.width / 2,
          height: MediaQuery.of(context).size.height / 2,
          ringColor: Colors.red,
          fillColor: Colors.yellow,
        ),
        TextButton(
            onPressed: () {
              next();
            },
            child: const Text('Next')),
        TextButton(
            onPressed: () {
              back();
            },
            child: const Text('Back')),
        Text(widget.currentSet.toString()),
        Text(widget.indexTime.toString()),
        Text(widget.sets.toString()),
      ],
    );
  }
}
