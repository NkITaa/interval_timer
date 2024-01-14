import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:interval_timer/pages/home.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:interval_timer/workout.dart';
import 'const.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:audio_session/audio_session.dart';

late ThemeMode? _themeMode;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Hive.registerAdapter(WorkoutAdapter());

  await Hive.initFlutter();
  await Hive.openBox("workouts");
  await Hive.openBox("settings");
  await initialise();

  //audio_session INSTANCE
  final session = await AudioSession.instance;
  //audio_session DUCK OTHERS CONFIGURATION
  await session.configure(const AudioSessionConfiguration(
    avAudioSessionCategory: AVAudioSessionCategory.playback,
    avAudioSessionCategoryOptions: AVAudioSessionCategoryOptions.duckOthers,
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
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );

  _themeMode =
      Hive.box("settings").get("darkmode") ? ThemeMode.dark : ThemeMode.light;

  runApp(Phoenix(
    child: const MyApp(),
  ));
}

Future<void> initialise() async {
  if (Hive.box("settings").get("language") == null) {
    await Hive.box("settings").put("language", "en");
  }
  if (Hive.box("settings").get("sound") == null) {
    await Hive.box("settings").put("sound", "assets/sounds/Countdown1.mp3");
  }
  if (Hive.box("settings").get("darkmode") == null) {
    await Hive.box("settings").put(
        "darkmode",
        SchedulerBinding.instance.platformDispatcher.platformBrightness ==
            Brightness.dark);
  }

  Directory docDir = await getApplicationDocumentsDirectory();

  if (!await File('${docDir.path}/30min.mp3').exists()) {
    await copyAssetToFile("assets/sounds/30min.mp3", "30min.mp3");
  }
  if (!await File('${docDir.path}/10min.mp3').exists()) {
    await copyAssetToFile("assets/sounds/10min.mp3", "10min.mp3");
  }
  if (!await File('${docDir.path}/5min.mp3').exists()) {
    await copyAssetToFile("assets/sounds/5min.mp3", "5min.mp3");
  }
  if (!await File('${docDir.path}/1min.mp3').exists()) {
    await copyAssetToFile("assets/sounds/1min.mp3", "1min.mp3");
  }
  if (!await File('${docDir.path}/30sec.mp3').exists()) {
    await copyAssetToFile("assets/sounds/30sec.mp3", "30sec.mp3");
  }
  if (!await File('${docDir.path}/10sec.mp3').exists()) {
    await copyAssetToFile("assets/sounds/10sec.mp3", "10sec.mp3");
  }
  if (!await File('${docDir.path}/5sec.mp3').exists()) {
    await copyAssetToFile("assets/sounds/5sec.mp3", "5sec.mp3");
  }
  if (!await File('${docDir.path}/1sec.mp3').exists()) {
    await copyAssetToFile("assets/sounds/1sec.mp3", "1sec.mp3");
  }
  if (!await File('${docDir.path}/Countdown1.mp3').exists()) {
    await copyAssetToFile("assets/sounds/Countdown1.mp3", "Countdown1.mp3");
  }
  if (!await File('${docDir.path}/Countdown2.mp3').exists()) {
    await copyAssetToFile("assets/sounds/Countdown2.mp3", "Countdown2.mp3");
  }
  if (!await File('${docDir.path}/Countdown3.mp3').exists()) {
    await copyAssetToFile("assets/sounds/Countdown3.mp3", "Countdown3.mp3");
  }
  if (!await File('${docDir.path}/Countdown4.mp3').exists()) {
    await copyAssetToFile("assets/sounds/Countdown4.mp3", "Countdown4.mp3");
  }
  if (!await File('${docDir.path}/Countdown5.mp3').exists()) {
    await copyAssetToFile("assets/sounds/Countdown5.mp3", "Countdown5.mp3");
  }
  if (!await File('${docDir.path}/Countdown6.mp3').exists()) {
    await copyAssetToFile("assets/sounds/Countdown6.mp3", "Countdown6.mp3");
  }
  if (!await File('${docDir.path}/Countdown7.mp3').exists()) {
    await copyAssetToFile("assets/sounds/Countdown7.mp3", "Countdown7.mp3");
  }
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
  Locale _locale = Locale(Hive.box("settings").get("language"));

  void setLocale(Locale value) {
    setState(() {
      _locale = value;
      Hive.box("settings").put("language", value.languageCode);
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
      ), // standard dark theme
      themeMode: _themeMode, // device controls theme
      home: const Home(screenIndex: 0),
    );
  }

  void changeTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
    Hive.box("settings").put("darkmode", themeMode == ThemeMode.dark);
  }

  bool isDarkMode() {
    return _themeMode == ThemeMode.dark;
  }
}
