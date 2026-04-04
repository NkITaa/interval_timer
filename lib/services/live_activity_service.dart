import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class LiveActivityService {
  static const _channel = MethodChannel('live_activity');

  static Future<void> start({
    required int totalEndTimestamp,
  }) async {
    try {
      await _channel.invokeMethod('start', {
        'totalEndTimestamp': totalEndTimestamp,
      });
    } catch (e) {
      debugPrint('LiveActivity start failed: $e');
    }
  }

  static Future<void> update({
    required int totalEndTimestamp,
    required bool isPaused,
    required int totalRemainingSeconds,
  }) async {
    try {
      await _channel.invokeMethod('update', {
        'totalEndTimestamp': totalEndTimestamp,
        'isPaused': isPaused,
        'totalRemainingSeconds': totalRemainingSeconds,
      });
    } catch (e) {
      debugPrint('LiveActivity update failed: $e');
    }
  }

  static Future<void> stop() async {
    try {
      await _channel.invokeMethod('stop');
    } catch (_) {}
  }
}
