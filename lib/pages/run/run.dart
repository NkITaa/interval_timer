import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:interval_timer/const.dart';

import 'package:interval_timer/pages/run/custom_timer.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:interval_timer/l10n/app_localizations.dart';
import 'package:interval_timer/pages/run/preparation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:interval_timer/services/settings_service.dart';
import 'package:interval_timer/services/haptic_service.dart';
import '../../components/dialogs.dart';
import 'congrats.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class Run extends StatefulWidget {
  final int totalDuration;
  final List<int> time;
  final int sets;
  final int currentSet;
  final int indexTime;
  final DateTime startTime;
  final AudioPlayer player;

  const Run({
    super.key,
    required this.totalDuration,
    required this.time,
    required this.sets,
    required this.currentSet,
    required this.indexTime,
    required this.startTime,
    required this.player,
  });

  @override
  State<Run> createState() => _RunState();
}

class _RunState extends State<Run> with WidgetsBindingObserver {
  final String _originalSound = SettingsService.sound;
  late String sound = _originalSound;
  late int remainderBasis = widget.totalDuration;
  bool _navigating = false;
  bool _advancing = false;
  bool _dialogOpen = false;
  bool _disposed = false;
  int _advanceVersion = 0;
  int _lastHapticSecond = -1;
  bool _userPaused = false;

  // Robustness: watchdog and error recovery
  Timer? _watchdogTimer;
  StreamSubscription<PlayerState>? _playerStateSubscription;
  DateTime _lastPositionUpdate = DateTime.now();
  int _lastPositionSeconds = -1;
  int _recoveryAttempts = 0;
  bool _recovering = false;
  static const int _maxRecoveryAttempts = 3;

