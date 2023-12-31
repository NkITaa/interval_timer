import 'dart:math';

import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:interval_timer/const.dart';
import 'package:interval_timer/main.dart';
import 'package:interval_timer/pages/home.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

class Congrats extends StatefulWidget {
  final int duration;
  const Congrats({super.key, required this.duration});

  @override
  State<Congrats> createState() => _CongratsState();
}

class _CongratsState extends State<Congrats> {
  ConfettiController controller =
      ConfettiController(duration: const Duration(seconds: 10));

  @override
  void initState() {
    super.initState();
    controller.play();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 30,
                  ),
                  ConfettiWidget(
                    confettiController: controller,
                    blastDirection: -pi / 2,
                  ),
                ],
              ),
              IconButton(
                onPressed: () => controller.play(),
                iconSize: 64,
                icon: Icon(
                  TablerIcons.trophy,
                  color: MyApp.of(context).isDarkMode()
                      ? darkNeutral850
                      : lightNeutral700,
                ),
              ),
              const SizedBox(
                height: 48,
              ),
              Text(
                AppLocalizations.of(context)!.run_finish_one,
                style: body1Bold(context),
              ),
              Text(
                "${AppLocalizations.of(context)!.run_finish_two}${(widget.duration / 60).floor()}:${(widget.duration % 60).toString().padLeft(2, '0')} ",
                style: body1(context),
              ),
              const SizedBox(
                height: 48,
              ),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const Home(screenIndex: 1)));
                  },
                  child: Text(AppLocalizations.of(context)!.run_home,
                      style: body1Bold(context).copyWith(
                          color: MyApp.of(context).isDarkMode()
                              ? darkNeutral50
                              : lightNeutral50)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
