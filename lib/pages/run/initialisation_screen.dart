import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:interval_timer/const.dart';
import 'package:interval_timer/main.dart';
import 'package:interval_timer/pages/run/preparation.dart';
import 'package:just_audio/just_audio.dart';
import '../home.dart';
import 'AudioHandler.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

class InitialisationScreen extends StatelessWidget {
  final List<int> time;
  final int sets;
  final int currentSet;
  final int indexTime;
  InitialisationScreen(
      {super.key,
      required this.time,
      required this.sets,
      required this.currentSet,
      required this.indexTime});

  final AudioPlayer player = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: initialize(player, time, sets),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            AudioReturn data = snapshot.data!;

            data.sound == "off" ? player.setVolume(0) : player.setVolume(1);

            int totalDuration = 0;
            for (int i = 0; i < sets * 2 - 1; i++) {
              totalDuration += time[i % 2];
            }

            if (data.ffmpegOutput[0] == "0" || data.ffmpegOutput[1] == "0") {
              return Preparation(
                  totalDuration: totalDuration,
                  time: time,
                  sets: sets,
                  currentSet: currentSet,
                  indexTime: indexTime,
                  player: player);
            } else {
              return const Center(
                child: Text("Not Enough Space on Device"),
              );
            }
          } else {
            return Container(
                color: MyApp.of(context).isDarkMode()
                    ? darkNeutral0
                    : lightNeutral100,
                child: Scaffold(
                    backgroundColor: Colors.transparent,
                    appBar: AppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      leading: IconButton(
                        icon: Icon(
                          TablerIcons.x,
                          color: MyApp.of(context).isDarkMode()
                              ? darkNeutral500
                              : lightNeutral300,
                        ),
                        onPressed: () async {
                          await player.dispose();
                          SchedulerBinding.instance.addPostFrameCallback((_) {
                            Navigator.of(context).pop();
                          });
                        },
                      ),
                    ),
                    body: SizedBox(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Image.asset(
                            DateTime.now().second % 2 == 0
                                ? "assets/images/boxer.gif"
                                : "assets/images/girl.gif",
                            width: 160,
                            height: 160,
                          ),
                          RichText(
                            text: TextSpan(
                                style: body1BoldUnderlined(context),
                                text: AppLocalizations.of(context)!
                                    .workouts_delete_cancel,
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () async {
                                    await player.dispose();
                                    SchedulerBinding.instance
                                        .addPostFrameCallback((_) {
                                      Navigator.of(context).pop();
                                    });
                                  }),
                          ),
                        ],
                      ),
                    )));
          }
        });
  }
}
