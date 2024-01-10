import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:interval_timer/const.dart';
import 'package:interval_timer/pages/run/run.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:just_audio/just_audio.dart';
import 'package:hive/hive.dart';
import '../../main.dart';
import '../home.dart';

class Preparation extends StatefulWidget {
  final List<int> time;
  final int sets;
  final int currentSet;
  final int indexTime;
  const Preparation(
      {super.key,
      required this.time,
      required this.sets,
      required this.currentSet,
      required this.indexTime});

  @override
  State<Preparation> createState() => _PreparationState();
}

class _PreparationState extends State<Preparation> {
  int counter = 9;
  bool isPaused = false;
  final player = AudioPlayer();

  String sound = Hive.box("settings").get("sound");

  late Timer timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
    if (counter == 0) {
      await next();
    }
    if (counter > 0 && !isPaused) {
      setState(() {
        counter--;
      });
    }
    if (counter == 3 && sound != "off" && !isPaused) {
      playAudio();
    }
  });

  @override
  void initState() {
    super.initState();
    timer;
  }

  @override
  dispose() {
    super.dispose();
    player.dispose();
    timer.cancel();
  }

  playAudio() async {
    await player.setAsset(sound);
    await player.play();
  }

  next() async {
    player.dispose();
    timer.cancel();

    List<AudioSource> runTime = [];
    List<AudioSource> pauseTime = [];

    for (int i = 0; i < widget.time[0] - 5; i++) {
      runTime.add(AudioSource.asset("assets/sounds/Silence.mp3"));
    }

    if (widget.time[0] >= 3) {
      runTime.add(AudioSource.asset(sound));
    }

    for (int i = 0; i < widget.time[1] - 5; i++) {
      pauseTime.add(AudioSource.asset("assets/sounds/Silence.mp3"));
    }
    if (widget.time[1] >= 3) {
      pauseTime.add(AudioSource.asset(sound));
    }

    final run = ConcatenatingAudioSource(
      useLazyPreparation: true,
      shuffleOrder: DefaultShuffleOrder(),
      children: runTime,
    );

    final pause = ConcatenatingAudioSource(
      useLazyPreparation: true,
      shuffleOrder: DefaultShuffleOrder(),
      children: pauseTime,
    );

    final workout = ConcatenatingAudioSource(
        useLazyPreparation: true,
        shuffleOrder: DefaultShuffleOrder(),
        children: [
          ConcatenatingAudioSource(
            children: [
              run,
              pause,
            ],
          )
        ]);

    final player2 = AudioPlayer();
    player2.setLoopMode(LoopMode.all);
    player2.setAudioSource(workout,
        initialIndex: 0, initialPosition: Duration.zero);
    player2.play();

    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => Run(
              startTime: DateTime.now(),
              time: widget.time,
              sets: widget.sets,
              currentSet: widget.currentSet,
              indexTime: widget.indexTime,
              player: player2,
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
              onPressed: () {
                player.dispose();
                timer.cancel();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const Home(
                          screenIndex: 1,
                        )));
              }),
        ),
        body: InkWell(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onTap: () {
            setState(() {
              isPaused = !isPaused;
            });
            if (counter <= 3 && isPaused) {
              player.pause();
            }
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
                            color: MyApp.of(context).isDarkMode()
                                ? lightNeutral100
                                : lightNeutral50)),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                    style: body1BoldUnderlined(context),
                    text: AppLocalizations.of(context)!.run_skip,
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        await next();
                      }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
