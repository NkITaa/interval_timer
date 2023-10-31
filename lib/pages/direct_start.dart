import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DirectStart extends StatelessWidget {
  const DirectStart({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.title_jump_in),),
      body: Text("data"),
    );
  }
}
