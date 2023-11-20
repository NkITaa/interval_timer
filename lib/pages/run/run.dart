import 'package:flutter/material.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:interval_timer/pages/run/preparation.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

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
  final CountDownController controller = CountDownController();

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
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: controller.isPaused
              ? [const Color(0xffA3A3A3), const Color(0xff7C7C7C)]
              : widget.indexTime == 0
                  ? [const Color(0xffF01D52), const Color(0xffFA5F54)]
                  : [const Color(0xff1373C8), const Color(0xff7189E1)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              icon: const Icon(TablerIcons.x)),
          title: Text("Satz: " +
              widget.currentSet.toString() +
              ' von ' +
              widget.sets.toString()),
        ),
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [
              const SizedBox(
                height: 48,
              ),
              CircularCountDownTimer(
                controller: controller,
                isReverse: true,
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
              TextButton(
                  onPressed: () {
                    if (controller.isPaused) {
                      controller.resume();
                    } else {
                      controller.pause();
                    }
                    setState(() {});
                  },
                  child: Text(controller.isPaused ? "Resume" : 'Pause')),
              Text(widget.indexTime.toString()),
            ],
          ),
        ),
      ),
    );
  }
}
