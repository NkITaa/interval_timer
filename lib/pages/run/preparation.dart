import 'dart:async';

import 'package:flutter/material.dart';
import 'package:interval_timer/pages/run/run.dart';

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
  int counter = 2;

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (counter > 0) {
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
          title: const Text('Preparation'),
        ),
        body: Center(
          child: Text(counter.toString()),
        ),
      ),
    );
  }
}
