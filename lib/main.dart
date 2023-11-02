import 'package:flutter/material.dart';
import 'package:interval_timer/pages/home.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'const.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Interval Timer',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(

        bottomNavigationBarTheme:
            const BottomNavigationBarThemeData(backgroundColor: lightNeutral0),
        appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            titleTextStyle: TextStyle(color: Colors.black),
            iconTheme: IconThemeData(color: Colors.black),
            centerTitle: false
        ),
        textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme),
      ),
      darkTheme: ThemeData(
        bottomNavigationBarTheme:
            const BottomNavigationBarThemeData(backgroundColor: darkNeutral100),
        appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            titleTextStyle: TextStyle(color: Colors.black),
            centerTitle: false,
            shadowColor: Colors.transparent),
        textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme),
      ), // standard dark theme
      themeMode: _themeMode, // device controls theme
      home: const Home(),
    );
  }

  void changeTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }
}