  next() async {
    if (_navigating) return;
    _advanceVersion++;
    _advancing = true;
    if (widget.player.currentIndex! % 2 == 0 &&
        widget.sets == widget.player.currentIndex! ~/ 2 + 1) {
      _navigating = true;
      _disposed = true;
      _watchdogTimer?.cancel();
      _playerStateSubscription?.cancel();
      await widget.player.dispose();
      await WakelockPlus.disable();
      HapticService.success();

      if (!mounted) return;
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => Congrats(
                didIt: true,
                time: widget.time,
                sets: widget.sets,
                duration: DateTime.now().difference(widget.startTime).inSeconds,
              )));
    } else {
      HapticService.heavy();
      _lastHapticSecond = -1;
      await widget.player.seekToNext();
      int temp = 0;
      for (int i = 0; i < widget.player.currentIndex!; i++) {
        temp += widget.time[i % 2];
      }
      remainderBasis = widget.totalDuration - temp;
      _advancing = false;
      setState(() {});
    }
  }

  back() async {
    _advanceVersion++;
    _advancing = false;
    int duration = widget.player.position.inSeconds;
    if (duration > 3) {
      await widget.player.seek(Duration.zero);
      int temp = 0;
      for (int i = 0; i < widget.player.currentIndex!; i++) {
        temp += widget.time[i % 2];
      }
      remainderBasis = widget.totalDuration - temp;
      setState(() {});
    } else if (widget.player.currentIndex! % 2 == 0 &&
        widget.player.currentIndex! ~/ 2 + 1 == 1) {
      _navigating = true;
      await widget.player.stop();
      await WakelockPlus.disable();
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => Preparation(
                player: widget.player,
                totalDuration: widget.totalDuration,
                time: widget.time,
                sets: widget.sets,
                currentSet: 1,
                indexTime: 0)));
      });
    } else {
      await widget.player.seekToPrevious();
      int temp = 0;
      for (int i = 0; i < widget.player.currentIndex!; i++) {
        temp += widget.time[i % 2];
      }
      remainderBasis = widget.totalDuration - temp;
      setState(() {});
    }
  }

  void _togglePlayPause() {
    HapticService.selection();
    if (!widget.player.playerState.playing) {
      _userPaused = false;
      widget.player.play();
    } else {
      _userPaused = true;
      widget.player.pause();
    }
    setState(() {});
  }

  void _startWatchdog() {
    _watchdogTimer?.cancel();
    _watchdogTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (_disposed || _navigating || !mounted) {
        timer.cancel();
        return;
      }

      final player = widget.player;
      final isPlaying = player.playerState.playing;
      final processingState = player.playerState.processingState;

      if (!isPlaying) return;

      if (processingState == ProcessingState.ready) {
        final elapsed = DateTime.now().difference(_lastPositionUpdate);
        if (elapsed.inSeconds >= 4) {
          debugPrint('Watchdog: positionStream stall detected '
              '(no update for ${elapsed.inSeconds}s).');
          _attemptRecovery();
        }
        return;
      }

      if (processingState == ProcessingState.buffering) {
        final elapsed = DateTime.now().difference(_lastPositionUpdate);
        if (elapsed.inSeconds >= 6) {
          debugPrint('Watchdog: stuck in buffering for ${elapsed.inSeconds}s.');
          _attemptRecovery();
        }
        return;
      }

      if (processingState == ProcessingState.idle) {
        debugPrint('Watchdog: player idle but should be playing.');
        _attemptRecovery();
      }
    });
  }

  Future<void> _attemptRecovery() async {
    if (_disposed || _navigating || !mounted || _recovering || _dialogOpen) return;
    _recovering = true;

    try {
      _recoveryAttempts++;

      if (_recoveryAttempts > _maxRecoveryAttempts) {
        debugPrint(
            'Watchdog: max recovery attempts reached. Aborting workout.');
        await _navigateToCongratsWithFailure();
        return;
      }

      debugPrint(
          'Watchdog: recovery attempt $_recoveryAttempts/$_maxRecoveryAttempts');

      final player = widget.player;
      final currentPos = player.position;
      final currentIdx = player.currentIndex;

      final intendedDuration = widget.time[(currentIdx ?? 0) % 2];
      if (currentPos.inSeconds >= intendedDuration) {
        debugPrint('Watchdog: segment already complete. Advancing.');
        next();
        return;
      }

      // Pause-seek-play to restart the audio pipeline
      await player.pause();
      await player.seek(currentPos, index: currentIdx);
      await player.play();

      _lastPositionUpdate = DateTime.now();
    } catch (e) {
      debugPrint('Watchdog: recovery failed: $e');
    } finally {
      _recovering = false;
    }
  }

  Future<void> _navigateToCongratsWithFailure() async {
    if (_navigating || _disposed || !mounted) return;
    _navigating = true;
    _disposed = true;
    _watchdogTimer?.cancel();
    _playerStateSubscription?.cancel();

    try {
      await widget.player.stop();
      await widget.player.dispose();
    } catch (_) {}

    await WakelockPlus.disable();

    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => Congrats(
          time: widget.time,
          didIt: false,
          sets: widget.sets,
          duration: DateTime.now().difference(widget.startTime).inSeconds,
        ),
      ),
      (route) => false,
    );
  }

  void _listenToPlayerState() {
    _playerStateSubscription?.cancel();
    _playerStateSubscription = widget.player.playerStateStream.listen(
      (state) {
        if (_disposed || _navigating || !mounted) return;

        final processingState = state.processingState;

        if (processingState == ProcessingState.completed) {
          if (!_advancing) {
            next();
          }
        }

        if (processingState == ProcessingState.ready && state.playing) {
          if (mounted && !_disposed) {
            setState(() {});
          }
        }
      },
      onError: (Object error, StackTrace stackTrace) {
        debugPrint('PlayerState error: $error');
        if (_disposed || _navigating || !mounted) return;
        _attemptRecovery();
      },
    );
  }

  @override
  void initState() {
    super.initState();
    widget.player.seek(Duration.zero, index: 0);
    WidgetsBinding.instance.addObserver(this);
    WakelockPlus.enable();
    _listenToPlayerState();
    _startWatchdog();
  }

  @override
  void dispose() {
    _watchdogTimer?.cancel();
    _playerStateSubscription?.cancel();
    WakelockPlus.disable();
    if (!_disposed) {
      _disposed = true;
      widget.player.dispose();
    }
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_disposed || _navigating) return;

    switch (state) {
      case AppLifecycleState.resumed:
        final currentIndex = widget.player.currentIndex;
        if (currentIndex == null) return;

        int temp = 0;
        for (int i = 0; i < currentIndex; i++) {
          temp += widget.time[i % 2];
        }
        remainderBasis = widget.totalDuration - temp;

        // Check if current segment finished while backgrounded
        final positionSeconds = widget.player.position.inSeconds;
        final intendedDuration = widget.time[currentIndex % 2];
        if (positionSeconds >= intendedDuration) {
          next();
          return;
        }

        // Resume playback if the OS stopped it (not user-initiated pause)
        final playerState = widget.player.playerState;
        if (!playerState.playing && !_userPaused && !_dialogOpen) {
          debugPrint('Lifecycle resumed: player stopped by OS, resuming.');
          widget.player.play();
        }

        _lastPositionUpdate = DateTime.now();
        _startWatchdog();
        setState(() {});
        break;

      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
        _watchdogTimer?.cancel();
        break;

      case AppLifecycleState.detached:
        _watchdogTimer?.cancel();
        _playerStateSubscription?.cancel();
        break;

      case AppLifecycleState.inactive:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPlaying = widget.player.playerState.playing;
    final currentIndex = widget.player.currentIndex ?? 0;
    final isTraining = currentIndex % 2 == 0;
    final textColor = context.colors.textOnGradient;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: (!isPlaying && !_dialogOpen)
              ? [const Color(0xffA3A3A3), const Color(0xff7C7C7C)]
              : isTraining
                  ? [const Color(0xffF01D52), const Color(0xffFA5F54)]
                  : [const Color(0xff1373C8), const Color(0xff7189E1)],
        ),
      ),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            leading: IconButton(
                color: const Color(0xffFADCE3),
                onPressed: () async {
                  if (_dialogOpen) return;
                  HapticService.selection();
                  _dialogOpen = true;
                  widget.player.pause();
                  setState(() {});

                  final shouldExit = await showDialog<bool>(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) =>
                        Dialogs.buildExitDialog(context),
                  );

                  if (!mounted || _disposed) return;

                  if (shouldExit == true) {
                    _navigating = true;
                    _disposed = true;
                    _watchdogTimer?.cancel();
                    _playerStateSubscription?.cancel();
                    try {
                      await widget.player.stop();
                      await widget.player.dispose();
                    } catch (_) {}
                    await WakelockPlus.disable();
                    if (!context.mounted) return;
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => Congrats(
                          time: widget.time,
                          didIt: false,
                          sets: widget.sets,
                          duration: DateTime.now()
                              .difference(widget.startTime)
                              .inSeconds,
                        ),
                      ),
                      (route) => false,
                    );
                  } else {
                    _dialogOpen = false;
                    _userPaused = false;
                    widget.player.play();
                    setState(() {});
                  }
                },
                icon: Icon(TablerIcons.x, color: textColor)),
            title: Text(
                AppLocalizations.of(context)!.run_set_from_one +
                    (currentIndex ~/ 2 + 1).toString() +
                    AppLocalizations.of(context)!.run_set_from_two +
                    widget.sets.toString(),
                style: heading2Bold(context).copyWith(color: textColor)),
            centerTitle: true,
            actions: [
              IconButton(
                  onPressed: () {
                    HapticService.light();
                    if (sound == "off") {
                      sound = _originalSound == "off" ? "assets/sounds/Countdown1.mp3" : _originalSound;
                      widget.player.setVolume(1);
                    } else {
                      sound = "off";
                      widget.player.setVolume(0);
                    }
                    setState(() {});
                  },
                  icon: Icon(
                    sound == "off" ? TablerIcons.volume_off : TablerIcons.volume,
                    color: textColor,
                  ))
            ],
          ),
          body: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: _togglePlayPause,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 82.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Only this StreamBuilder rebuilds on each position tick
                    StreamBuilder<Duration>(
                      stream: widget.player.positionStream,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const SizedBox(height: 380);
                        }
                        final positionSeconds = snapshot.data!.inSeconds;

                        // Track position updates for the watchdog
                        if (positionSeconds != _lastPositionSeconds) {
                          _lastPositionSeconds = positionSeconds;
                          _lastPositionUpdate = DateTime.now();
                          _recoveryAttempts = 0;
                        }

                        final intendedDuration =
                            widget.time[currentIndex % 2];
                        int duration = intendedDuration - positionSeconds;

                        if (duration >= 1 && duration <= 3 && duration != _lastHapticSecond) {
                          _lastHapticSecond = duration;
                          if (duration == 1) {
                            HapticService.medium();
                          } else {
                            HapticService.light();
                          }
                        }

                        if (duration <= 0 && !_navigating && !_advancing) {
                          _advancing = true;
                          final version = _advanceVersion;
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            _advancing = false;
                            if (_advanceVersion == version) {
                              next();
                            }
                          });
                        }

                        final elapsed =
                            positionSeconds.clamp(0, intendedDuration);
                        final remaining = remainderBasis - elapsed;
                        return Column(
                          children: [
                            CustomTimer(
                                seconds: duration.clamp(0, intendedDuration),
                                maxSeconds: intendedDuration,
                                isRunning: isPlaying,
                                indexTime: currentIndex % 2),
                            const SizedBox(height: 16),
                            Column(
                              children: [
                                Text(
                                    "${(remaining / 60).floor()}:${(remaining % 60).toString().padLeft(2, '0')}",
                                    style: body0Bold(context)
                                        .copyWith(color: textColor)),
                                Text(
                                    AppLocalizations.of(context)!.run_remaining,
                                    style: body0Bold(context)
                                        .copyWith(color: textColor)),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                    // Playback controls — only rebuild on setState (play/pause/segment change)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                            color: textColor,
                            onPressed: () async {
                              HapticService.selection();
                              await back();
                            },
                            iconSize: 50,
                            icon: const Icon(TablerIcons.chevron_left)),
                        const SizedBox(width: 20),
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: textColor,
                          child: IconButton(
                              iconSize: 60,
                              color: (!isPlaying && !_dialogOpen)
                                  ? const Color(0xff7C7C7C)
                                  : isTraining
                                      ? const Color(0xffFA5F54)
                                      : const Color(0xff7189E1),
                              onPressed: _togglePlayPause,
                              icon: Icon(
                                (!isPlaying && !_dialogOpen)
                                    ? TablerIcons.player_play_filled
                                    : TablerIcons.player_pause_filled,
                              )),
                        ),
                        const SizedBox(width: 20),
                        IconButton(
                            color: textColor,
                            onPressed: () async {
                              HapticService.selection();
                              await next();
                            },
                            iconSize: 50,
                            icon: const Icon(TablerIcons.chevron_right)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
