import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ScrollToHideWidget extends StatefulWidget {
  final Widget child;
  final ScrollController controller;
  final Duration duration;
  final double height;

  const ScrollToHideWidget(
      {super.key,
      required this.child,
      required this.controller,
      this.duration = const Duration(milliseconds: 200),
      this.height = 82});

  @override
  State<ScrollToHideWidget> createState() => _ScrollToHideWidgetState();
}

class _ScrollToHideWidgetState extends State<ScrollToHideWidget> {
  bool isVisible = true;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(listen);
  }

  @override
  void dispose() {
    widget.controller.removeListener(listen);
    super.dispose();
  }

  void listen() {
    final direction = widget.controller.position.userScrollDirection;
    if (direction == ScrollDirection.forward) {
      show();
    } else if (direction == ScrollDirection.reverse) {
      // Only hide if there's enough scroll extent so that after the viewport
      // expands by widget.height, the user can still scroll back up to
      // re-show the navbar. Without this guard, content that barely overflows
      // causes the navbar to hide, the viewport to grow, the content to fit,
      // and the user gets stuck with no way to bring the navbar back.
      if (widget.controller.position.maxScrollExtent > widget.height) {
        hide();
      }
    }
  }

  void show() {
    if (!isVisible) {
      setState(() => isVisible = true);
    }
  }

  void hide() {
    if (isVisible) {
      setState(() => isVisible = false);
    }
  }

  @override
  Widget build(BuildContext context) => AnimatedContainer(
        height: isVisible ? widget.height : 0,
        duration: widget.duration,
        child: Wrap(children: [widget.child]),
      );
}
