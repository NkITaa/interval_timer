import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:interval_timer/pages/home.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:interval_timer/l10n/app_localizations.dart';
import 'package:interval_timer/workout.dart';
import 'package:interval_timer/services/settings_service.dart';
import 'const.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:audio_session/audio_session.dart';

late ThemeMode? _themeMode;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Hive.registerAdapter(WorkoutAdapter());

  await Hive.initFlutter();
  await Hive.openBox("workouts");
  await Hive.openBox("settings");
  await initialise();

  final session = await AudioSession.instance;
  await session.configure(const AudioSessionConfiguration(
    avAudioSessionCategory: AVAudioSessionCategory.playback,
    avAudioSessionCategoryOptions: AVAudioSessionCategoryOptions.mixWithOthers,
    avAudioSessionMode: AVAudioSessionMode.defaultMode,
    avAudioSessionRouteSharingPolicy:
        AVAudioSessionRouteSharingPolicy.defaultPolicy,
    avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
    androidAudioAttributes: AndroidAudioAttributes(
      contentType: AndroidAudioContentType.music,
      flags: AndroidAudioFlags.none,
      usage: AndroidAudioUsage.media,
    ),
    androidAudioFocusGainType: AndroidAudioFocusGainType.gainTransientMayDuck,
    androidWillPauseWhenDucked: true,
  ));
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.nikita.interval_timer.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );

  _themeMode = SettingsService.isDarkMode ? ThemeMode.dark : ThemeMode.light;

  runApp(const MyApp());
}

Future<void> initialise() async {
  final box = Hive.box("settings");
  if (box.get("language") == null) {
    await SettingsService.setLanguage("system");
  }
  if (box.get("sound") == null) {
    await SettingsService.setSound(SettingsService.defaultSound);
  }
  if (box.get("darkmode") == null) {
    await SettingsService.setDarkMode(
        SchedulerBinding.instance.platformDispatcher.platformBrightness ==
            Brightness.dark);
  }

  // Copy lock screen art to documents directory
  Directory docDir = await getApplicationDocumentsDirectory();
  if (!await File('${docDir.path}/pause.png').exists()) {
    await copyAssetToFile("assets/images/pause.png", "pause.png");
  }
  if (!await File('${docDir.path}/training.png').exists()) {
    await copyAssetToFile("assets/images/training.png", "training.png");
  }
}

Future<String> copyAssetToFile(
  String assetPath,
  String tempFileName,
) async {
  ByteData data = await rootBundle.load(assetPath);
  List<int> bytes = data.buffer.asUint8List();

  Directory docDir = await getApplicationDocumentsDirectory();
  String tempFilePath = '${docDir.path}/$tempFileName';

  await File(tempFilePath).writeAsBytes(bytes);

  return tempFilePath;
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

  // ignore: library_private_types_in_public_api
  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> {
  Locale? _locale = _resolveLocale(SettingsService.language);

  static Locale? _resolveLocale(String language) {
    if (language == "system") return null;
    return Locale(language);
  }

  void setLocale(Locale? value) {
    setState(() {
      _locale = value;
      SettingsService.setLanguage(value?.languageCode ?? "system");
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Interval Timer',
      debugShowCheckedModeBanner: false,
      locale: _locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supported in supportedLocales) {
          if (supported.languageCode == locale?.languageCode) {
            return supported;
          }
        }
        return const Locale('en');
      },
      theme: ThemeData(
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: lightNeutral900,
          selectionColor: lightNeutral900,
          selectionHandleColor: lightNeutral900,
        ),
        scaffoldBackgroundColor: lightNeutral100,
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: lightNeutral0,
        ),
        appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            titleTextStyle: TextStyle(color: Colors.black),
            iconTheme: IconThemeData(color: Colors.black),
            centerTitle: false),
        iconTheme: const IconThemeData(color: lightNeutral900),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            backgroundColor: lightNeutral850,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme),
        extensions: const [AppColors.light],
      ),
      darkTheme: ThemeData(
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: darkNeutral900,
          selectionColor: darkNeutral900,
          selectionHandleColor: darkNeutral900,
        ),
        scaffoldBackgroundColor: darkNeutral0,
        bottomNavigationBarTheme:
            const BottomNavigationBarThemeData(backgroundColor: darkNeutral100),
        appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            titleTextStyle: TextStyle(color: Colors.black),
            centerTitle: false,
            shadowColor: Colors.transparent),
        iconTheme: const IconThemeData(color: darkNeutral900),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            backgroundColor: darkNeutral850,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme),
        extensions: const [AppColors.dark],
      ), // standard dark theme
      themeMode: _themeMode, // device controls theme
      home: SettingsService.isJumpInVisible
          ? const Home(screenIndex: 1, visible: true)
          : const Home(screenIndex: 0),
    );
  }

  void changeTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
    SettingsService.setDarkMode(themeMode == ThemeMode.dark);
  }
}
