import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:interval_timer/l10n/app_localizations.dart';
import '../const.dart';
import 'dialogs.dart';

class IncrementDecrementButton extends StatefulWidget {
  final String type;
  final int sets;
  final Duration minutes;
  final Duration otherMinutes;
  final bool visible;
  final Function? killVisible;
  final Function(String type, bool increment) update;
  final Function(String type, int value, bool? minute) setValue;
  const IncrementDecrementButton(
      {super.key,
      this.killVisible,
      required this.type,
      required this.update,
      required this.setValue,
      required this.sets,
      required this.minutes,
      required this.visible,
      required this.otherMinutes});

  @override
  State<IncrementDecrementButton> createState() =>
      _IncrementDecrementButtonState();
}

class _IncrementDecrementButtonState extends State<IncrementDecrementButton> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    if (widget.visible) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showOverlay();
      });
    }
  }

  @override
  void didUpdateWidget(IncrementDecrementButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.visible && !widget.visible) {
      _removeOverlay();
    }
  }

  void _showOverlay() {
    _overlayEntry = OverlayEntry(
      builder: (overlayContext) => CompositedTransformFollower(
        link: _layerLink,
        targetAnchor: Alignment.bottomCenter,
        followerAnchor: Alignment.bottomCenter,
        child: Material(
          type: MaterialType.transparency,
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
                Container(
                  padding: const EdgeInsets.only(
                      top: 8, bottom: 8, left: 12, right: 12),
                  decoration: BoxDecoration(
                    color: context.colors.cardSurface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: RichText(
                    text: TextSpan(
                      style: heading3Bold(context),
                      text: widget.type != "set"
                          ? widget.minutes.toString().substring(2, 7)
                          : widget.sets.toString(),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        Dialogs.buildSetTimesDialog(
                                            context,
                                            widget.type,
                                            widget.minutes,
                                            widget.otherMinutes,
                                            widget.sets,
                                            widget.setValue))
                                .then((value) {
                              _removeOverlay();
                              widget.killVisible!();
                            }),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                widget.update(widget.type, false);
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
                    widget.type == "training"
                        ? AppLocalizations.of(context)!.training
                        : widget.type == "pause"
                            ? AppLocalizations.of(context)!.pause
                            : AppLocalizations.of(context)!.sets,
                    style: body1Bold(context)),
                widget.visible
                    ? CompositedTransformTarget(
                        link: _layerLink,
                        child: RichText(
                          text: TextSpan(
                            style: heading3Bold(context),
                            text: widget.type != "set"
                                ? widget.minutes.toString().substring(2, 7)
                                : widget.sets.toString(),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        Dialogs.buildSetTimesDialog(
                                            context,
                                            widget.type,
                                            widget.minutes,
                                            widget.otherMinutes,
                                            widget.sets,
                                            widget.setValue),
                                  ),
                          ),
                        ),
                      )
                    : RichText(
                        text: TextSpan(
                          style: heading3Bold(context),
                          text: widget.type != "set"
                              ? widget.minutes.toString().substring(2, 7)
                              : widget.sets.toString(),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      Dialogs.buildSetTimesDialog(
                                          context,
                                          widget.type,
                                          widget.minutes,
                                          widget.otherMinutes,
                                          widget.sets,
                                          widget.setValue),
                                ),
                        ),
                      ),
              ],
            ),
          ),
          IconButton(
              onPressed: () {
                widget.update(widget.type, true);
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
