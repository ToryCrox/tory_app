import 'dart:math';

import 'package:flutter/material.dart';

import 'spin_wheel_layout.dart';

typedef SpinWheelChildBuilder = Widget Function(
  BuildContext context,
  int index,
  Widget child,
  SpinWheelChildState state,
);

class CustomSpinWheel<T> extends StatefulWidget {
  const CustomSpinWheel({
    super.key,
    this.center,
    required this.children,
    this.builder,
    this.controller,
  });

  final Widget? center;
  final List<Widget> children;
  final SpinWheelChildBuilder? builder;
  final SpinWheelController? controller;

  @override
  State<CustomSpinWheel> createState() => _CustomSpinWheelState();
}

class _CustomSpinWheelState extends State<CustomSpinWheel>
    with TickerProviderStateMixin {
  static const int _horizontalCount = 3;
  static const int _verticalCount = 3;

  static int get _maxChildCount =>
      _horizontalCount * 2 + _verticalCount * 2 - 4;

  double _animateProgress = 0.0;

  AnimationController? _animationController;

  SpinWheelController? get _controller => widget.controller;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    _controller?.removeListener(_spinStateUpdate);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant CustomSpinWheel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != _controller) {
      _controller?.removeListener(_spinStateUpdate);
      _initController();
    }
  }

  void _initController() {
    final controller = widget.controller;
    if (controller == null) return;
    controller.addListener(_spinStateUpdate);
    _spinStateUpdate();
  }

  void _spinStateUpdate() {
    final controller = _controller;
    if (controller == null) return;

    final state = controller.state;
    if (state == SpinWheelState.idle) {
      _animationController?.dispose();
      _animationController = null;
    } else if (state == SpinWheelState.ticker) {
      _startAnimate();
    } else if (state == SpinWheelState.lotteryPrepare) {
      /// 开始抽奖，加速转动
      _startAnimate(interval: 100);
    } else if (state == SpinWheelState.lotteryStart) {
      /// c抽奖j结束
      _startAnimate(
        loop: false,
        interval: 200,
        targetIndex: controller.targetIndex,
      );
    }
  }

  void _startAnimate(
      {bool loop = true, int interval = 1000, int? targetIndex}) {
    _animationController?.dispose();

    double animateTotal = _maxChildCount * 1.0;
    if (targetIndex != null) {
      final r = (_animateProgress.round() ~/ _maxChildCount);
      double targetProgress = 1.0 * r * _maxChildCount + targetIndex;
      if (targetProgress <= _animateProgress) {
        targetProgress += _maxChildCount;
      } else {
        if ((_animateProgress - targetProgress) < _maxChildCount / 2) {
          targetProgress += _maxChildCount;
        }
      }
      // 再添加一个轮次
      targetProgress += _maxChildCount * 3;
      animateTotal = targetProgress - _animateProgress;
    }

    final controller = AnimationController(
      duration: Duration(milliseconds: (interval * animateTotal).round()),
      vsync: this,
    );
    final animation = Tween<double>(
            begin: _animateProgress, end: _animateProgress + animateTotal)
        .animate(CurvedAnimation(
      parent: controller,
      curve: targetIndex != null ? Curves.easeOutCubic : Curves.linear,
    ));
    controller.addListener(() {
      _updateAnimateProgress(animation);
    });
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _updateAnimateProgress(animation);
        _animationController = null;
        if (loop) {
          _startAnimate(interval: interval);
        } else if (_controller?.state == SpinWheelState.lotteryStart) {
          _controller?._endLottery();
        }
      }
    });
    controller.forward();
    _animationController = controller;
  }

  void _updateAnimateProgress(Animation<double> animation) {
    if (_animateProgress.round() != animation.value.round()) {
      setState(() {});
    }
    _animateProgress = animation.value;
  }

  @override
  Widget build(BuildContext context) {
    return SpinWheelLayout(
      padding: const EdgeInsets.all(10),
      children: [
        for (int i = 0; i < min(_maxChildCount, widget.children.length); i++)
          _buildItem(i),
      ],
      center: widget.center,
      childAspectRatio: 1,
      horizontalCount: _horizontalCount,
      verticalCount: _verticalCount,
      horizontalSpacing: 10,
      verticalSpacing: 8,
    );
  }

  Widget _buildItem(int index) {
    final isCurrent = index == _animateProgress.round() % _maxChildCount;
    SpinWheelChildState state = SpinWheelChildState.none;
    if (isCurrent) {
      state = _controller?.state == SpinWheelState.lotteryEnd
          ? SpinWheelChildState.selected
          : SpinWheelChildState.ticker;
    }
    return widget.builder?.call(context, index, widget.children[index], state)
        ?? widget.children[index];
  }
}

enum SpinWheelChildState {
  none,
  ticker, /// 旋转过程中选中
  selected, /// 最后选中
}

enum SpinWheelState {
  idle,
  ticker,
  lotteryPrepare,
  lotteryStart,
  lotteryEnd,
}

class SpinWheelController extends ChangeNotifier {

  SpinWheelController();

  SpinWheelState _state = SpinWheelState.idle;

  SpinWheelState get state => _state;

  int? _targetIndex;

  int? get targetIndex => _targetIndex;

  void startTicker() {
    _state = SpinWheelState.ticker;
    notifyListeners();
  }

  /// 点击，准备抽奖
  void prepareLottery() {
    _state = SpinWheelState.lotteryPrepare;
    notifyListeners();
  }

  /// 抽奖开始
  void startLottery(int targetIndex) {
    _state = SpinWheelState.lotteryStart;
    _targetIndex = targetIndex;
    notifyListeners();
  }

  /// 抽奖结束，暂停一段时间后重新开始
  void _endLottery() {
    _state = SpinWheelState.lotteryEnd;
    notifyListeners();
    Future.delayed(const Duration(seconds: 3), () {
      if (_state == SpinWheelState.lotteryEnd) {
        startTicker();
      }
    });
  }

  void idle() {
    _state = SpinWheelState.idle;
    notifyListeners();
  }
}
