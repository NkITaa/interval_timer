import 'dart:math';

import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:interval_timer/const.dart';

import 'package:interval_timer/pages/home.dart';
import 'package:interval_timer/l10n/app_localizations.dart';
import 'package:interval_timer/services/haptic_service.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

import '../../components/dialogs.dart';
import '../../workout.dart';

class Congrats extends StatefulWidget {
  final int duration;
  final List<int> time;
  final int sets;
  final bool didIt;
  const Congrats(
      {super.key,
      required this.time,
      required this.sets,
      required this.didIt,
      required this.duration});

  @override
  State<Congrats> createState() => _CongratsState();
}

class _CongratsState extends State<Congrats> {
  ConfettiController controller =
      ConfettiController(duration: const Duration(seconds: 10));

  @override
  void initState() {
    if (widget.didIt) {
      controller.play();
      HapticService.heavy();
    }
    super.initState();
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
                  color: context.colors.iconPrimary,
                ),
              ),
              const SizedBox(
                height: 48,
              ),
              Text(
                AppLocalizations.of(context)!.run_finish_one,
                style: body1Bold(context),
              ),
              const SizedBox(
                height: 4,
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
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => const Home(screenIndex: 1)),
                      (route) => false,
                    );
                  },
                  child: Text(AppLocalizations.of(context)!.run_home,
                      style: body1Bold(context).copyWith(
                          color: context.colors.neutral50)),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.colors.cardSurface,
                        side: BorderSide(
                            width: 1,
                            color: context.colors.neutral300),
                      ),
                      onPressed: () {
                        TextEditingController nameController =
                            TextEditingController(text: "");
                        showModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          isScrollControlled: true,
                          enableDrag: false,
                          context: context,
                          builder: (BuildContext context) =>
                              Dialogs.buildEditWorkoutDialog(
                                  nameController,
                                  context,
                                  Workout(
                                      secondsTraining: widget.time[0],
                                      secondsPause: widget.time[1],
                                      sets: widget.sets,
                                      name: ""),
                                  null,
                                  null),
                        );
                      },
                      child: Text(
                        AppLocalizations.of(context)!.jump_in_save_workout,
                        style: body1Bold(context),
                      ))),
            ],
          ),
        ),
      ),
    );
  }
}
