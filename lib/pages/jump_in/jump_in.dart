import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class JumpIn extends StatelessWidget {
  const JumpIn({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.title_jump_in),
      ),
      body: const Text("data"),
    );
  }
}
