import 'package:flutter/material.dart';
import 'package:interval_timer/components/custom_textbox.dart';
import 'package:interval_timer/components/time_wheel.dart';
import 'package:interval_timer/components/workout_times_container.dart';
import 'package:hive/hive.dart';
import 'package:interval_timer/workout.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:audioplayers/audioplayers.dart';
import '../const.dart';
import '../main.dart';
import '../pages/home.dart';

class Dialogs {
  static Widget buildAddWorkoutDialog(
      BuildContext context, Function setListState) {
    Duration workoutTime = const Duration(minutes: 4, seconds: 30);
    Duration minutesTraining = const Duration(minutes: 1, seconds: 15);
    Duration minutesPause = const Duration(seconds: 15);
    TextEditingController nameController = TextEditingController();
    int sets = 3;
    final formKey = GlobalKey<FormState>();

    return StatefulBuilder(builder: (context, setState) {
      void updateTime(Duration pause, Duration training, int sets) {
        workoutTime = (pause + training) * sets;
        setState(() {});
      }

      update(String type, bool increment) {
        if (increment) {
          if (type == "training" && minutesTraining.inSeconds < 3585) {
            minutesTraining = minutesTraining + const Duration(seconds: 15);
          } else if (type == "pause" && minutesPause.inSeconds < 3585) {
            minutesPause = minutesPause + const Duration(seconds: 15);
          } else if (type == "set" && sets < 99) {
            sets = sets + 1;
          }
        } else {
          if (type == "training" && minutesTraining.inSeconds > 15) {
            minutesTraining = minutesTraining - const Duration(seconds: 15);
          } else if (type == "pause" && minutesPause.inSeconds > 15) {
            minutesPause = minutesPause - const Duration(seconds: 15);
          } else if (type == "set" && sets > 1) {
            sets = sets - 1;
          }
        }
        updateTime(minutesPause, minutesTraining, sets);
        setState(() {});
      }

      setValue(String type, int value, bool? minute) {
        if (type == "training") {
          if (minute!) {
            minutesTraining = Duration(
                minutes: value,
                seconds: minutesTraining.inSeconds.remainder(60));
          } else {
            minutesTraining = Duration(
                minutes: minutesTraining.inMinutes.remainder(60),
                seconds: value);
          }
        } else if (type == "pause") {
          if (minute!) {
            minutesPause = Duration(
                minutes: value, seconds: minutesPause.inSeconds.remainder(60));
          } else {
            minutesPause = Duration(
                minutes: minutesPause.inMinutes.remainder(60), seconds: value);
          }
        } else {
          sets = value;
        }
        updateTime(minutesPause, minutesTraining, sets);
        setState(() {});
      }

      return Container(
          padding: const EdgeInsets.all(24),
          height: 584,
          decoration: BoxDecoration(
            color:
                MyApp.of(context).isDarkMode() ? darkNeutral0 : lightNeutral100,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: Form(
            key: formKey,
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(AppLocalizations.of(context)!.workouts_create,
                      style: TextStyle(
                        color: MyApp.of(context).isDarkMode()
                            ? darkNeutral900
                            : lightNeutral900,
                        fontSize: 24,
                      )),
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        TablerIcons.x,
                      )),
                ],
              ),
              CustomTextbox(
                label: AppLocalizations.of(context)!.workouts_name,
                nameController: nameController,
              ),
              WorkoutTimesContainer(
                update: update,
                setValue: setValue,
                minutesTraining: minutesTraining,
                minutesPause: minutesPause,
                sets: sets,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                    "${AppLocalizations.of(context)!.workouts_duration} ${workoutTime.toString().substring(2, 7)}"),
              ),
              const SizedBox(
                height: 8,
              ),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      Hive.box("workouts").add(Workout(
                          name: nameController.text.trim(),
                          secondsTraining: minutesTraining.inSeconds,
                          secondsPause: minutesPause.inSeconds,
                          sets: sets));
                      Navigator.pop(context);
                      setListState();
                    }
                  },
                  child: Text(AppLocalizations.of(context)!.save_workout,
                      style: const TextStyle(fontSize: 16)),
                ),
              )
            ]),
          ));
    });
  }

  static Widget buildEditWorkoutDialog(BuildContext context, Workout workout,
      int? index, Function? setListState) {
    Duration minutesTraining = Duration(seconds: workout.secondsTraining);
    Duration minutesPause = Duration(seconds: workout.secondsPause);
    TextEditingController nameController =
        TextEditingController(text: workout.name);
    int sets = workout.sets;
    Duration workoutTime = Duration(
        seconds: (minutesTraining.inSeconds + minutesPause.inSeconds) * sets);
    final formKey = GlobalKey<FormState>();

    return StatefulBuilder(builder: (context, setState) {
      void updateTime(Duration pause, Duration training, int sets) {
        workoutTime = (pause + training) * sets;
      }

      update(String type, bool increment) {
        if (increment) {
          if (type == "training" && minutesTraining.inSeconds < 3585) {
            minutesTraining = minutesTraining + const Duration(seconds: 15);
          } else if (type == "pause" && minutesPause.inSeconds < 3585) {
            minutesPause = minutesPause + const Duration(seconds: 15);
          } else if (type == "set" && sets < 99) {
            sets = sets + 1;
          }
        } else {
          if (type == "training" && minutesTraining.inSeconds > 15) {
            minutesTraining = minutesTraining - const Duration(seconds: 15);
          } else if (type == "pause" && minutesPause.inSeconds > 15) {
            minutesPause = minutesPause - const Duration(seconds: 15);
          } else if (type == "set" && sets > 1) {
            sets = sets - 1;
          }
        }
        updateTime(minutesPause, minutesTraining, sets);
        setState(() {});
      }

      setValue(String type, int value, bool? minute) {
        if (type == "training") {
          if (minute!) {
            minutesTraining = Duration(
                minutes: value,
                seconds: minutesTraining.inSeconds.remainder(60));
          } else {
            minutesTraining = Duration(
                minutes: minutesTraining.inMinutes.remainder(60),
                seconds: value);
          }
        } else if (type == "pause") {
          if (minute!) {
            minutesPause = Duration(
                minutes: value, seconds: minutesPause.inSeconds.remainder(60));
          } else {
            minutesPause = Duration(
                minutes: minutesPause.inMinutes.remainder(60), seconds: value);
          }
        } else {
          sets = value;
        }
        updateTime(minutesPause, minutesTraining, sets);
        setState(() {});
      }

      return Form(
        key: formKey,
        child: Container(
            padding: const EdgeInsets.all(24),
            height: 626,
            decoration: BoxDecoration(
              color: MyApp.of(context).isDarkMode()
                  ? darkNeutral0
                  : lightNeutral100,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.workouts_edit,
                    style: TextStyle(
                      color: MyApp.of(context).isDarkMode()
                          ? darkNeutral900
                          : lightNeutral900,
                      fontSize: 24,
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        TablerIcons.x,
                      )),
                ],
              ),
              CustomTextbox(
                label: AppLocalizations.of(context)!.workouts_name,
                nameController: nameController,
              ),
              WorkoutTimesContainer(
                update: update,
                setValue: setValue,
                minutesTraining: minutesTraining,
                minutesPause: minutesPause,
                sets: sets,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                    "${AppLocalizations.of(context)!.workouts_duration} ${workoutTime.toString().substring(2, 7)}"),
              ),
              const SizedBox(
                height: 12,
              ),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      index != null
                          ? Hive.box("workouts").putAt(
                              index,
                              Workout(
                                  name: nameController.text.trim(),
                                  secondsTraining: minutesTraining.inSeconds,
                                  secondsPause: minutesPause.inSeconds,
                                  sets: sets))
                          : Hive.box("workouts").add(Workout(
                              name: nameController.text.trim(),
                              secondsTraining: minutesTraining.inSeconds,
                              secondsPause: minutesPause.inSeconds,
                              sets: sets));
                      setListState != null ? setListState() : null;
                      Navigator.pop(context);
                    }
                  },
                  child: Text(AppLocalizations.of(context)!.save_workout,
                      style: const TextStyle(fontSize: 16)),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              index != null && setListState != null
                  ? SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MyApp.of(context).isDarkMode()
                              ? darkNeutral100
                              : lightNeutral0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return buildDeleteDialog(
                                  context, index, setListState);
                            },
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              TablerIcons.trash,
                              size: 24,
                              color: MyApp.of(context).isDarkMode()
                                  ? lightError600
                                  : darkError600,
                            ),
                            const SizedBox(width: 8),
                            Text(AppLocalizations.of(context)!.workouts_delete,
                                style: TextStyle(
                                    fontSize: 16,
                                    color: MyApp.of(context).isDarkMode()
                                        ? lightError600
                                        : darkError600)),
                          ],
                        ),
                      ),
                    )
                  : const SizedBox(),
            ])),
      );
    });
  }

  static Widget buildSetTimesDialog(
      BuildContext context,
      String type,
      Duration minutes,
      Duration otherMinutes,
      int sets,
      Function(String type, int value, bool? minute) setValue) {
    late int workoutTime = (minutes.inSeconds + otherMinutes.inSeconds) * sets;

    return AlertDialog(
        backgroundColor:
            MyApp.of(context).isDarkMode() ? darkNeutral0 : lightNeutral100,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(type == "set"
            ? AppLocalizations.of(context)!.workout_sets
            : type == "pause"
                ? AppLocalizations.of(context)!.workout_pause_time
                : AppLocalizations.of(context)!.workout_training_time),
        content: StatefulBuilder(builder: (context, setState) {
          void updateTime(Duration minutes, Duration otherMinutes, int sets) {
            workoutTime = (minutes.inSeconds + otherMinutes.inSeconds) * sets;
          }

          setValueLocal(String type, int value, bool? minute) {
            if (type != "set") {
              if (minute!) {
                minutes = Duration(
                    minutes: value, seconds: minutes.inSeconds.remainder(60));
              } else {
                minutes = Duration(
                    minutes: minutes.inMinutes.remainder(60), seconds: value);
              }
            } else {
              sets = value;
            }
            updateTime(minutes, otherMinutes, sets);
            setState(() {});
          }

          return SizedBox(
            height: 327,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                type != "set"
                    ? Container(
                        decoration: BoxDecoration(
                          color: MyApp.of(context).isDarkMode()
                              ? darkNeutral100
                              : lightNeutral0,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TimeWheel(
                              type: type,
                              value: minutes.inMinutes.remainder(60),
                              setValue: setValue,
                              minute: true,
                              setValueLocal: setValueLocal,
                            ),
                            const SizedBox(width: 18),
                            const Text(":", style: TextStyle(fontSize: 32)),
                            const SizedBox(width: 18),
                            TimeWheel(
                              type: type,
                              value: minutes.inSeconds.remainder(60),
                              setValue: setValue,
                              minute: false,
                              setValueLocal: setValueLocal,
                            ),
                          ],
                        ),
                      )
                    : TimeWheel(
                        type: type,
                        value: sets,
                        setValue: setValue,
                        setValueLocal: setValueLocal,
                      ),
                const SizedBox(height: 18),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                      "${AppLocalizations.of(context)!.workouts_duration} ${(workoutTime / 60).floor()}:${(workoutTime % 60).toString().padLeft(2, '0')}"),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(type == "set"
                          ? AppLocalizations.of(context)!.workout_sets_save
                          : type == "pause"
                              ? AppLocalizations.of(context)!
                                  .workout_pause_time_save
                              : AppLocalizations.of(context)!
                                  .workout_training_time_save)),
                ),
              ],
            ),
          );
        }));
  }

  static Widget buildDeleteDialog(context, index, setListState) {
    return AlertDialog(
      backgroundColor:
          MyApp.of(context).isDarkMode() ? darkNeutral0 : lightNeutral100,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Text(AppLocalizations.of(context)!.workouts_delete),
      content: SizedBox(
        height: 208,
        child: Column(
          children: [
            Text(AppLocalizations.of(context)!.workouts_delete_confirm),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MyApp.of(context).isDarkMode()
                        ? darkError700
                        : lightError700,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    Hive.box("workouts").deleteAt(index);

                    Navigator.of(context).push(MaterialPageRoute(
                        fullscreenDialog: true,
                        builder: (context) => const Home(screenIndex: 0)));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(TablerIcons.trash,
                          size: 24,
                          color: MyApp.of(context).isDarkMode()
                              ? lightNeutral100
                              : lightNeutral50),
                      const SizedBox(width: 8),
                      Text(AppLocalizations.of(context)!.workouts_delete,
                          style: TextStyle(
                              fontSize: 16,
                              color: MyApp.of(context).isDarkMode()
                                  ? lightNeutral100
                                  : lightNeutral50)),
                    ],
                  )),
            ),
            const SizedBox(
              height: 12,
            ),
            SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MyApp.of(context).isDarkMode()
                          ? darkNeutral100
                          : lightNeutral0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                        AppLocalizations.of(context)!.workouts_delete_cancel,
                        style: TextStyle(
                            fontSize: 16,
                            color: MyApp.of(context).isDarkMode()
                                ? darkNeutral900
                                : lightNeutral900)))),
          ],
        ),
      ),
    );
  }

  static Widget buildChangeLanguageDialog(
      BuildContext context, Function setStateParent) {
    String language = Hive.box("settings").get("language");

    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return Container(
        decoration: BoxDecoration(
          color:
              MyApp.of(context).isDarkMode() ? darkNeutral100 : lightNeutral0,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        padding:
            const EdgeInsets.only(left: 24, right: 24, bottom: 24, top: 12),
        height: 258,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context)!.system_language,
                  style: heading3Bold(context),
                ),
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      TablerIcons.x,
                    )),
              ],
            ),
            ListTile(
              title: const Text('Deutsch'),
              trailing: Radio(
                activeColor: MyApp.of(context).isDarkMode()
                    ? darkNeutral850
                    : lightNeutral700,
                value: "de",
                groupValue: language,
                onChanged: (value) {
                  language = value.toString();
                  setState(() {});
                },
              ),
            ),
            ListTile(
              title: const Text('English'),
              trailing: Radio(
                activeColor: MyApp.of(context).isDarkMode()
                    ? darkNeutral850
                    : lightNeutral700,
                value: "en",
                groupValue: language,
                onChanged: (value) {
                  language = value.toString();
                  setState(() {});
                },
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                  onPressed: () {
                    MyApp.of(context).setLocale(Locale(language));
                    Navigator.pop(context);
                  },
                  child: Text(AppLocalizations.of(context)!.confirm)),
            )
          ],
        ),
      );
    });
  }

  static Widget buildChangeSoundDialog(
      BuildContext context, Function setStateParent) {
    String sound = Hive.box("settings").get("sound");
    final player = AudioPlayer();
    final List<int> soundIndexes = List.generate(7, (index) => index + 1);

    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return Container(
        decoration: BoxDecoration(
          color:
              MyApp.of(context).isDarkMode() ? darkNeutral50 : lightNeutral50,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        padding:
            const EdgeInsets.only(left: 24, right: 24, bottom: 24, top: 12),
        height: 632,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context)!.system_language,
                  style: heading3Bold(context).copyWith(
                      color: MyApp.of(context).isDarkMode()
                          ? darkNeutral900
                          : lightNeutral900),
                ),
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      TablerIcons.x,
                    )),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                color: MyApp.of(context).isDarkMode()
                    ? darkNeutral100
                    : lightNeutral0,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: ListTile(
                leading: Icon(
                  TablerIcons.music,
                  color: MyApp.of(context).isDarkMode()
                      ? darkNeutral600
                      : lightNeutral600,
                ),
                title: Text(AppLocalizations.of(context)!.countdown,
                    style: TextStyle(
                        color: MyApp.of(context).isDarkMode()
                            ? darkNeutral900
                            : lightNeutral850)),
                trailing: Switch(
                    value: sound != "off" ? true : false,
                    onChanged: (selected) {
                      if (selected) {
                        sound = "sounds/Countdown 1.mp3";
                      } else {
                        player.dispose();
                        sound = "off";
                      }
                      Hive.box("settings").put("sound", sound);
                      setState(() {});
                    }),
              ),
            ),
            sound != "off"
                ? const Divider(
                    height: 0,
                    thickness: 1,
                  )
                : const SizedBox(),
            sound != "off"
                ? Container(
                    decoration: BoxDecoration(
                        color: MyApp.of(context).isDarkMode()
                            ? darkNeutral100
                            : lightNeutral0,
                        borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10))),
                    child: ListView.builder(
                      itemCount: soundIndexes.length,
                      padding: const EdgeInsets.all(0),
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          leading: Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Icon(TablerIcons.player_play,
                                color: MyApp.of(context).isDarkMode()
                                    ? darkNeutral600
                                    : lightNeutral600),
                          ),
                          title: Text(
                            'Sound ${soundIndexes[index]}',
                            style: TextStyle(
                                color: MyApp.of(context).isDarkMode()
                                    ? darkNeutral900
                                    : lightNeutral850),
                          ),
                          trailing: Radio(
                            activeColor: MyApp.of(context).isDarkMode()
                                ? darkNeutral850
                                : lightNeutral700,
                            fillColor: MaterialStateProperty.all(
                                MyApp.of(context).isDarkMode()
                                    ? darkNeutral850
                                    : lightNeutral700),
                            value:
                                "sounds/Countdown ${soundIndexes[index]}.mp3",
                            groupValue: sound,
                            onChanged: (value) async {
                              sound = value.toString();
                              await player.play(AssetSource(sound));
                              setState(() {});
                            },
                          ),
                        );
                      },
                    ),
                  )
                : const SizedBox(),
            sound != "off"
                ? const SizedBox()
                : Text(AppLocalizations.of(context)!.countdown_description,
                    style: TextStyle(
                        color: MyApp.of(context).isDarkMode()
                            ? darkNeutral900
                            : lightNeutral850)),
            const SizedBox(
              height: 16,
            ),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    await Hive.box("settings").put("sound", sound);
                  },
                  child: Text(AppLocalizations.of(context)!.confirm)),
            )
          ],
        ),
      );
    });
  }

  static Widget buildExitDialog(context, controller, player) {
    return AlertDialog(
      backgroundColor:
          MyApp.of(context).isDarkMode() ? darkNeutral0 : lightNeutral100,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Text(AppLocalizations.of(context)!.run_exit_workout),
      content: SizedBox(
        height: 208,
        child: Column(
          children: [
            Text(AppLocalizations.of(context)!.run_exit_workout_info),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MyApp.of(context).isDarkMode()
                        ? darkNeutral850
                        : lightNeutral850,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        fullscreenDialog: true,
                        builder: (context) => const Home(screenIndex: 1)));
                  },
                  child: Text(AppLocalizations.of(context)!.run_exit_workout,
                      style: TextStyle(
                          fontSize: 16,
                          color: MyApp.of(context).isDarkMode()
                              ? lightNeutral100
                              : lightNeutral50))),
            ),
            const SizedBox(
              height: 12,
            ),
            SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MyApp.of(context).isDarkMode()
                          ? darkNeutral100
                          : lightNeutral0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      controller.resume();
                    },
                    child: Text(
                        AppLocalizations.of(context)!.run_resume_workout,
                        style: TextStyle(
                            fontSize: 16,
                            color: MyApp.of(context).isDarkMode()
                                ? darkNeutral900
                                : lightNeutral900)))),
          ],
        ),
      ),
    );
  }
}
