import 'dart:async';
import 'dart:isolate';
import 'package:flutter/material.dart';
import 'package:interval_timer/const.dart';
import 'package:interval_timer/main.dart';
import 'package:interval_timer/pages/run/preparation.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:hive/hive.dart';
import '../../components/dialogs.dart';
import 'circular_countdown/circular_countdown.dart';
import 'congrats.dart';

class Run extends StatefulWidget {
  final List<int> time;
  final int sets;
  final int currentSet;
  final int indexTime;
  final int duration;

  const Run({
    super.key,
    required this.time,
    required this.sets,
    required this.currentSet,
    required this.indexTime,
    required this.duration,
  });

  @override
  State<Run> createState() => _RunState();
}

class _RunState extends State<Run> with WidgetsBindingObserver {
  final CountDownController controller = CountDownController();
  final player = AudioPlayer();
  String sound = Hive.box("settings").get("sound");

  late int duration = widget.duration;
  late int currentSet = widget.currentSet;
  late int indexTime = widget.indexTime;

  late Timer timer = Timer.periodic(const Duration(seconds: 1), (timer) {
    duration++;
    if (counter > 0 && !controller.isPaused) {
      counter--;
      setState(() {});
    }
    if (counter == 0) {
      next();
    }
    if (counter == 3) {
      player.play(AssetSource(sound));
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
    if (indexTime == 0 && widget.sets == currentSet) {
      timer.cancel();
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Congrats(
                duration: duration,
              )));
    } else {
      if (indexTime == 1) {
        ++currentSet;
      }
      indexTime = indexTime == 1 ? 0 : 1;
      counter = widget.time[indexTime] - 1;
      controller.restart(duration: counter);
      remainingPlus = indexTime == 0
          ? (((widget.time[0] + widget.time[1]) *
                  (widget.sets - currentSet + 1)) -
              widget.time[0])
          : (((widget.time[0] + widget.time[1]) *
                  (widget.sets - currentSet + 1)) -
              widget.time[0] -
              widget.time[1]);
      setState(() {});
    }
  }

  back() {
    if (indexTime == 0 && currentSet == 1) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Preparation(
              time: widget.time,
              sets: widget.sets,
              currentSet: 1,
              indexTime: 0)));
    } else {
      if (indexTime == 0) {
        --currentSet;
      }
      indexTime = indexTime == 0 ? 1 : 0;
      counter = widget.time[indexTime] - 1;
      controller.restart(duration: counter);
      remainingPlus = indexTime == 0
          ? (((widget.time[0] + widget.time[1]) *
                  (widget.sets - currentSet + 1)) -
              widget.time[0])
          : (((widget.time[0] + widget.time[1]) *
                  (widget.sets - currentSet + 1)) -
              widget.time[0] -
              widget.time[1]);
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    timer;
  }

  @override
  dispose() {
    timer.cancel();
    super.dispose();
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
              : indexTime == 0
                  ? [const Color(0xffF01D52), const Color(0xffFA5F54)]
                  : [const Color(0xff1373C8), const Color(0xff7189E1)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: IconButton(
              color: const Color(0xffFADCE3),
              onPressed: () {
                controller.pause();
                setState(() {});
                showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        Dialogs.buildExitDialog(context, timer, controller));
              },
              icon: Icon(
                TablerIcons.x,
                color: MyApp.of(context).isDarkMode()
                    ? lightNeutral100
                    : lightNeutral50,
              )),
          title: Text(
              AppLocalizations.of(context)!.run_set_from_one +
                  currentSet.toString() +
                  AppLocalizations.of(context)!.run_set_from_two +
                  widget.sets.toString(),
              style: heading2Bold(context).copyWith(
                  color: MyApp.of(context).isDarkMode()
                      ? lightNeutral100
                      : lightNeutral50)),
          centerTitle: true,
          actions: [
            IconButton(
                color: MyApp.of(context).isDarkMode()
                    ? lightNeutral100
                    : lightNeutral50,
                onPressed: () {
                  controller.pause();
                  setState(() {});
                  showModalBottomSheet(
                    isScrollControlled: true,
                    enableDrag: false,
                    context: context,
                    builder: (BuildContext context) =>
                        Dialogs.buildChangeSoundDialog(context, setState),
                  );
                },
                icon: Icon(
                  TablerIcons.settings,
                  color: MyApp.of(context).isDarkMode()
                      ? lightNeutral100
                      : lightNeutral50,
                )),
          ],
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
                    duration: widget.time[indexTime],
                    initialDuration: 0,
                    onComplete: () {
                      next();
                    },
                    width: 320,
                    height: 300,
                    strokeCap: StrokeCap.round,
                    ringColor: Colors.white.withOpacity(0.5),
                    fillColor: MyApp.of(context).isDarkMode()
                        ? lightNeutral100
                        : lightNeutral50,
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
                          : indexTime == 0
                              ? AppLocalizations.of(context)!.training
                              : AppLocalizations.of(context)!.pause,
                      style: heading1Bold(context).copyWith(
                          color: MyApp.of(context).isDarkMode()
                              ? lightNeutral100
                              : lightNeutral50),
                    ),
                    textStyle: display2(context).copyWith(
                        color: MyApp.of(context).isDarkMode()
                            ? lightNeutral100
                            : lightNeutral50),
                  ),
                  Column(
                    children: [
                      Text(
                          "${((remainingPlus + counter) / 60).floor()}:${((remainingPlus + counter) % 60).toString().padLeft(2, '0')}",
                          style: body0Bold(context).copyWith(
                              color: MyApp.of(context).isDarkMode()
                                  ? lightNeutral100
                                  : lightNeutral50)),
                      Text(AppLocalizations.of(context)!.run_remaining,
                          style: body0Bold(context).copyWith(
                              color: MyApp.of(context).isDarkMode()
                                  ? lightNeutral100
                                  : lightNeutral50)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                          color: MyApp.of(context).isDarkMode()
                              ? lightNeutral100
                              : lightNeutral50,
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
                        backgroundColor: MyApp.of(context).isDarkMode()
                            ? lightNeutral100
                            : lightNeutral50,
                        child: IconButton(
                            iconSize: 60,
                            color: controller.isPaused
                                ? const Color(0xff7C7C7C)
                                : indexTime == 0
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
                          color: MyApp.of(context).isDarkMode()
                              ? lightNeutral100
                              : lightNeutral50,
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
