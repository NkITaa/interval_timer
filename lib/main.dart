import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:interval_timer/pages/home.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:interval_timer/workout.dart';
import 'const.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

late ThemeMode? _themeMode;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Hive.registerAdapter(WorkoutAdapter());
  await Hive.initFlutter();
  await Hive.openBox("workouts");
  await Hive.openBox("settings");

  if (Hive.box("settings").get("language") == null) {
    await Hive.box("settings").put("language", "en");
  }

  if (Hive.box("settings").get("darkmode") == null) {
    await Hive.box("settings").put(
        "darkmode",
        SchedulerBinding.instance.platformDispatcher.platformBrightness ==
            Brightness.dark);
  }
  _themeMode =
      Hive.box("settings").get("darkmode") ? ThemeMode.dark : ThemeMode.light;
  if (Hive.box("settings").get("sound") == null) {
    await Hive.box("settings").put("sound", "assets/sounds/Countdown 1.mp3");
  }

  runApp(const MyApp());
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
