import 'dart:async';

import 'package:flutter/material.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:interval_timer/pages/run/preparation.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../home.dart';
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

  late int counter = widget.time[widget.indexTime] - 1;
  late int remainingPlus = widget.indexTime == 0
      ? (((widget.time[0] + widget.time[1]) *
              (widget.sets - widget.currentSet + 1)) -
          widget.time[0])
      : (((widget.time[0] + widget.time[1]) *
              (widget.sets - widget.currentSet + 1)) -
          widget.time[0] -
          widget.time[1]);

  next() {
    if (widget.indexTime == 1 && widget.sets == widget.currentSet) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => Congrats()));
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
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (counter > 0 && !controller.isPaused) {
        setState(() {
          counter--;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
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
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const Home(screenIndex: 1)));
              },
              icon: const Icon(TablerIcons.x)),
          title: Text(AppLocalizations.of(context)!.run_set_from_one +
              widget.currentSet.toString() +
              AppLocalizations.of(context)!.run_set_from_two +
              widget.sets.toString()),
        ),
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Stack(
                children: [
                  SizedBox(
                    width: 320,
                    height: 300,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 180,
                        ),
                        Text(
                          controller.isPaused
                              ? AppLocalizations.of(context)!.paused
                              : widget.indexTime == 0
                                  ? AppLocalizations.of(context)!.training
                                  : AppLocalizations.of(context)!.pause,
                          style: const TextStyle(
                              fontSize: 30, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  CircularCountDownTimer(
                    controller: controller,
                    isReverse: true,
                    duration: widget.time[widget.indexTime],
                    initialDuration: 0,
                    onComplete: () {
                      next();
                    },
                    width: 320,
                    height: 300,
                    strokeCap: StrokeCap.round,
                    ringColor: Colors.white.withOpacity(0.5),
                    fillColor: Colors.white,
                    strokeWidth: 16.0,
                    timeFormatterFunction:
                        (defaultFormatterFunction, duration) {
                      if (duration.inSeconds < 60) {
                        return "0:${duration.inSeconds.toString().padLeft(2, '0')}";
                      } else {
                        // other durations by it's default format
                        return Function.apply(
                            defaultFormatterFunction, [duration]);
                      }
                    },
                    textStyle: const TextStyle(
                        fontSize: 33.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                      "${((remainingPlus + counter) / 60).floor()}:${((remainingPlus + counter) % 60).toString().padLeft(2, '0')}"),
                  Text(AppLocalizations.of(context)!.run_remaining),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: () {
                        back();
                      },
                      iconSize: 50,
                      icon: Icon(
                        TablerIcons.chevron_left,
                      )),
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: IconButton(
                        iconSize: 35,
                        color: Colors.grey,
                        onPressed: () {
                          if (controller.isPaused) {
                            controller.resume();
                          } else {
                            controller.pause();
                          }
                          setState(() {});
                        },
                        icon: Icon(
                          controller.isPaused
                              ? TablerIcons.player_play_filled
                              : TablerIcons.player_pause_filled,
                        )),
                  ),
                  IconButton(
                      onPressed: () {
                        next();
                      },
                      iconSize: 50,
                      icon: Icon(
                        TablerIcons.chevron_right,
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
