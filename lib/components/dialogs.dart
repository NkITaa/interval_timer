import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:interval_timer/pages/run/congrats.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:interval_timer/components/custom_textbox.dart';
import 'package:interval_timer/components/time_wheel.dart';
import 'package:interval_timer/components/workout_times_container.dart';
import 'package:hive/hive.dart';
import 'package:interval_timer/services/settings_service.dart';
import 'package:interval_timer/workout.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:interval_timer/l10n/app_localizations.dart';
import 'package:just_audio/just_audio.dart';
import '../const.dart';
import '../main.dart';
import '../pages/home.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class Dialogs {
  /// Shared dialog header with title and close button.
  static Widget _dialogHeader(BuildContext context, String title,
      {TextStyle? titleStyle}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: titleStyle ?? heading3Bold(context)),
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            TablerIcons.x,
            color: context.colors.subtleElement,
          ),
        ),
      ],
    );
  }

  /// Shared backdrop blur wrapper for all dialogs.
  static Widget _blurredDialog({required Widget child}) {
    return _blurredDialog(
      child: child,
    );
  }

  /// Shared update/setValue logic for workout time editing.
  static ({Function(String, bool) update, Function(String, int, bool?) setValue})
      _workoutHelpers({
    required StateSetter setState,
    required Duration Function() getTraining,
    required void Function(Duration) setTraining,
    required Duration Function() getPause,
    required void Function(Duration) setPause,
    required int Function() getSets,
    required void Function(int) setSets,
    required void Function() updateTime,
  }) {
    update(String type, bool increment) {
      if (increment) {
        if (type == "training" && getTraining().inSeconds < 3585) {
          setTraining(getTraining() + const Duration(seconds: 15));
        } else if (type == "pause" && getPause().inSeconds < 3585) {
          setPause(getPause() + const Duration(seconds: 15));
        } else if (type == "set" && getSets() < 99) {
          setSets(getSets() + 1);
        }
      } else {
        if (type == "training" && getTraining().inSeconds > 15) {
          setTraining(getTraining() - const Duration(seconds: 15));
        } else if (type == "pause" && getPause().inSeconds > 15) {
          setPause(getPause() - const Duration(seconds: 15));
        } else if (type == "set" && getSets() > 1) {
          setSets(getSets() - 1);
        }
      }
      updateTime();
      setState(() {});
    }

    setValue(String type, int value, bool? minute) {
      if (type == "training") {
        if (minute!) {
          setTraining(Duration(
              minutes: value,
              seconds: getTraining().inSeconds.remainder(60)));
        } else {
          setTraining(Duration(
              minutes: getTraining().inMinutes.remainder(60),
              seconds: value));
        }
      } else if (type == "pause") {
        if (minute!) {
          setPause(Duration(
              minutes: value,
              seconds: getPause().inSeconds.remainder(60)));
        } else {
          setPause(Duration(
              minutes: getPause().inMinutes.remainder(60), seconds: value));
        }
      } else {
        setSets(value);
      }
      updateTime();
      setState(() {});
    }

    return (update: update, setValue: setValue);
  }

  static Widget buildAddWorkoutDialog(
    BuildContext context,
    Function setListState,
    TextEditingController nameController,
  ) {
    Duration workoutTime = const Duration(minutes: 4, seconds: 30);
    Duration minutesTraining = const Duration(minutes: 1, seconds: 15);
    Duration minutesPause = const Duration(seconds: 15);
    int sets = 3;
    return _blurredDialog(
      child: StatefulBuilder(builder: (context, setState) {
        final helpers = _workoutHelpers(
          setState: setState,
          getTraining: () => minutesTraining,
          setTraining: (v) => minutesTraining = v,
          getPause: () => minutesPause,
          setPause: (v) => minutesPause = v,
          getSets: () => sets,
          setSets: (v) => sets = v,
          updateTime: () =>
              workoutTime = (minutesPause + minutesTraining) * sets - minutesPause,
        );

        return Container(
            padding:
                const EdgeInsets.only(left: 24, right: 24, bottom: 24, top: 12),
            decoration: BoxDecoration(
              color: context.colors.scaffoldSurface,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16), topRight: Radius.circular(16)),
            ),
            child: SingleChildScrollView(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                _dialogHeader(context,
                    AppLocalizations.of(context)!.workouts_create),
                const SizedBox(
                  height: 18,
                ),
                CustomTextbox(
                  label: AppLocalizations.of(context)!.workouts_name,
                  nameController: nameController,
                ),
                WorkoutTimesContainer(
                  visible: false,
                  update: helpers.update,
                  setValue: helpers.setValue,
                  minutesTraining: minutesTraining,
                  minutesPause: minutesPause,
                  sets: sets,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    "${AppLocalizations.of(context)!.workouts_duration} ${(workoutTime.inSeconds / 60).floor()}:${(workoutTime.inSeconds % 60).toString().padLeft(2, '0')}",
                    style: body1(context),
                  ),
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
                      if (nameController.text.trim().isNotEmpty) {
                        Hive.box("workouts").add(Workout(
                            name: nameController.text.trim(),
                            secondsTraining: minutesTraining.inSeconds,
                            secondsPause: minutesPause.inSeconds,
                            sets: sets));
                        Navigator.pop(context);
                        showTopSnackBar(
                          Overlay.of(context),
                          CustomSnackBar.success(
                            backgroundColor: context.colors.success600,
                            icon: const SizedBox(),
                            maxLines: 1,
                            message:
                                AppLocalizations.of(context)!.workout_added,
                          ),
                          dismissType: DismissType.onSwipe,
                        );
                        setListState();
                      }
                    },
                    child: Text(AppLocalizations.of(context)!.save_workout,
                        style: body1Bold(context).copyWith(
                            color: context.colors.neutral50)),
                  ),
                )
              ]),
            ));
      }),
    );
  }

  static Widget buildEditWorkoutDialog(
      TextEditingController nameController,
      BuildContext context,
      Workout workout,
      int? index,
      Function? setListState) {
    Duration minutesTraining = Duration(seconds: workout.secondsTraining);
    Duration minutesPause = Duration(seconds: workout.secondsPause);
    int sets = workout.sets;
    Duration workoutTime = Duration(
            seconds:
                (minutesTraining.inSeconds + minutesPause.inSeconds) * sets) -
        Duration(seconds: minutesPause.inSeconds);
    return _blurredDialog(
      child: StatefulBuilder(builder: (context, setState) {
        final helpers = _workoutHelpers(
          setState: setState,
          getTraining: () => minutesTraining,
          setTraining: (v) => minutesTraining = v,
          getPause: () => minutesPause,
          setPause: (v) => minutesPause = v,
          getSets: () => sets,
          setSets: (v) => sets = v,
          updateTime: () =>
              workoutTime = (minutesPause + minutesTraining) * sets - minutesPause,
        );

        return Container(
            padding:
                const EdgeInsets.only(left: 24, right: 24, bottom: 24, top: 12),
            decoration: BoxDecoration(
              color: context.colors.scaffoldSurface,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16), topRight: Radius.circular(16)),
            ),
            child: SingleChildScrollView(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                _dialogHeader(
                    context,
                    index != null && setListState != null
                        ? AppLocalizations.of(context)!.workouts_edit
                        : AppLocalizations.of(context)!.workouts_save),
                const SizedBox(
                  height: 18,
                ),
                CustomTextbox(
                  label: AppLocalizations.of(context)!.workouts_name,
                  nameController: nameController,
                ),
                WorkoutTimesContainer(
                  visible: false,
                  update: helpers.update,
                  setValue: helpers.setValue,
                  minutesTraining: minutesTraining,
                  minutesPause: minutesPause,
                  sets: sets,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    "${AppLocalizations.of(context)!.workouts_duration} ${(workoutTime.inSeconds / 60).floor()}:${(workoutTime.inSeconds % 60).toString().padLeft(2, '0')}",
                    style: body1(context),
                  ),
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
                    onPressed: () async {
                      if (nameController.text.trim().isNotEmpty) {
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

                        workout.name != nameController.text.trim() ||
                                workout.secondsTraining !=
                                    minutesTraining.inSeconds ||
                                workout.secondsPause !=
                                    minutesPause.inSeconds ||
                                workout.sets != sets
                            ? showTopSnackBar(
                                Overlay.of(context),
                                CustomSnackBar.success(
                                  backgroundColor:
                                      context.colors.success600,
                                  icon: const SizedBox(),
                                  maxLines: 1,
                                  message: index != null
                                      ? AppLocalizations.of(context)!
                                          .workout_edited
                                      : AppLocalizations.of(context)!
                                          .workout_added,
                                ),
                                dismissType: DismissType.onSwipe,
                              )
                            : null;
                        Navigator.pop(context);
                      }
                    },
                    child: Text(AppLocalizations.of(context)!.save_workout,
                        style: body1Bold(context).copyWith(
                            color: context.colors.neutral50)),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                index != null && setListState != null
                    ? SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: context.colors.cardSurface,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            side: BorderSide(
                                width: 1,
                                color: context.colors.error600),
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
                                color: context.colors.error600,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                  AppLocalizations.of(context)!.workouts_delete,
                                  style: body1Bold(context).copyWith(
                                      color: context.colors.error600)),
                            ],
                          ),
                        ),
                      )
                    : const SizedBox(),
              ]),
            ));
      }),
    );
  }

  static Widget buildSetTimesDialog(
      BuildContext context,
      String type,
      Duration minutes,
      Duration otherMinutes,
      int sets,
      Function(String type, int value, bool? minute) setValue) {
    late int workoutTime = (minutes.inSeconds + otherMinutes.inSeconds) * sets -
        (type == "training" ? otherMinutes.inSeconds : minutes.inSeconds);

    return _blurredDialog(
      child: AlertDialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          backgroundColor:
              context.colors.scaffoldSurface,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          titlePadding:
              const EdgeInsets.only(left: 24, right: 12, bottom: 4, top: 12),
          title: _dialogHeader(
              context,
              type == "set"
                  ? AppLocalizations.of(context)!.workout_sets
                  : type == "pause"
                      ? AppLocalizations.of(context)!.workout_pause_time
                      : AppLocalizations.of(context)!.workout_training_time),
          content: StatefulBuilder(builder: (context, setState) {
            void updateTime(Duration minutes, Duration otherMinutes, int sets) {
              workoutTime =
                  (minutes.inSeconds + otherMinutes.inSeconds) * sets -
                      (type == "training"
                          ? otherMinutes.inSeconds
                          : minutes.inSeconds);
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

            return Container(
              decoration: BoxDecoration(
                color: context.colors.scaffoldSurface,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16)),
              ),
              height: 336,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  type != "set"
                      ? Container(
                          decoration: BoxDecoration(
                            color: context.colors.cardSurface,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(16)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TimeWheel(
                                type: type,
                                value: minutes.inMinutes.remainder(60),
                                otherValue: minutes.inSeconds.remainder(60),
                                setValue: setValue,
                                minute: true,
                                setValueLocal: setValueLocal,
                              ),
                              const SizedBox(width: 18),
                              Text(":",
                                  style: TextStyle(
                                      fontSize: 32,
                                      color: context.colors.neutral900)),
                              const SizedBox(width: 18),
                              TimeWheel(
                                type: type,
                                value: minutes.inSeconds.remainder(60),
                                otherValue: minutes.inMinutes.remainder(60),
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
                  const SizedBox(height: 12),
                  Text(
                    "${AppLocalizations.of(context)!.workouts_duration} ${(workoutTime / 60).floor()}:${(workoutTime % 60).toString().padLeft(2, '0')}",
                    style: body1(context),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                            type == "set"
                                ? AppLocalizations.of(context)!
                                    .workout_sets_save
                                : type == "pause"
                                    ? AppLocalizations.of(context)!
                                        .workout_pause_time_save
                                    : AppLocalizations.of(context)!
                                        .workout_training_time_save,
                            style: body1Bold(context).copyWith(
                                color: context.colors.neutral50))),
                  ),
                ],
              ),
            );
          })),
    );
  }

  static Widget buildDeleteDialog(context, index, setListState) {
    return _blurredDialog(
      child: AlertDialog(
        surfaceTintColor: Colors.transparent,
        backgroundColor:
            context.colors.scaffoldSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        titlePadding:
            const EdgeInsets.only(left: 24, right: 12, top: 12, bottom: 0),
        title: _dialogHeader(
            context, AppLocalizations.of(context)!.workouts_delete),
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(AppLocalizations.of(context)!.workouts_delete_confirm,
                style: body1(context)),
            const SizedBox(
              height: 24,
            ),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.colors.error700,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    Hive.box("workouts").deleteAt(index);
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => const Home(screenIndex: 0)),
                      (route) => false,
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(TablerIcons.trash,
                          size: 24,
                          color: context.colors.textOnGradient),
                      const SizedBox(width: 8),
                      Text(AppLocalizations.of(context)!.workouts_delete,
                          style: body1Bold(context).copyWith(
                              color: context.colors.textOnGradient)),
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
                      backgroundColor: context.colors.cardSurface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      side: BorderSide(
                          width: 1,
                          color: context.colors.neutral300),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                        AppLocalizations.of(context)!.workouts_delete_cancel,
                        style: body1Bold(context)))),
          ],
        ),
      ),
    );
  }

  static Widget buildChangeLanguageDialog(
      BuildContext context, Function setStateParent) {
    String language = SettingsService.language;

    return _blurredDialog(
      child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        return Container(
          decoration: BoxDecoration(
            color:
                context.colors.cardSurface,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16), topRight: Radius.circular(16)),
          ),
          padding:
              const EdgeInsets.only(left: 24, right: 24, bottom: 24, top: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _dialogHeader(context,
                  AppLocalizations.of(context)!.system_language),
              const SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 24,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 2.0),
                        child: Text(AppLocalizations.of(context)!.german,
                            style: body1(context)),
                      ),
                      Radio(
                        activeColor: context.colors.iconPrimary,
                        value: "de",
                        groupValue: language,
                        onChanged: (value) {
                          language = value.toString();
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 24,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 2.0),
                        child: Text(AppLocalizations.of(context)!.english,
                            style: body1(context)),
                      ),
                      Radio(
                        activeColor: context.colors.iconPrimary,
                        value: "en",
                        groupValue: language,
                        onChanged: (value) {
                          language = value.toString();
                          setState(() {});
                        },
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                    onPressed: () {
                      MyApp.of(context).setLocale(Locale(language));
                      Navigator.pop(context);
                    },
                    child: Text(
                      AppLocalizations.of(context)!.confirm,
                      style: body1Bold(context).copyWith(
                          color: context.colors.neutral50),
                    )),
              )
            ],
          ),
        );
      }),
    );
  }

  static Widget buildChangeSoundDialog(
      AudioPlayer player, BuildContext context, Function setStateParent) {
    String sound = SettingsService.sound;
    final List<int> soundIndexes = List.generate(7, (index) => index + 1);
    int selectedIndex =
        sound.length > 3 ? int.parse(sound.substring(23, 24)) - 1 : 0;

    return _blurredDialog(
      child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        return Container(
          decoration: BoxDecoration(
            color:
                context.colors.neutral50,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16), topRight: Radius.circular(16)),
          ),
          padding:
              const EdgeInsets.only(left: 24, right: 24, bottom: 24, top: 12),
          height: 638,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _dialogHeader(
                  context,
                  AppLocalizations.of(context)!.profile_settings_sound_dialog,
                  titleStyle: heading3Bold(context).copyWith(
                      color: context.colors.neutral900)),
              const SizedBox(
                height: 16,
              ),
              Container(
                decoration: BoxDecoration(
                  color: context.colors.cardSurface,
                  borderRadius: const BorderRadius.all(Radius.circular(16)),
                ),
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                  leading: Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Icon(
                      TablerIcons.music,
                      color: context.colors.neutral600,
                    ),
                  ),
                  title: Text(AppLocalizations.of(context)!.countdown,
                      style: body1(context).copyWith(
                          color: context.colors.bodyText)),
                  trailing: Padding(
                    padding: const EdgeInsets.only(right: 4.0),
                    child: Switch(
                        trackOutlineColor: WidgetStateProperty.all<Color>(
                            Colors.transparent),
                        inactiveThumbColor: Colors.white,
                        thumbColor: WidgetStateProperty.all<Color>(
                          Colors.white,
                        ),
                        trackColor: WidgetStateProperty.resolveWith<Color?>(
                          (Set<WidgetState> states) {
                            if (states.contains(WidgetState.selected)) {
                              return Theme.of(context).brightness == Brightness.dark
                                  ? const Color(0xff5F8DEE)
                                  : const Color(0xff3772EE);
                            }
                            return null;
                          },
                        ),
                        inactiveTrackColor: context.colors.subtleElement,
                        value: sound != "off" ? true : false,
                        onChanged: (selected) {
                          if (selected) {
                            sound = "assets/sounds/Countdown1.mp3";
                          } else {
                            player.stop();
                            sound = "off";
                          }
                          SettingsService.setSound(sound);
                          selectedIndex = 0;
                          setState(() {});
                        }),
                  ),
                ),
              ),
              sound != "off"
                  ? Column(
                      children: [
                        const SizedBox(
                          height: 12,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: context.colors.cardSurface,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(16),
                              )),
                          child: ListView.builder(
                            itemCount: soundIndexes.length,
                            padding: const EdgeInsets.all(0),
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              return ListTile(
                                leading: Icon(TablerIcons.player_play,
                                    color: context.colors.neutral600),
                                title: Text(
                                  'Sound ${soundIndexes[index]}',
                                  style: selectedIndex == index
                                      ? body1Bold(context).copyWith(
                                          color: context.colors.bodyText)
                                      : body1(context).copyWith(
                                          color: context.colors.bodyText),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 0),
                                trailing: Radio(
                                  activeColor: context.colors.iconPrimary,
                                  fillColor: WidgetStateProperty.all(
                                      context.colors.iconPrimary),
                                  value:
                                      "assets/sounds/Countdown${soundIndexes[index]}.mp3",
                                  groupValue: sound,
                                  onChanged: (value) async {
                                    sound = value.toString();
                                    selectedIndex = index;
                                    setState(() {});
                                    await player
                                        .setAudioSource(AudioSource.asset(sound,
                                            tag: MediaItem(
                                              id: sound,
                                              title:
                                                  'Sound ${soundIndexes[index]}',
                                            )));
                                    await player.play();
                                  },
                                ),
                                onTap: () async {
                                  sound =
                                      "assets/sounds/Countdown${soundIndexes[index]}.mp3";
                                  selectedIndex = index;
                                  setState(() {});
                                  await player
                                      .setAudioSource(AudioSource.asset(sound,
                                          tag: MediaItem(
                                            id: sound,
                                            title:
                                                'Sound ${soundIndexes[index]}',
                                          )));
                                  await player.play();
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    )
                  : const SizedBox(),
              sound != "off"
                  ? const SizedBox()
                  : Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                          AppLocalizations.of(context)!.countdown_description,
                          style: body3(context)),
                    ),
              const SizedBox(
                height: 24,
              ),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      await SettingsService.setSound(sound);
                    },
                    child: Text(
                      AppLocalizations.of(context)!.confirm,
                      style: body1Bold(context).copyWith(
                          color: context.colors.neutral50),
                    )),
              )
            ],
          ),
        );
      }),
    );
  }

  static Widget buildExitDialog(context, player, time, sets, duration) {
    return _blurredDialog(
      child: AlertDialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        surfaceTintColor: Colors.transparent,
        backgroundColor:
            context.colors.scaffoldSurface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(AppLocalizations.of(context)!.run_exit_workout),
            IconButton(
                padding: const EdgeInsets.all(0),
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  size: 24,
                  TablerIcons.x,
                  color: context.colors.subtleElement,
                )),
          ],
        ),
        titleTextStyle: heading3Bold(context),
        titlePadding: const EdgeInsets.only(top: 8, left: 24, right: 12),
        content: SizedBox(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(AppLocalizations.of(context)!.run_exit_workout_info,
                  style: body1(context)),
              const SizedBox(
                height: 24,
              ),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.colors.neutral850,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () async {
                      await player.dispose();
                      await WakelockPlus.disable();

                      SchedulerBinding.instance.addPostFrameCallback((_) {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => Congrats(
                                    time: time,
                                    didIt: false,
                                    sets: sets,
                                    duration: duration,
                                  )),
                          (route) => false,
                        );
                      });
                    },
                    child: Text(AppLocalizations.of(context)!.run_exit_workout,
                        style: body1Bold(context).copyWith(
                            color: context.colors.neutral50))),
              ),
              const SizedBox(
                height: 12,
              ),
              SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.colors.cardSurface,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                        side: BorderSide(
                            width: 1,
                            color: context.colors.neutral300),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                          AppLocalizations.of(context)!.run_resume_workout,
                          style: body1Bold(context)))),
            ],
          ),
        ),
      ),
    );
  }
}
