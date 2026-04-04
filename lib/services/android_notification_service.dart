import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class AndroidNotificationService {
  static const _channel = MethodChannel('workout_notification');

  static Future<void> update({
    required String title,
    required String content,
    required int color,
    required int phaseRemainingSec,
    required bool isPaused,
  }) async {
    if (!Platform.isAndroid) return;
    try {
      await _channel.invokeMethod('update', {
        'title': title,
        'content': content,
        'color': color,
        'phaseRemainingSec': phaseRemainingSec,
        'isPaused': isPaused,
      });
    } catch (e) {
      debugPrint('AndroidNotification update failed: $e');
    }
  }

  static Future<void> stop() async {
    if (!Platform.isAndroid) return;
    try {
      await _channel.invokeMethod('stop');
    } catch (_) {}
  }

  static Future<void> requestPermission() async {
    if (!Platform.isAndroid) return;
    try {
      await _channel.invokeMethod('requestPermission');
    } catch (_) {}
  }
}
