import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

import '../const.dart';
import '../main.dart';
import 'dialogs.dart';

class IncrementDecrementButton extends StatelessWidget {
  final String type;
  final int sets;
  final Duration minutes;
  final Duration otherMinutes;
  final Function(String type, bool increment) update;
  final Function(String type, int value, bool? minute) setValue;
  const IncrementDecrementButton(
      {super.key,
      required this.type,
      required this.update,
      required this.setValue,
      required this.sets,
      required this.minutes,
      required this.otherMinutes});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 8, bottom: 8, left: 12, right: 12),
      decoration: BoxDecoration(
        color: MyApp.of(context).isDarkMode() ? darkNeutral100 : lightNeutral0,
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
                Text(
                  type,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: MyApp.of(context).isDarkMode()
                        ? darkNeutral900
                        : lightNeutral900,
                  ),
                ),
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 14.0,
                      color: MyApp.of(context).isDarkMode()
                          ? darkNeutral900
                          : lightNeutral900,
                    ),
                    text: type != "set"
                        ? minutes.toString().substring(2, 7)
                        : sets.toString(),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                Dialogs.buildSetTimesDialog(context, type,
                                    minutes, otherMinutes, sets, setValue),
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
