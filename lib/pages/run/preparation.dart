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
    Timer.periodic(Duration(seconds: 1), (timer) {
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Preparation'),
      ),
      body: Center(
        child: Text(counter.toString()),
      ),
    );
  }
}
