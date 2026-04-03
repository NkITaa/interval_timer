import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:interval_timer/services/settings_service.dart';

class AudioReturn {
  final List<String> concatenationResult;
  final String sound;
  AudioReturn(this.concatenationResult, this.sound);
}

Future<AudioReturn> initialize(player, List<int> time, int sets) async {
  String sound = SettingsService.sound;
  List<String> runAssets = buildAssetPaths(time[0], sound);
  List<String> pauseAssets = buildAssetPaths(time[1], sound);

  String messageRun = await concatenateAssets(runAssets, "run.mp3");
  String messagePause = await concatenateAssets(pauseAssets, "pause.mp3");

  List<AudioSource> workoutList = await buildWorkoutList(sets);

  final workout = ConcatenatingAudioSource(
    useLazyPreparation: true,
    shuffleOrder: DefaultShuffleOrder(),
    children: workoutList,
  );
  await player.setAudioSource(workout);

  return AudioReturn([messageRun, messagePause], sound);
}

Future<String> concatenateAssets(
    List<String> assetPaths, String outputFileName) async {
  try {
    final directory = await getApplicationCacheDirectory();
    final outputFile = File('${directory.path}/$outputFileName');
    final sink = outputFile.openWrite();

    for (String assetPath in assetPaths) {
      final data = await rootBundle.load(assetPath);
      sink.add(data.buffer.asUint8List());
    }

    await sink.close();
    return "0";
  } catch (e) {
    debugPrint('Audio concatenation failed for $outputFileName: $e');
    return "1";
  }
}

List<String> buildAssetPaths(int time, String sound) {
  List<String> buildFiles = [];

  int rest = time - 4;
  if (rest < 0) {
    rest += 4;
  }

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

  for (int i = 0; i < thirtyMin; i++) {
    buildFiles.add('assets/sounds/30min.mp3');
  }
  for (int i = 0; i < tenMin; i++) {
    buildFiles.add('assets/sounds/10min.mp3');
  }
  for (int i = 0; i < fiveMin; i++) {
    buildFiles.add('assets/sounds/5min.mp3');
  }
  for (int i = 0; i < oneMin; i++) {
    buildFiles.add('assets/sounds/1min.mp3');
  }
  for (int i = 0; i < thirtySec; i++) {
    buildFiles.add('assets/sounds/30sec.mp3');
  }
  for (int i = 0; i < tenSec; i++) {
    buildFiles.add('assets/sounds/10sec.mp3');
  }
  for (int i = 0; i < fiveSec; i++) {
    buildFiles.add('assets/sounds/5sec.mp3');
  }
  for (int i = 0; i < oneSec; i++) {
    buildFiles.add('assets/sounds/1sec.mp3');
  }

  String soundFile =
      sound == "off" ? "assets/sounds/Countdown1.mp3" : sound;

  if (time >= 4) {
    buildFiles.add(soundFile);
    buildFiles.add('assets/sounds/1sec.mp3');
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
