import 'dart:async';

import 'package:flutter/material.dart';

typedef OnTapThrottle = FutureOr<void> Function();

/// 防止重复点击
class ThrottleInkWell extends StatefulWidget {
  final Widget? child;
  /// 点击任务未完成再次点击无效
  final OnTapThrottle? onTap;
  /// 屏蔽多长时间内的重复点击，默认500ms
  final int throttleTime;
  final BorderRadius? borderRadius;

  const ThrottleInkWell({
    Key? key,
    this.child,
    this.onTap,
    this.throttleTime = 500,
    this.borderRadius,
  }) : super(key: key);

  @override
  State<ThrottleInkWell> createState() => _ThrottleInkWellState();
}

class _ThrottleInkWellState extends State<ThrottleInkWell> {
  int _lastTapTime = 0;
  bool _isTaping = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _isTaping || widget.onTap == null
            ? null
            : _doTap,
        borderRadius: widget.borderRadius,
        child: widget.child,
      ),
    );
  }

  Future _doTap() async {
    if ((DateTime.now().millisecondsSinceEpoch - _lastTapTime).abs() <
        widget.throttleTime){
      return;
    }
    setState(() {
      _isTaping = true;
      _lastTapTime = DateTime.now().millisecondsSinceEpoch;
    });
    try {
      await widget.onTap?.call();
    } finally {
      _isTaping = false;
      if (mounted) setState(() {});
    }
  }
}


/// 防止重复点击
class ThrottleTapDetector extends StatefulWidget {
  final Widget? child;
  /// 点击任务未完成再次点击无效
  final OnTapThrottle? onTap;
  /// 屏蔽多长时间内的重复点击，默认500ms
  final int throttleTime;
  final HitTestBehavior? behavior;

  const ThrottleTapDetector({
    Key? key,
    this.child,
    this.onTap,
    this.behavior,
    this.throttleTime = 500,
  }) : super(key: key);

  @override
  State<ThrottleTapDetector> createState() => _ThrottleTapDetectorState();
}

class _ThrottleTapDetectorState extends State<ThrottleTapDetector> {

  int _lastTapTime = 0;
  bool _isTaping = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _doTap,
      behavior: widget.behavior,
      child: widget.child,
    );
  }

  Future _doTap() async {
    if (_isTaping || widget.onTap == null ||
        (DateTime.now().millisecondsSinceEpoch - _lastTapTime).abs() <
            widget.throttleTime) {
      return;
    }
    _isTaping = true;
    _lastTapTime = DateTime.now().millisecondsSinceEpoch;
    await widget.onTap?.call();
    _isTaping = false;
  }
}