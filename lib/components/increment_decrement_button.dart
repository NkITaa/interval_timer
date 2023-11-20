import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

import 'dialogs.dart';

class IncrementDecrementButton extends StatelessWidget {
  final String type;
  final int? sets;
  final Duration? minutes;
  final Function(String type, bool increment) update;
  final Function(String type, int value, bool? minute) setValue;
  const IncrementDecrementButton(
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
          IconButton(
              onPressed: () {
                update(type, false);
              },
              icon: const Icon(TablerIcons.minus)),
          SizedBox(
            width: 100,
            child: Column(
              children: [
                Text(type),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: Colors.black,
                    ),
                    text: type != "set"
                        ? minutes.toString().substring(2, 7)
                        : sets.toString(),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                Dialogs.buildSetTimesDialog(
                                    context, type, minutes, sets, setValue),
                          ),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
              onPressed: () {
                update(type, true);
              },
              icon: const Icon(TablerIcons.plus)),
        ],
      ),
    );
  }
}
