import 'package:alloo_demo/widgets/alloo_loading.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';

import 'frame_image_animation.dart';

class AllooRefreshController {
  final ValueNotifier<int> _refreshCount = ValueNotifier(0);

  void callRefresh() {
    _refreshCount.value++;
  }
}

class AllooEasyRefresh extends StatefulWidget {
  const AllooEasyRefresh({
    Key? key,
    required this.child,
    required this.onRefresh,
    this.isEnableRefresh = true,
    this.controller,
  }) : super(key: key);

  final Widget child;
  final RefreshCallback onRefresh;
  final bool isEnableRefresh;
  final AllooRefreshController? controller;

  @override
  State<AllooEasyRefresh> createState() => _AllooEasyRefreshState();
}

class _AllooEasyRefreshState extends State<AllooEasyRefresh> {
  late final EasyRefreshController _controller = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: false,
  );

  @override
  void initState() {
    super.initState();
    widget.controller?._refreshCount.addListener(_onCallRefresh);
  }

  @override
  void dispose() {
    widget.controller?._refreshCount.removeListener(_onCallRefresh);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant AllooEasyRefresh oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?._refreshCount.removeListener(_onCallRefresh);
      widget.controller?._refreshCount.addListener(_onCallRefresh);
    }
  }

  void _onCallRefresh() {
    _controller.callRefresh();
  }



  @override
  Widget build(BuildContext context) {
    return EasyRefresh(
      controller: _controller,
      header: AllooRefreshHeader(),
      onRefresh: widget.isEnableRefresh
          ? () async {
              await widget.onRefresh();
              _controller.finishRefresh();
            }
          : null,
      child: widget.child,
    );
  }
}

const _kDefaultAllooTriggerOffset = 78.0;
const _kAllooProcessed = Duration(seconds: 1);

class AllooRefreshHeader extends Header {
  AllooRefreshHeader({
    double triggerOffset = _kDefaultAllooTriggerOffset,
  }) : super(
          triggerOffset: triggerOffset,
          clamping: false,
          position: IndicatorPosition.above,
          processedDuration: _kAllooProcessed,
          springRebound: false,
          safeArea: false,
          triggerWhenRelease: true,
        );

  @override
  Widget build(BuildContext context, IndicatorState state) {
    assert(state.axis == Axis.vertical,
        'AllooRefreshHeader does not support horizontal scrolling.');
    return _AllooRefreshIndicator(
      state: state,
      reverse: state.reverse,
    );
  }
}

class _AllooRefreshIndicator extends StatefulWidget {
  const _AllooRefreshIndicator({
    Key? key,
    required this.state,
    required this.reverse,
  }) : super(key: key);

  /// Indicator properties and state.
  final IndicatorState state;

  /// True for up and left.
  /// False for down and right.
  final bool reverse;

  @override
  State<_AllooRefreshIndicator> createState() => _AllooRefreshIndicatorState();
}

class _AllooRefreshIndicatorState extends State<_AllooRefreshIndicator> {
  late final FrameImageAnimationController _loadingController =
      FrameImageAnimationController(loop: true);

  double get _offset => widget.state.offset;

  IndicatorMode get _mode => widget.state.mode;

  double get _actualTriggerOffset => widget.state.actualTriggerOffset;

  @override
  void initState() {
    super.initState();
    widget.state.notifier.addModeChangeListener(_onModeChange);
  }

  @override
  void dispose() {
    widget.state.notifier.removeModeChangeListener(_onModeChange);
    super.dispose();
  }

  /// Mode change listener.
  void _onModeChange(IndicatorMode mode, double offset) {
    print('_onModeChange mode: $mode, offset: $offset');
    if (mode == IndicatorMode.drag) {
    } else if (mode == IndicatorMode.processing) {
      _loadingController.start();
    } else if (mode == IndicatorMode.armed ||
        mode == IndicatorMode.drag ||
        mode == IndicatorMode.inactive) {
      _loadingController.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_mode == IndicatorMode.drag || _mode == IndicatorMode.armed) {
      //print('build $_mode, $_offset, $_actualTriggerOffset');
      final fraction = _offset / _actualTriggerOffset;
      _loadingController.fraction = fraction;
    }

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        SizedBox(
          width: double.infinity,
          height: _offset,
        ),
        if (widget.state.mode != IndicatorMode.inactive)
          PositionedDirectional(
            bottom: 0,
            child: AllooLoading(
              controller: _loadingController,
              size: 66,
            ),
          ),
      ],
    );
  }
}
