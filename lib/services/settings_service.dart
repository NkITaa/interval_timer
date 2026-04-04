import 'package:hive/hive.dart';

class SettingsService {
  static Box get _box => Hive.box("settings");

  // Sound
  static const defaultSound = "assets/sounds/Countdown1.mp3";
  static String get sound => _box.get("sound", defaultValue: defaultSound);
  static Future<void> setSound(String value) => _box.put("sound", value);
  static bool get isSoundOff => sound == "off";

  // Dark mode
  static bool get isDarkMode => _box.get("darkmode", defaultValue: false);
  static Future<void> setDarkMode(bool value) => _box.put("darkmode", value);

  // Language
  static String get language => _box.get("language", defaultValue: "system");
  static Future<void> setLanguage(String value) => _box.put("language", value);

  // Haptic
  static bool get isHapticEnabled => _box.get("haptic", defaultValue: true);
  static Future<void> setHaptic(bool value) => _box.put("haptic", value);

  // Visible (onboarding)
  static bool get isJumpInVisible => _box.get("visible", defaultValue: true);
  static Future<void> setJumpInVisible(bool value) => _box.put("visible", value);
}
