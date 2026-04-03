import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:interval_timer/const.dart';

import 'package:interval_timer/pages/run/custom_timer.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:interval_timer/l10n/app_localizations.dart';
import 'package:interval_timer/pages/run/preparation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:interval_timer/services/settings_service.dart';
import '../../components/dialogs.dart';
import 'congrats.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

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
  String sound = SettingsService.sound;
  late int remainderBasis = widget.totalDuration;
  bool _navigating = false;

  next() async {
    if (_navigating) return;
    if (widget.player.currentIndex! % 2 == 0 &&
        widget.sets == widget.player.currentIndex! ~/ 2 + 1) {
      _navigating = true;
      await widget.player.dispose();
      await WakelockPlus.disable();

      if (!context.mounted) return;
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => Congrats(
                didIt: true,
                time: widget.time,
                sets: widget.sets,
                duration: DateTime.now().difference(widget.startTime).inSeconds,
              )));
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
      _navigating = true;
      await widget.player.stop();
      await WakelockPlus.disable();
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
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

  void _togglePlayPause() {
    if (!widget.player.playerState.playing) {
      widget.player.play();
    } else {
      widget.player.pause();
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    widget.player.seek(Duration.zero, index: 0);
    WidgetsBinding.instance.addObserver(this);
    WakelockPlus.enable();
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    widget.player.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      int temp = 0;
      for (int i = 0; i < widget.player.currentIndex!; i++) {
        temp += widget.time[i % 2];
      }
      remainderBasis = widget.totalDuration - temp;

      if (remainderBasis - widget.player.position.inSeconds <= 0) {
        next();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPlaying = widget.player.playerState.playing;
    final currentIndex = widget.player.currentIndex ?? 0;
    final isTraining = currentIndex % 2 == 0;
    final textColor = context.colors.textOnGradient;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: !isPlaying
              ? [const Color(0xffA3A3A3), const Color(0xff7C7C7C)]
              : isTraining
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
                              context,
                              widget.player,
                              widget.time,
                              widget.sets,
                              DateTime.now()
                                  .difference(widget.startTime)
                                  .inSeconds)).whenComplete(() {
                    widget.player.play();
                    setState(() {});
                  });
                },
                icon: Icon(TablerIcons.x, color: textColor)),
            title: Text(
                AppLocalizations.of(context)!.run_set_from_one +
                    (currentIndex ~/ 2 + 1).toString() +
                    AppLocalizations.of(context)!.run_set_from_two +
                    widget.sets.toString(),
                style: heading2Bold(context).copyWith(color: textColor)),
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
                    SettingsService.setSound(sound);
                    setState(() {});
                  },
                  icon: Icon(
                    sound == "off" ? TablerIcons.volume_off : TablerIcons.volume,
                    color: textColor,
                  ))
            ],
          ),
          body: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: _togglePlayPause,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 82.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Only this StreamBuilder rebuilds on each position tick
                    StreamBuilder<Duration>(
                      stream: widget.player.positionStream,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const SizedBox(height: 380);
                        }
                        final positionSeconds = snapshot.data!.inSeconds;
                        int duration = (widget.player.duration?.inSeconds ?? 0) -
                            positionSeconds;

                        if (duration <= 0 && !_navigating) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            next();
                          });
                        }

                        final remaining = remainderBasis - positionSeconds;
                        return Column(
                          children: [
                            CustomTimer(
                                seconds: duration.clamp(0, 999999),
                                maxSeconds:
                                    widget.player.duration?.inSeconds ?? 0,
                                isRunning: isPlaying,
                                indexTime: currentIndex % 2),
                            Column(
                              children: [
                                Text(
                                    "${(remaining / 60).floor()}:${(remaining % 60).toString().padLeft(2, '0')}",
                                    style: body0Bold(context)
                                        .copyWith(color: textColor)),
                                Text(
                                    AppLocalizations.of(context)!.run_remaining,
                                    style: body0Bold(context)
                                        .copyWith(color: textColor)),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                    // Playback controls — only rebuild on setState (play/pause/segment change)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                            color: textColor,
                            onPressed: () async {
                              await back();
                            },
                            iconSize: 50,
                            icon: const Icon(TablerIcons.chevron_left)),
                        const SizedBox(width: 20),
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: textColor,
                          child: IconButton(
                              iconSize: 60,
                              color: !isPlaying
                                  ? const Color(0xff7C7C7C)
                                  : isTraining
                                      ? const Color(0xffFA5F54)
                                      : const Color(0xff7189E1),
                              onPressed: _togglePlayPause,
                              icon: Icon(
                                !isPlaying
                                    ? TablerIcons.player_play_filled
                                    : TablerIcons.player_pause_filled,
                              )),
                        ),
                        const SizedBox(width: 20),
                        IconButton(
                            color: textColor,
                            onPressed: () async {
                              await next();
                            },
                            iconSize: 50,
                            icon: const Icon(TablerIcons.chevron_right)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
