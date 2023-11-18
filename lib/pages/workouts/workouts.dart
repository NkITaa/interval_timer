import 'package:flutter/material.dart';
import 'package:interval_timer/pages/workouts/components/workout_list.dart';
import 'package:interval_timer/pages/workouts/components/workout_searchbar.dart';
import 'package:interval_timer/pages/workouts/components/workouts_appbar.dart';

class Workouts extends StatefulWidget {
  final ScrollController controller;
  const Workouts({super.key, required this.controller});

  @override
  State<Workouts> createState() => _WorkoutsState();
}

class _WorkoutsState extends State<Workouts> {
  setListState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: WorkoutsAppbar(
          setListState: setListState,
        ),
        body: Container(
            margin: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: SingleChildScrollView(
              controller: widget.controller,
              child: Column(
                children: [
                  WorkoutSearchBar(),
                  WorkoutList(
                    setListState: setListState,
                  ),
                ],
              ),
            )));
  }
}
