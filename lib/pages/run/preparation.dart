import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:interval_timer/const.dart';
import 'package:interval_timer/pages/run/run.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../home.dart';

class Preparation extends StatefulWidget {
  final List<int> time;
  final int sets;
  final int currentSet;
  final int indexTime;
  const Preparation(
      {super.key,
      required this.time,
      required this.sets,
      required this.currentSet,
      required this.indexTime});

  @override
  State<Preparation> createState() => _PreparationState();
}

class _PreparationState extends State<Preparation> {
  int counter = 9;

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (counter > 1) {
        setState(() {
          counter--;
        });
      } else {
        timer.cancel();
        next();
      }
    });
  }

  next() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => Run(
              time: widget.time,
              sets: widget.sets,
              currentSet: widget.currentSet,
              indexTime: widget.indexTime,
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xffFFA24B), Color(0xffEABB2D)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
            leading: IconButton(
          icon: const Icon(TablerIcons.x),
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const Home(
                    screenIndex: 1,
                  ))),
        )),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              height: 180,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    counter.toString(),
                    style: const TextStyle(
                        fontSize: 80,
                        color: lightNeutral50,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(AppLocalizations.of(context)!.run_preparing,
                      style: const TextStyle(
                          fontSize: 26,
                          color: lightNeutral50,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            RichText(
              text: TextSpan(
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xff653200),
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.bold,
                  ),
                  text: AppLocalizations.of(context)!.run_skip,
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      next();
                    }),
            ),
          ],
        ),
      ),
    );
  }
}
