import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../main.dart';

class Workouts extends StatelessWidget {
  const Workouts({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.title_workouts),),
      body: Column(
        children: [
          const Text("data"),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                  onPressed: () => MyApp.of(context).changeTheme(ThemeMode.light),
                  child: Text('Light')),
              ElevatedButton(
                  onPressed: () => MyApp.of(context).changeTheme(ThemeMode.dark),
                  child: Text('Dark')),
            ],
          ),
        ],
      ),
    );
  }
}
