import 'dart:async';
import 'package:flutter/material.dart';
import 'package:interval_timer/const.dart';
import 'package:interval_timer/main.dart';
import 'package:interval_timer/pages/run/custom_timer.dart';
import 'package:interval_timer/pages/run/preparation.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:hive/hive.dart';
import '../../components/dialogs.dart';
import 'congrats.dart';
import 'package:wakelock/wakelock.dart';

class Run extends StatefulWidget {
  final List<int> time;
  final int sets;
  final int currentSet;
  final int indexTime;
  final DateTime startTime;

  const Run({
    super.key,
    required this.time,
    required this.sets,
    required this.currentSet,
    required this.indexTime,
    required this.startTime,
  });

  @override
  State<Run> createState() => _RunState();
}

class _RunState extends State<Run> with WidgetsBindingObserver {
  bool isRunning = true;
  final player = AudioPlayer();
  String sound = Hive.box("settings").get("sound");
  DateTime? timeLeft;

  late Timer timer = Timer.periodic(const Duration(seconds: 1), (timer) {
    if (counter == 0) {
      next();
    }
    if (counter > 0 && isRunning) {
      counter--;
      setState(() {});
    }
    if (counter == 3 && isRunning) {
      player.play(AssetSource(sound));
    }
  });

  late int currentSet = widget.currentSet;
  late int indexTime = widget.indexTime;

  late int counter = widget.time[widget.indexTime];
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
      WidgetsBinding.instance.removeObserver(this);

      Wakelock.disable();
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Congrats(
                time: widget.time,
                sets: widget.sets,
                duration: DateTime.now().difference(widget.startTime).inSeconds,
              )));
    } else {
      if (indexTime == 1 || widget.time[1] == 0) {
        ++currentSet;
      }
      if (widget.time[1] != 0) {
        indexTime = indexTime == 1 ? 0 : 1;
      }
      counter = widget.time[indexTime];
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
      counter = widget.time[indexTime];
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
    Wakelock.enable();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  dispose() {
    Wakelock.disable();
    timer.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        if (timeLeft != null) {
          int passedTime = DateTime.now().difference(timeLeft!).inSeconds;
          int rest = remainingPlus + counter - widget.time[1] - passedTime;
          if (rest < 0) {
            timer.cancel();
            WidgetsBinding.instance.removeObserver(this);
            Wakelock.disable();
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => Congrats(
                      time: widget.time,
                      sets: widget.sets,
                      duration:
                          DateTime.now().difference(widget.startTime).inSeconds,
                    )));
          } else {
            int index = 0;
            int todoSets = 0;

            while (rest > 0) {
              rest -= widget.time[index];
              if (rest > 0) {
                index = 1 - index;
                if (index == 1) {
                  todoSets++;
                }
              }
            }

            indexTime = index;
            currentSet = widget.sets - todoSets;
            counter = widget.time[indexTime] - rest.abs();
            remainingPlus = indexTime == 0
                ? (((widget.time[0] + widget.time[1]) *
                        (widget.sets - currentSet + 1)) -
                    widget.time[0])
                : (((widget.time[0] + widget.time[1]) *
                        (widget.sets - currentSet + 1)) -
                    widget.time[0] -
                    widget.time[1]);
            isRunning = true;
            timeLeft = null;
            setState(() {});
          }
        }
        break;
      case AppLifecycleState.paused:
        if (isRunning) {
          timeLeft = DateTime.now();
          isRunning = false;
        }
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: !isRunning
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
                isRunning = false;
                setState(() {});
                showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            Dialogs.buildExitDialog(context, timer))
                    .whenComplete(() => isRunning = true);
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
                  isRunning = false;
                  setState(() {});
                  showModalBottomSheet(
                    backgroundColor: Colors.transparent,
                    isScrollControlled: true,
                    enableDrag: false,
                    context: context,
                    builder: (BuildContext context) =>
                        Dialogs.buildChangeSoundDialog(
                            player, context, setState),
                  ).whenComplete(() {
                    isRunning = true;
                    sound = Hive.box("settings").get("sound");
                    setState(() {});
                    player.stop();
                  });
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
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () {
              if (!isRunning) {
                isRunning = true;
                setState(() {});
              } else {
                isRunning = false;
                setState(() {});
              }
              setState(() {});
            },
            child: Padding(
              padding: const EdgeInsets.only(bottom: 82.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomTimer(
                      seconds: counter,
                      maxSeconds: widget.time[indexTime],
                      isRunning: isRunning,
                      indexTime: indexTime),
                  Column(
                    children: [
                      Text(
                          "${((remainingPlus + counter - widget.time[1]) / 60).floor()}:${((remainingPlus + counter - widget.time[1]) % 60).toString().padLeft(2, '0')}",
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
                            color: !isRunning
                                ? const Color(0xff7C7C7C)
                                : indexTime == 0
                                    ? const Color(0xffFA5F54)
                                    : const Color(0xff7189E1),
                            onPressed: () {
                              if (!isRunning) {
                                isRunning = true;
                                setState(() {});
                              } else {
                                isRunning = false;
                                setState(() {});
                              }
                              setState(() {});
                            },
                            icon: Icon(
                              !isRunning
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
