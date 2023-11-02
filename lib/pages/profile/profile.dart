import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../main.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.title_profile),),
      body: Column(
        children: [
          const Text("data"),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                  onPressed: () => MyApp.of(context).changeTheme(ThemeMode.light),
                  child: const Text('Light')),
              ElevatedButton(
                  onPressed: () => MyApp.of(context).changeTheme(ThemeMode.dark),
                  child: const Text('Dark')),
            ],
          ),
        ],
      ),
    );
  }
}
