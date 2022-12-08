// @dart=2.12

import 'package:flutter/material.dart';

import '../utils/utils.dart';

/// 进场动画容器
class RoomWelcomeAnimateWidget extends StatefulWidget {
  final Widget child;
  final VoidCallback? onComplete;

  const RoomWelcomeAnimateWidget({
    Key? key,
    required this.child,
    this.onComplete,
  }) : super(key: key);

  @override
  State<RoomWelcomeAnimateWidget> createState() =>
      _RoomWelcomeAnimateWidgetState();
}

class _RoomWelcomeAnimateWidgetState extends State<RoomWelcomeAnimateWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _offsetTween;

  @override
  void initState() {
    super.initState();
    _initAnimation();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        if (!mounted) return;
        _controller.forward();
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _initAnimation() {
    _controller = AnimationController(
        duration: Duration(milliseconds: 3500), vsync: this);
    _controller.addStatusListener((state) {
      if (state == AnimationStatus.completed) {
        widget.onComplete?.call();
      }
    });
    _offsetTween = TweenSequence([
      TweenSequenceItem(
          tween: Tween(begin: Util.width, end: 0.0)
              .chain(CurveTween(curve: Curves.fastLinearToSlowEaseIn)),
          weight: 700),
      TweenSequenceItem(tween: ConstantTween<double>(0.0), weight: 2000),
      TweenSequenceItem(
          tween: Tween(begin: 0.0, end: -Util.width)
              .chain(CurveTween(curve: Curves.easeInQuint)),
          weight: 800),
    ]).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget? child) {
        return Transform.translate(
          offset: Offset(_offsetTween.value, 0),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
