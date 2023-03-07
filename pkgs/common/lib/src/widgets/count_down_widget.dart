import 'dart:async';

import 'package:flutter/material.dart';

/// 倒计时组件
/// [countDownTime] 倒计时时间, 单位毫秒
/// [countDownStep] 倒计时步长, 单位毫秒, 默认1000毫秒
/// [builder] 倒计时
/// [onCountDownFinish] 倒计时结束回调
class CountDownWidget extends StatefulWidget {
  final int countDownTime;
  final int countDownStep;
  final VoidCallback? onCountDownFinish;
  final Widget Function(BuildContext context, int timeLeft) builder;

  const CountDownWidget({
    Key? key,
    required this.countDownTime,
    required this.builder,
    this.countDownStep = 1000,
    this.onCountDownFinish,
  })  : assert(countDownStep > 0, 'countDownStep must be greater than 0'),
        assert(countDownTime > 0, 'countDownTime must be greater than 0'),
        super(key: key);

  @override
  _CountDownWidgetState createState() => _CountDownWidgetState();
}

class _CountDownWidgetState extends State<CountDownWidget> {
  Timer? _timer;
  late int _countDownTime;

  @override
  void initState() {
    super.initState();
    _countDownTime = widget.countDownTime;
    _startCountDown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _countDownTime);
  }

  void _startCountDown() {
    _timer =
        Timer.periodic(Duration(milliseconds: widget.countDownStep), (timer) {
      if (_countDownTime <= 0) {
        _timer?.cancel();
        widget.onCountDownFinish?.call();
      } else {
        setState(() {
          _countDownTime = _countDownTime - widget.countDownStep;
        });
      }
    });
  }
}
