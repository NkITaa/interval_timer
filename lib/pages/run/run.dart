import 'dart:async';

import 'package:flutter/material.dart';
import 'package:interval_timer/const.dart';
import 'package:interval_timer/pages/run/preparation.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:hive/hive.dart';

import '../../components/dialogs.dart';
import '../home.dart';
import 'circular_countdown/circular_countdown.dart';
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
  final player = AudioPlayer();
  String sound = Hive.box("settings").get("sound");
  late Timer timer = Timer.periodic(const Duration(seconds: 1), (timer) {
    if (counter > 0 && !controller.isPaused) {
      setState(() {
        counter--;
      });
    }
    if (counter == 3 && sound != "off") {
      playAudio();
    }
  });

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
    player.dispose();
    if (widget.indexTime == 1 && widget.sets == widget.currentSet) {
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

  playAudio() async {
    await player.play(AssetSource(sound));
  }

  @override
  void initState() {
    super.initState();
    timer;
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
              color: lightNeutral50,
              onPressed: () {
                controller.pause();
                player.pause();
                showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        Dialogs.buildExitDialog(context, controller, player));
              },
              icon: const Icon(TablerIcons.x)),
          title: Text(
            AppLocalizations.of(context)!.run_set_from_one +
                widget.currentSet.toString() +
                AppLocalizations.of(context)!.run_set_from_two +
                widget.sets.toString(),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: lightNeutral50,
            ),
          ),
        ),
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: InkWell(
            onTap: () {
              if (controller.isPaused) {
                controller.resume();
              } else {
                controller.pause();
              }
              setState(() {});
            },
            child: Padding(
              padding: const EdgeInsets.only(bottom: 82.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
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
                        return Function.apply(
                            defaultFormatterFunction, [duration]);
                      }
                    },
                    subText: Text(
                      controller.isPaused
                          ? AppLocalizations.of(context)!.paused
                          : widget.indexTime == 0
                              ? AppLocalizations.of(context)!.training
                              : AppLocalizations.of(context)!.pause,
                      style:
                          const TextStyle(fontSize: 30, color: lightNeutral50),
                    ),
                    textStyle: const TextStyle(
                        fontSize: 80,
                        color: lightNeutral50,
                        fontWeight: FontWeight.bold),
                  ),
                  Column(
                    children: [
                      Text(
                          "${((remainingPlus + counter) / 60).floor()}:${((remainingPlus + counter) % 60).toString().padLeft(2, '0')}",
                          style: const TextStyle(
                              fontSize: 20,
                              color: lightNeutral50,
                              fontWeight: FontWeight.bold)),
                      Text(AppLocalizations.of(context)!.run_remaining,
                          style: const TextStyle(
                              fontSize: 20,
                              color: lightNeutral50,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                          color: lightNeutral50,
                          onPressed: () {
                            back();
                          },
                          iconSize: 50,
                          icon: const Icon(
                            TablerIcons.chevron_left,
                          )),
                      const SizedBox(
                        width: 20,
                      ),
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        child: IconButton(
                            iconSize: 60,
                            color: controller.isPaused
                                ? const Color(0xff7C7C7C)
                                : widget.indexTime == 0
                                    ? const Color(0xffFA5F54)
                                    : const Color(0xff7189E1),
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
                      const SizedBox(
                        width: 20,
                      ),
                      IconButton(
                          color: lightNeutral50,
                          onPressed: () {
                            next();
                          },
                          iconSize: 50,
                          icon: const Icon(
                            TablerIcons.chevron_right,
                          )),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
