import 'package:flutter/material.dart';
import 'package:interval_timer/components/bottom_navbar.dart';
import 'package:interval_timer/components/dialogs.dart';
import 'package:interval_timer/pages/jump_in/jump_in.dart';
import 'package:interval_timer/pages/profile/profile.dart';
import 'package:interval_timer/pages/workouts/workouts.dart';
import 'package:interval_timer/services/settings_service.dart';
import 'package:interval_timer/services/haptic_service.dart';
import 'package:interval_timer/l10n/app_localizations.dart';
import '../const.dart';

class Home extends StatefulWidget {
  final int screenIndex;
  final bool visible;
  const Home({super.key, required this.screenIndex, this.visible = false});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late ScrollController controller;
  late List<Widget> screens;
  late int screenIndex = widget.screenIndex;
  late bool visible = widget.visible;

  final GlobalKey _trainingButtonKey = GlobalKey();
  final GlobalKey<JumpInState> _jumpInKey = GlobalKey<JumpInState>();
  Rect? _trainingButtonRect;

  @override
  void initState() {
    super.initState();
    controller = ScrollController();
    screens = [
      Workouts(controller: controller),
      JumpIn(key: _jumpInKey, trainingButtonKey: _trainingButtonKey),
      const Profile(),
    ];

    if (visible) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _updateTrainingButtonRect();
      });
    }
  }

  void _updateTrainingButtonRect() {
    if (!mounted) return;
    final RenderBox? box =
        _trainingButtonKey.currentContext?.findRenderObject() as RenderBox?;
    if (box != null && box.hasSize) {
      final position = box.localToGlobal(Offset.zero);
      final size = box.size;
      setState(() {
        _trainingButtonRect =
            Rect.fromLTWH(position.dx, position.dy, size.width, size.height);
      });
    }
  }

  killVisible() {
    SettingsService.setJumpInVisible(false);
    setState(() {
      visible = false;
      _trainingButtonRect = null;
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
            body: screens[screenIndex],
            bottomNavigationBar: BottomNavBar(
              controller: controller,
              screenIndex: screenIndex,
              onTabTapped: (int index) {
                setState(() {
                  screenIndex = index;
                });
              },
            )),
        if (visible)
          Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Colors.black.withValues(alpha: 0.56)),
        if (visible && _trainingButtonRect != null)
          Positioned(
            left: 0,
            right: 0,
            bottom: MediaQuery.of(context).size.height -
                _trainingButtonRect!.bottom,
            child: Material(
              type: MaterialType.transparency,
              child: Center(
                child: IntrinsicWidth(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 24.0, left: 24),
                        child: Container(
                          decoration: BoxDecoration(
                            color: context.colors.neutral50,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(16)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              AppLocalizations.of(context)!.tap_tutorial,
                              style: body1(context),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          HapticService.selection();
                          final jumpInState = _jumpInKey.currentState;
                          if (jumpInState == null) return;
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext ctx) =>
                                Dialogs.buildSetTimesDialog(
                              ctx,
                              "training",
                              jumpInState.minutesTraining,
                              jumpInState.minutesPause,
                              jumpInState.sets,
                              jumpInState.setValue,
                            ),
                          ).then((_) {
                            killVisible();
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.only(
                              top: 8, bottom: 8, left: 12, right: 12),
                          decoration: BoxDecoration(
                            color: context.colors.cardSurface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Text(
                            _jumpInKey.currentState?.minutesTraining
                                    .toString()
                                    .substring(2, 7) ??
                                "01:15",
                            style: heading3Bold(context),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
