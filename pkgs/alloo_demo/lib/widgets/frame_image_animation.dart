import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class FrameImageAnimation extends StatefulWidget {
  final List<String> frameImages; // 帧动画的图片列表
  final String? package; // 图片所在的包名
  final double width; // 控件宽度
  final double height; // 控件高度
  final Duration totalDuration; // 帧动画的总时长
  final bool loop; // 是否循环播放
  final FrameImageAnimationController? controller;

  const FrameImageAnimation({
    super.key,
    required this.frameImages,
    this.package,
    required this.width,
    required this.height,
    required this.totalDuration,
    this.controller,
    this.loop = true,
  });

  @override
  State<FrameImageAnimation> createState() => _FrameImageAnimationState();
}

class _FrameImageAnimationState extends State<FrameImageAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late final FrameImageAnimationController _controller =
      widget.controller ?? FrameImageAnimationController(loop: widget.loop);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.totalDuration,
    );
    _initController();
    _controller.addListener(_animateChange);
    if (widget.controller == null) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _controller.start();
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _controller._detach();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant FrameImageAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (listEquals(oldWidget.frameImages, widget.frameImages) ||
        oldWidget.totalDuration != widget.totalDuration) {
      _initController();
      return;
    }
  }

  void _initController() {
    _controller._detach();
    _animationController.duration = widget.totalDuration;
    _controller._attach(_animationController, widget.frameImages.length);
  }

  void _animateChange() {
    if (!mounted) return;
    //print('frame value: ${_controller.value}');
    final schedulerPhase = SchedulerBinding.instance.schedulerPhase;
    if (schedulerPhase != SchedulerPhase.persistentCallbacks) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: IndexedStack(
        index: _controller.value,
        children: [
          for (final imagePath in widget.frameImages)
            Image.asset(
              imagePath,
              fit: BoxFit.contain,
              package: widget.package,
              scale: 3,
            ),
        ],
      ),
    );
  }
}

/// 帧动画控制器
/// - 用于控制帧动画的播放
/// - 可以设置显示在第几帧，百分比控制
/// - 可以控制开始、暂停、停止
class FrameImageAnimationController extends ValueNotifier<int> {
  FrameImageAnimationController({int value = 0, bool loop = true})
      : _loop = loop,
        super(value);

  bool _loop;

  bool get loop => _loop;

  set loop(bool value) {
    _loop = value;
  }

  late int _frameCount;
  AnimationController? _animationController;
  Animation<double>? _animation;

  void _attach(AnimationController animationController, int frameCount) {
    _animationController = animationController;
    _frameCount = frameCount;
    _animation = Tween(begin: 0.0, end: (frameCount.toDouble() - 1).toDouble())
        .animate(animationController)
      ..addListener(_onAnimate);
    animationController.addStatusListener(_onAnimationStatusChange);
  }

  void _detach() {
    _animationController?.removeStatusListener(_onAnimationStatusChange);
    _animation?.removeListener(_onAnimate);
    _animation = null;
    _animationController = null;
  }

  set fraction(double fraction) {
    _animationController?.value = fraction % 1;
  }

  /// 开始播放
  void start() {
    _animationController?.forward();
  }

  /// 暂停播放
  void stop() {
    if (_animationController?.isAnimating == true) {
      _animationController?.stop();
    }
  }

  void _onAnimate() {
    final animation = _animation;
    if (animation == null) return;
    value = animation.value.round();
  }

  void _onAnimationStatusChange(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      if (loop) {
        _animationController?.forward(from: 0);
      }
    }
  }
}
