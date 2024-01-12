import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:interval_timer/const.dart';
import 'package:interval_timer/main.dart';
import 'package:interval_timer/pages/run/custom_timer.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:interval_timer/pages/run/preparation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:hive/hive.dart';
import '../../components/dialogs.dart';
import 'congrats.dart';
import 'package:wakelock/wakelock.dart';

class Run extends StatefulWidget {
  final int totalDuration;
  final List<int> time;
  final int sets;
  final int currentSet;
  final int indexTime;
  final DateTime startTime;
  final AudioPlayer player;

  const Run({
    super.key,
    required this.totalDuration,
    required this.time,
    required this.sets,
    required this.currentSet,
    required this.indexTime,
    required this.startTime,
    required this.player,
  });

  @override
  State<Run> createState() => _RunState();
}

class _RunState extends State<Run> with WidgetsBindingObserver {
  String sound = Hive.box("settings").get("sound");
  late int remainderBasis = widget.totalDuration;

  next() async {
    if (widget.player.currentIndex! % 2 == 0 &&
        widget.sets == widget.player.currentIndex! ~/ 2 + 1) {
      await widget.player.dispose();
      await Wakelock.disable();

      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Congrats(
                  time: widget.time,
                  sets: widget.sets,
                  duration:
                      DateTime.now().difference(widget.startTime).inSeconds,
                )));
      });
    } else {
      await widget.player.seekToNext();
      int temp = 0;
      for (int i = 0; i < widget.player.currentIndex!; i++) {
        temp += widget.time[i % 2];
      }
      remainderBasis = widget.totalDuration - temp;
      setState(() {});
    }
  }

  back() async {
    int duration = widget.player.position.inSeconds;
    if (duration > 3) {
      await widget.player.seek(Duration.zero);
      int temp = 0;
      for (int i = 0; i < widget.player.currentIndex!; i++) {
        temp += widget.time[i % 2];
      }
      remainderBasis = widget.totalDuration - temp;
      setState(() {});
    } else if (widget.player.currentIndex! % 2 == 0 &&
        widget.player.currentIndex! ~/ 2 + 1 == 1) {
      await widget.player.stop();
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Preparation(
                player: widget.player,
                totalDuration: widget.totalDuration,
                time: widget.time,
                sets: widget.sets,
                currentSet: 1,
                indexTime: 0)));
      });
    } else {
      await widget.player.seekToPrevious();
      int temp = 0;
      for (int i = 0; i < widget.player.currentIndex!; i++) {
        temp += widget.time[i % 2];
      }
      remainderBasis = widget.totalDuration - temp;
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    widget.player.seek(Duration.zero, index: 0);
    WidgetsBinding.instance.addObserver(this);
    Wakelock.enable();
  }

  @override
  dispose() {
    Wakelock.disable();
    widget.player.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Handle state changes as needed

    if (state == AppLifecycleState.resumed) {
      int temp = 0;
      for (int i = 0; i < widget.player.currentIndex!; i++) {
        temp += widget.time[i % 2];
      }
      remainderBasis = widget.totalDuration - temp;

      if (remainderBasis - widget.player.position.inSeconds - 1 <= 0) {
        next();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: widget.player.positionStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            int duration =
                widget.player.duration!.inSeconds - snapshot.data!.inSeconds;

            if (duration <= 0) {
              next();
            }

            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: !widget.player.playerState.playing
                      ? [const Color(0xffA3A3A3), const Color(0xff7C7C7C)]
                      : widget.player.currentIndex! % 2 == 0
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
                          widget.player.pause();
                          setState(() {});
                          showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  Dialogs.buildExitDialog(
                                      context, widget.player)).whenComplete(() {
                            widget.player.play();
                            setState(() {});
                          });
                        },
                        icon: Icon(
                          TablerIcons.x,
                          color: MyApp.of(context).isDarkMode()
                              ? lightNeutral100
                              : lightNeutral50,
                        )),
                    title: Text(
                        AppLocalizations.of(context)!.run_set_from_one +
                            (widget.player.currentIndex! ~/ 2 + 1).toString() +
                            AppLocalizations.of(context)!.run_set_from_two +
                            widget.sets.toString(),
                        style: heading2Bold(context).copyWith(
                            color: MyApp.of(context).isDarkMode()
                                ? lightNeutral100
                                : lightNeutral50)),
                    centerTitle: true,
                    actions: [
                      IconButton(
                          onPressed: () {
                            if (sound == "off") {
                              sound = "assets/sounds/Countdown1.mp3";
                              widget.player.setVolume(1);
                            } else {
                              sound = "off";
                              widget.player.setVolume(0);
                            }
                            Hive.box("settings").put("sound", sound);
                            setState(() {});
                          },
                          icon: Icon(
                            sound == "off"
                                ? TablerIcons.volume_off
                                : TablerIcons.volume,
                            color: MyApp.of(context).isDarkMode()
                                ? lightNeutral100
                                : lightNeutral50,
                          ))
                    ],
                  ),
                  body: SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        if (!widget.player.playerState.playing) {
                          widget.player.play();
                          setState(() {});
                        } else {
                          widget.player.pause();
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
                                seconds: duration,
                                maxSeconds: widget.player.duration!.inSeconds,
                                isRunning: widget.player.playerState.playing,
                                indexTime: widget.player.currentIndex! % 2),
                            Column(
                              children: [
                                Text(
                                    "${((remainderBasis - snapshot.data!.inSeconds) / 60).floor()}:${((remainderBasis - snapshot.data!.inSeconds) % 60).toString().padLeft(2, '0')}",
                                    style: body0Bold(context).copyWith(
                                        color: MyApp.of(context).isDarkMode()
                                            ? lightNeutral100
                                            : lightNeutral50)),
                                Text(
                                    AppLocalizations.of(context)!.run_remaining,
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
                                    onPressed: () async {
                                      await back();
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
                                  backgroundColor:
                                      MyApp.of(context).isDarkMode()
                                          ? lightNeutral100
                                          : lightNeutral50,
                                  child: IconButton(
                                      iconSize: 60,
                                      color: !widget.player.playerState.playing
                                          ? const Color(0xff7C7C7C)
                                          : widget.player.currentIndex! % 2 == 0
                                              ? const Color(0xffFA5F54)
                                              : const Color(0xff7189E1),
                                      onPressed: () {
                                        if (!widget
                                            .player.playerState.playing) {
                                          widget.player.play();
                                          setState(() {});
                                        } else {
                                          widget.player.pause();
                                          setState(() {});
                                        }
                                        setState(() {});
                                      },
                                      icon: Icon(
                                        !widget.player.playerState.playing
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
                                    onPressed: () async {
                                      await next();
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
                  )),
            );
          } else {
            return const SizedBox();
          }
        });
  }
}
