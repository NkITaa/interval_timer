import 'package:ffmpeg_kit_flutter_audio/ffmpeg_kit.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:just_audio/just_audio.dart';
import 'package:hive/hive.dart';
import 'package:just_audio_background/just_audio_background.dart';

class AudioReturn {
  final List<String> ffmpegOutput;
  final String sound;
  AudioReturn(this.ffmpegOutput, this.sound);
}

Future<AudioReturn> initialize(player, List<int> time, int sets) async {
  DateTime now = DateTime.now();
  String sound = await Hive.box("settings").get("sound");
  List<String> runDir = await buildFileNames(time[0], sound);
  List<String> pauseDir = await buildFileNames(time[1], sound);
  String messageRun = await concatenateMP3(runDir, "run.mp3");
  String messagePause = await concatenateMP3(pauseDir, "pause.mp3");

  List<AudioSource> workoutList = await buildWorkoutList(sets);

  final workout = ConcatenatingAudioSource(
    useLazyPreparation: true,
    shuffleOrder: DefaultShuffleOrder(),
    children: workoutList,
  );
  await player.setAudioSource(workout);
  DateTime later = DateTime.now();

  int timeToInitialize = later.difference(now).inMilliseconds;
  if (timeToInitialize < 1000) {
    await Future.delayed(Duration(milliseconds: 1000 - timeToInitialize));
  }

  return AudioReturn([messageRun, messagePause], sound);
}

Future<String> concatenateMP3(
    List<String> fileNames, String outputFileName) async {
  String toConcatinate = fileNames.expand((f) => ['-i', f]).toList().join(' ');
  final directory = await getApplicationCacheDirectory();
  String message = '';

  await FFmpegKit.execute(
          "-y  $toConcatinate -filter_complex concat=n=${fileNames.length}:v=0:a=1 -c:a libmp3lame -q:a 2 ${directory.path}/$outputFileName")
      .then((session) async {
    final returnCode = await session.getReturnCode();
    message = returnCode.toString();
  });
  return message;
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

  String soundPath = sound == "off" ? "Countdown1.mp3" : sound.substring(14);

  if (time >= 4) {
    buildFiles.add('${docDir.path}/$soundPath');
  }
  return buildFiles;
}

Future<List<AudioSource>> buildWorkoutList(int sets) async {
  List<AudioSource> workoutList = [];
  final directory = await getApplicationCacheDirectory();
  final docDir = await getApplicationDocumentsDirectory();

  int i = 0;
  for (; i < sets - 1; i++) {
    workoutList.add(
      AudioSource.uri(
        Uri.parse("file://${directory.path}/run.mp3"),
        tag: MediaItem(
          id: '$i training',
          album: "training ${i + 1}",
          title: "training ${i + 1}",
          artUri: Uri.parse("file://${docDir.path}/training.png"),
        ),
      ),
    );
    workoutList.add(
      AudioSource.uri(
        Uri.parse("file://${directory.path}/pause.mp3"),
        tag: MediaItem(
          id: '$i pause',
          album: "pause ${i + 1}",
          title: "pause ${i + 1}",
          artUri: Uri.parse("file://${docDir.path}/pause.png"),
        ),
      ),
    );
  }
  workoutList.add(
    AudioSource.uri(
      Uri.parse("file://${directory.path}/run.mp3"),
      tag: MediaItem(
        id: '$i training',
        album: "training ${i + 1}",
        title: "training ${i + 1}",
        artUri: Uri.parse("file://${docDir.path}/training.png"),
      ),
    ),
  );
  return workoutList;
}
