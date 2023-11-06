import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'dialogs.dart';

class IncrementDecrementButton extends StatelessWidget {
  final String type;
  int? sets;
  DateTime? minutes;
  final Function(String type, bool increment) update;
  final Function(String type, int value, bool? minute) setValue;
  IncrementDecrementButton(
      {super.key,
      required this.type,
      required this.update,
      required this.setValue,
      this.sets,
      this.minutes});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 8, bottom: 8, left: 12, right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: () {
              update(type, false);
            },
            child: const Text('-'),
          ),
          Container(
            width: 100,
            child: Column(
              children: [
                Text(type),
                TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.all(0),
                  ),
                  child: Text(type != "set"
                      ? DateFormat('mm:ss').format(minutes!)
                      : sets.toString()),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          Dialogs.buildSetTimesDialog(
                              context, type, minutes, sets, setValue),
                    );
                  },
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              update(type, true);
            },
            child: const Text('+'),
          ),
        ],
      ),
    );
  }
}
