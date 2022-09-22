import 'dart:async';

import 'package:flutter/material.dart';

/// 循环滚动的widget
class SingleMarquee extends StatefulWidget {
  final Widget child;
  final double gapSize;
  final Duration delay;
  final int speed;

  const SingleMarquee({
    Key? key,
    required this.child,
    this.delay = const Duration(milliseconds: 1000),
    this.gapSize = 50,
    this.speed = 50,
  }) : super(key: key);

  @override
  State<SingleMarquee> createState() => _SingleMarqueeState();
}

class _SingleMarqueeState extends State<SingleMarquee> {
  final GlobalKey _childKey = GlobalKey();
  final GlobalKey _containerKey = GlobalKey();
  late ScrollController _scrollController;
  bool _isScroll = false;
  Timer? _timer;
  int _counter = 0;
  bool _isDispose = false;
  final maxCounter = 1000;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _prepareToMarquee();
  }

  @override
  void dispose() {
    _isDispose = true;
    _timer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      key: _containerKey,
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      itemCount: _isScroll ? maxCounter : 1,
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox(width: widget.gapSize);
      },
      itemBuilder: (BuildContext context, int index) {
        return Container(
          key: index == 0 ? _childKey: null,
          child: widget.child,
        );
      },
    );
  }

  @override
  void didUpdateWidget(covariant SingleMarquee oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_isDispose) {
      return;
    }
    _resetLayout();
    _prepareToMarquee();
  }

  void _prepareToMarquee() {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _onLayout();
    });
  }

  void _resetLayout() {
    _scrollController.jumpTo(0);
    _counter = 0;
    debugPrint("SingleMarquee: reset");
  }

  void _onLayout() {
    _timer?.cancel();
    _resetLayout();
    final containerWidth = _containerKey.currentContext?.size?.width;
    final childWidth = _childKey.currentContext?.size?.width;
    debugPrint("SingleMarquee onLayout containerWidth:$containerWidth, childWidth:$childWidth");
    if (childWidth == null || containerWidth == null) {
      return;
    }
    if (childWidth <= containerWidth) {
      debugPrint("SingleMarquee not need marquee");
      setState(() {
        _isScroll = false;
      });
      return;
    }
    setState(() {
      _isScroll = true;
    });
    final scrollDistance = childWidth + widget.gapSize;
    final scrollDuration =
        Duration(milliseconds: widget.speed * scrollDistance.toInt());
    debugPrint("SingleMarquee start marquee: ${scrollDuration.inMilliseconds}");
    void runAnimateEnd (Timer timer) {
      if (_counter == maxCounter - 1){
        _resetLayout();
        debugPrint("SingleMarquee: reset");
        // 重置一下
      }
      Future.delayed(widget.delay).then((value) {
        if (_isDispose || !timer.isActive) {
          debugPrint("SingleMarquee: disposed or not active "
              "_isDispose:$_isDispose, isActive: $timer.isActive");
          return;
        }
        _counter++;
        debugPrint("SingleMarquee: start to end $_counter");
        final targetOffset = scrollDistance * _counter;
        _scrollController.animateTo(targetOffset,
            duration: scrollDuration, curve: Curves.linear);
      });
    }
    final t = Timer.periodic(scrollDuration + widget.delay, (timer) {
      runAnimateEnd(timer);
    });
    _timer = t;
    runAnimateEnd(t);
  }
}
