import 'package:flutter/material.dart';
import '../../const.dart';
import '../../main.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomTimer extends StatelessWidget {
  final int seconds;
  final int maxSeconds;
  final bool isRunning;
  final int indexTime;

  const CustomTimer(
      {super.key,
      required this.seconds,
      required this.maxSeconds,
      required this.isRunning,
      required this.indexTime});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      width: 300,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CircularProgressIndicator(
            backgroundColor: Colors.white.withOpacity(0.5),
            value: 1 - (seconds / maxSeconds),
            strokeWidth: 16,
            strokeCap: StrokeCap.round,
            valueColor: AlwaysStoppedAnimation<Color>(
                MyApp.of(context).isDarkMode()
                    ? lightNeutral100
                    : lightNeutral50),
          ),
          Align(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${((seconds) / 60).floor()}:${((seconds) % 60).toString().padLeft(2, '0')}',
                  style: display2(context).copyWith(
                      color: MyApp.of(context).isDarkMode()
                          ? lightNeutral100
                          : lightNeutral50),
                ),
                Text(
                  !isRunning
                      ? AppLocalizations.of(context)!.paused
                      : indexTime == 0
                          ? AppLocalizations.of(context)!.training
                          : AppLocalizations.of(context)!.pause,
                  style: heading1Bold(context).copyWith(
                      color: MyApp.of(context).isDarkMode()
                          ? lightNeutral100
                          : lightNeutral50),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
