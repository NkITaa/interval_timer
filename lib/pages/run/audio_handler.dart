import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:interval_timer/services/settings_service.dart';

class AudioReturn {
  final List<String> concatenationResult;
  final String sound;
  final ConcatenatingAudioSource workoutSource;
  AudioReturn(this.concatenationResult, this.sound, this.workoutSource);
}

Future<AudioReturn> initialize(player, List<int> time, int sets) async {
  String sound = SettingsService.sound;
  List<String> runAssets = buildAssetPaths(time[0], sound);
  List<String> pauseAssets = buildAssetPaths(time[1], sound);

  final results = await Future.wait([
    concatenateAssets(runAssets, "run.mp3"),
    concatenateAssets(pauseAssets, "pause.mp3"),
  ]);
  String messageRun = results[0];
  String messagePause = results[1];

  List<AudioSource> workoutList = await buildWorkoutList(sets);

  final workout = ConcatenatingAudioSource(
    useLazyPreparation: true,
    shuffleOrder: DefaultShuffleOrder(),
    children: workoutList,
  );

  // Load beep sound into player for preparation countdown.
  // The workout source will be swapped in when preparation finishes.
  if (sound != "off") {
    await player.setAudioSource(
      AudioSource.asset(sound, tag: const MediaItem(
        id: 'beep',
        album: 'countdown',
        title: 'countdown beep',
      )),
    );
  }

  return AudioReturn([messageRun, messagePause], sound, workout);
}

Future<String> concatenateAssets(
    List<String> assetPaths, String outputFileName) async {
  try {
    final directory = await getApplicationCacheDirectory();
    final outputFile = File('${directory.path}/$outputFileName');
    final sink = outputFile.openWrite();

    final Map<String, Uint8List> cache = {};
    for (final assetPath in assetPaths) {
      final bytes = cache[assetPath] ??=
          _stripMp3Metadata((await rootBundle.load(assetPath)).buffer.asUint8List());
      sink.add(bytes);
    }

    await sink.close();
    return "0";
  } catch (e) {
    debugPrint('Audio concatenation failed for $outputFileName: $e');
    return "1";
  }
}

/// Strips ID3v2 header and Xing/Info metadata frame from MP3 bytes.
/// Returns raw MPEG audio frames only.
Uint8List _stripMp3Metadata(Uint8List bytes) {
  int offset = 0;

  // Skip ID3v2 header if present ("ID3" magic bytes at start)
  if (bytes.length >= 10 &&
      bytes[0] == 0x49 && bytes[1] == 0x44 && bytes[2] == 0x33) {
    // Size is a 28-bit synchsafe integer stored in bytes 6-9
    final size = (bytes[6] & 0x7F) << 21 |
                 (bytes[7] & 0x7F) << 14 |
                 (bytes[8] & 0x7F) << 7 |
                 (bytes[9] & 0x7F);
    offset = size + 10;
    // Account for optional ID3v2 footer (indicated by flag in byte 5, bit 4)
    if (bytes[5] & 0x10 != 0) offset += 10;
  }

  // Find first MPEG frame sync (11 set bits: 0xFF followed by 0xE0+)
  while (offset < bytes.length - 1) {
    if (bytes[offset] == 0xFF && (bytes[offset + 1] & 0xE0) == 0xE0) {
      // Check if this frame is a Xing/Info metadata frame
      final searchEnd = (offset + 200).clamp(0, bytes.length - 4);
      bool isXing = false;
      for (int i = offset + 4; i <= searchEnd; i++) {
        if ((bytes[i] == 0x58 && bytes[i + 1] == 0x69 &&
             bytes[i + 2] == 0x6E && bytes[i + 3] == 0x67) || // "Xing"
            (bytes[i] == 0x49 && bytes[i + 1] == 0x6E &&
             bytes[i + 2] == 0x66 && bytes[i + 3] == 0x6F)) { // "Info"
          isXing = true;
          break;
        }
      }
      if (isXing) {
        // Skip this frame — scan for the next sync
        for (int i = offset + 1; i < bytes.length - 1; i++) {
          if (bytes[i] == 0xFF && (bytes[i + 1] & 0xE0) == 0xE0) {
            offset = i;
            break;
          }
        }
      }
      break;
    }
    offset++;
  }

  if (offset <= 0) return bytes;
  return Uint8List.sublistView(bytes, offset);
}

List<String> buildAssetPaths(int time, String sound) {
  final buildFiles = <String>[];

  int silenceSeconds = time - 4;
  if (silenceSeconds < 0) {
    silenceSeconds += 4;
  }

  for (int i = 0; i < silenceSeconds; i++) {
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
