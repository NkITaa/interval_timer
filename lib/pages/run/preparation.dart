import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:interval_timer/const.dart';
import 'package:interval_timer/pages/run/run.dart';
import 'package:interval_timer/l10n/app_localizations.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:interval_timer/services/settings_service.dart';
import 'package:interval_timer/services/haptic_service.dart';

import '../home.dart';

class Preparation extends StatefulWidget {
  final List<int> time;
  final int sets;
  final int currentSet;
  final int indexTime;
  final AudioPlayer player;
  final int totalDuration;
  final ConcatenatingAudioSource workoutSource;
  const Preparation(
      {super.key,
      required this.time,
      required this.sets,
      required this.currentSet,
      required this.indexTime,
      required this.totalDuration,
      required this.player,
      required this.workoutSource});

  @override
  State<Preparation> createState() => _PreparationState();
}

class _PreparationState extends State<Preparation> {
  int counter = 9;
  bool isPaused = false;
  bool _navigating = false;

  String sound = SettingsService.sound;

  late Timer timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
    if (_navigating) return;
    if (counter == 0) {
      HapticService.heavy();
      await next();
    }
    if (counter > 0 && !isPaused) {
      if (counter >= 2 && counter <= 4 && sound != "off") {
        widget.player.seek(Duration.zero);
        widget.player.play();
      }
      if (counter >= 2 && counter <= 4) {
        HapticService.light();
      } else if (counter == 1) {
        HapticService.medium();
      }
      setState(() {
        counter--;
      });
    }
  });

  @override
  void initState() {
    super.initState();
    _initBeepSound();
    timer;
  }

  void _initBeepSound() async {
    if (sound != "off") {
      await widget.player.setAudioSource(
        AudioSource.asset(sound, tag: const MediaItem(
          id: 'beep',
          album: 'countdown',
          title: 'countdown beep',
        )),
      );
    }
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  next() async {
    if (_navigating) return;
    _navigating = true;
    timer.cancel();
    await widget.player.stop();
    await widget.player.setAudioSource(widget.workoutSource);
    sound == "off" ? widget.player.setVolume(0) : widget.player.setVolume(1);
    widget.player.play();
    if (!mounted) return;
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => Run(
              startTime: DateTime.now(),
              time: widget.time,
              sets: widget.sets,
              currentSet: widget.currentSet,
              indexTime: widget.indexTime,
              player: widget.player,
              totalDuration: widget.totalDuration,
              workoutSource: widget.workoutSource,
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isPaused
              ? [const Color(0xffA3A3A3), const Color(0xff7C7C7C)]
              : [const Color(0xffFFA24B), const Color(0xffEABB2D)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: IconButton(
              icon: const Icon(TablerIcons.x, color: Color(0xffFAEFDC)),
              onPressed: () async {
                if (_navigating) return;
                _navigating = true;
                HapticService.selection();
                timer.cancel();
                await widget.player.dispose();
                SchedulerBinding.instance.addPostFrameCallback((_) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => const Home(screenIndex: 1)),
                    (route) => false,
                  );
                });
              }),
        ),
        body: InkWell(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onTap: () {
            HapticService.selection();
            setState(() {
              isPaused = !isPaused;
            });
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                height: 180,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      counter.toString(),
                      style: display2(context),
                    ),
                    Text(AppLocalizations.of(context)!.run_preparing,
                        style: heading1Bold(context).copyWith(
                            color: context.colors.textOnGradient)),
                  ],
                ),
              ),
              InkWell(
                onTap: () async {
                  HapticService.selection();
                  await next();
                },
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                child: SizedBox(
                  height: 100,
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: RichText(
                      text: TextSpan(
                          style: body1BoldUnderlined(context),
                          text: AppLocalizations.of(context)!.run_skip,
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              HapticService.selection();
                              await next();
                            }),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
