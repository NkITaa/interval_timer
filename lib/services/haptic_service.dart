import 'package:flutter/services.dart';
import 'package:interval_timer/services/settings_service.dart';

class HapticService {
  static void light() {
    if (!SettingsService.isHapticEnabled) return;
    HapticFeedback.lightImpact();
  }

  static void medium() {
    if (!SettingsService.isHapticEnabled) return;
    HapticFeedback.mediumImpact();
  }

  static void heavy() {
    if (!SettingsService.isHapticEnabled) return;
    HapticFeedback.heavyImpact();
  }

  static void selection() {
    if (!SettingsService.isHapticEnabled) return;
    HapticFeedback.selectionClick();
  }

  static Future<void> success() async {
    if (!SettingsService.isHapticEnabled) return;
    HapticFeedback.heavyImpact();
    await Future.delayed(const Duration(milliseconds: 150));
    HapticFeedback.heavyImpact();
  }
}
