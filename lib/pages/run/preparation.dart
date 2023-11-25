import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:interval_timer/const.dart';
import 'package:interval_timer/pages/run/run.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:hive/hive.dart';

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

  late Timer timer = Timer.periodic(const Duration(seconds: 1), (timer) {
    if (counter == 0) {
      next();
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

  playAudio() async {
    await player.play(AssetSource(sound));
  }

  next() {
    player.dispose();
    timer.cancel();
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => Run(
              time: widget.time,
              sets: widget.sets,
              currentSet: widget.currentSet,
              indexTime: widget.indexTime,
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
              : [Color(0xffFFA24B), Color(0xffEABB2D)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: IconButton(
              icon: const Icon(TablerIcons.x),
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
                      style: const TextStyle(
                          fontSize: 80,
                          color: lightNeutral50,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(AppLocalizations.of(context)!.run_preparing,
                        style: const TextStyle(
                            fontSize: 26,
                            color: lightNeutral50,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xff653200),
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold,
                    ),
                    text: AppLocalizations.of(context)!.run_skip,
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        next();
                      }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
