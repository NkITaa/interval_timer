import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:interval_timer/l10n/app_localizations.dart';
import '../const.dart';
import 'dialogs.dart';
import 'package:interval_timer/services/haptic_service.dart';

class IncrementDecrementButton extends StatelessWidget {
  final String type;
  final int sets;
  final Duration minutes;
  final Duration otherMinutes;
  final GlobalKey? buttonKey;
  final Function(String type, bool increment) update;
  final Function(String type, int value, bool? minute) setValue;
  const IncrementDecrementButton(
      {super.key,
      this.buttonKey,
      required this.type,
      required this.update,
      required this.setValue,
      required this.sets,
      required this.minutes,
      required this.otherMinutes});

  @override
  Widget build(BuildContext context) {
    return Container(
      key: buttonKey,
      height: 72,
      padding: const EdgeInsets.only(top: 8, bottom: 8, left: 12, right: 12),
      decoration: BoxDecoration(
        color: context.colors.cardSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
              onPressed: () {
                HapticService.light();
                update(type, false);
              },
              icon: Icon(
                TablerIcons.minus,
                color: context.colors.iconPrimary,
              )),
          SizedBox(
            width: 106,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                    type == "training"
                        ? AppLocalizations.of(context)!.training
                        : type == "pause"
                            ? AppLocalizations.of(context)!.pause
                            : AppLocalizations.of(context)!.sets,
                    style: body1Bold(context)),
                RichText(
                  text: TextSpan(
                    style: heading3Bold(context),
                    text: type != "set"
                        ? minutes.toString().substring(2, 7)
                        : sets.toString(),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                            HapticService.selection();
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) =>
                                  Dialogs.buildSetTimesDialog(
                                      context,
                                      type,
                                      minutes,
                                      otherMinutes,
                                      sets,
                                      setValue),
                            );
                          },
                  ),
                ),
              ],
            ),
          ),
          IconButton(
              onPressed: () {
                HapticService.light();
                update(type, true);
              },
              icon: Icon(
                TablerIcons.plus,
                color: context.colors.iconPrimary,
              )),
        ],
      ),
    );
  }
}
