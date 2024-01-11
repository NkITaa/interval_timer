import 'dart:async';
import 'dart:io';
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
import 'package:ffmpeg_kit_flutter_audio/ffmpeg_kit.dart';
import 'package:path_provider/path_provider.dart';

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
    await AudioPlayer.clearAssetCache();
    final player2 = AudioPlayer();
    List<String> runDir = await buildFileNames(widget.time[0], sound);
    List<String> pauseDir = await buildFileNames(widget.time[1], sound);
    await concatenateMP3(runDir, "run.mp3");
    await concatenateMP3(pauseDir, "pause.mp3");

    List<AudioSource> workoutList = await buildWorkoutList(widget.sets);

    final workout = ConcatenatingAudioSource(
      useLazyPreparation: true,
      shuffleOrder: DefaultShuffleOrder(),
      children: workoutList,
    );
    await player2.setAudioSource(workout);
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

concatenateMP3(List<String> fileNames, String outputFileName) async {
  String toConcatinate = fileNames.expand((f) => ['-i', f]).toList().join(' ');
  final directory = await getApplicationCacheDirectory();
  await FFmpegKit.execute(
      "-y  $toConcatinate -filter_complex concat=n=${fileNames.length}:v=0:a=1 -c:a libmp3lame -q:a 2 ${directory.path}/$outputFileName");
  print("done");
}

Future<List<String>> buildFileNames(int time, String sound) async {
  List<String> buildFiles = [];
  Directory docDir = await getApplicationDocumentsDirectory();

  int rest = time - 4;

  int thirtyMin = rest ~/ 1800;
  rest = rest % 1800;

  int tenMin = rest ~/ 600;
  rest = rest % 600;

  int fiveMin = rest ~/ 300;
  rest = rest % 300;

  int oneMin = rest ~/ 60;
  rest = rest % 60;

  int thirtySec = rest ~/ 30;
  rest = rest % 30;

  int tenSec = rest ~/ 10;
  rest = rest % 10;

  int fiveSec = rest ~/ 5;
  rest = rest % 5;

  int oneSec = rest ~/ 1;
  rest = rest % 1;

  for (int i = 0; i < thirtyMin; i++) {
    buildFiles.add('${docDir.path}/30min.mp3');
  }

  for (int i = 0; i < tenMin; i++) {
    buildFiles.add('${docDir.path}/10min.mp3');
  }
  for (int i = 0; i < fiveMin; i++) {
    buildFiles.add('${docDir.path}/5min.mp3');
  }
  for (int i = 0; i < oneMin; i++) {
    buildFiles.add('${docDir.path}/1min.mp3');
  }
  for (int i = 0; i < thirtySec; i++) {
    buildFiles.add('${docDir.path}/30sec.mp3');
  }
  for (int i = 0; i < tenSec; i++) {
    buildFiles.add('${docDir.path}/10sec.mp3');
  }
  for (int i = 0; i < fiveSec; i++) {
    buildFiles.add('${docDir.path}/5sec.mp3');
  }
  for (int i = 0; i < oneSec; i++) {
    buildFiles.add('${docDir.path}/1sec.mp3');
  }
  if (time >= 4) {
    buildFiles.add('${docDir.path}/${sound.substring(14)}');
  }
  return buildFiles;
}

Future<List<AudioSource>> buildWorkoutList(int sets) async {
  List<AudioSource> workoutList = [];
  final directory = await getApplicationCacheDirectory();

  for (int i = 0; i < sets - 1; i++) {
    workoutList.add(
      AudioSource.uri(
        Uri.parse("file://${directory.path}/run.mp3"),
      ),
    );
    workoutList.add(
      AudioSource.uri(
        Uri.parse("file://${directory.path}/pause.mp3"),
      ),
    );
  }
  workoutList.add(
    AudioSource.uri(
      Uri.parse("file://${directory.path}/run.mp3"),
    ),
  );
  return workoutList;
}
