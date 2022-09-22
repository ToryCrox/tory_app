import 'dart:async';

import 'package:flutter/material.dart';

class MarqueeWidget extends StatefulWidget {
  final Widget child;

  ///滚动方向，水平或者垂直
  final Axis scrollAxis;

  ///空白部分占控件的百分比
  final double ratioOfBlankToScreen;

  /// 子widget的宽度是否必须大于当前widget
  final bool childWiderThanSelf;

  /// isUseMaxScrollExtent == false时，就没有一段空白滚动
  final bool isUseMaxScrollExtent;

  MarqueeWidget({
    required this.child,
    this.scrollAxis: Axis.horizontal,
    this.ratioOfBlankToScreen: 80,
    this.childWiderThanSelf = true,
    this.isUseMaxScrollExtent = true,
  }) : assert(child != null);

  @override
  State<StatefulWidget> createState() {
    return MarqueeWidgetState();
  }
}

class MarqueeWidgetState extends State<MarqueeWidget> with SingleTickerProviderStateMixin {
  ScrollController? scrollController;
  double position = 0.0;
  Timer? timer;
  final double _moveDistance = 5.0;
  final int _timerRest = 100;
  GlobalKey _key = GlobalKey();
  GlobalKey _keyChild1 = GlobalKey();
  GlobalKey _keyChild2 = GlobalKey();

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    WidgetsBinding.instance!.addPostFrameCallback((callback) {
      startTimer();
    });
  }

  void startTimer() {
    double widgetWidth = _key.currentContext!.findRenderObject()!.paintBounds.size.width;
    double childWidth = _keyChild1.currentContext!.findRenderObject()!.paintBounds.size.width;
    double widgetHeight = _key.currentContext!.findRenderObject()!.paintBounds.size.height;
    double maxScrollExtent = widget.isUseMaxScrollExtent ? scrollController!.position.maxScrollExtent : childWidth;

    print('widgetWidth:$widgetWidth');
    print('childWidth:$childWidth');
    print('maxScrollExtent:$maxScrollExtent');
    if (widget.childWiderThanSelf && childWidth <= widgetWidth) {
      return;
    }
    timer = Timer.periodic(Duration(milliseconds: _timerRest), (timer) {
      double pixels = scrollController!.position.pixels;
      if (pixels + _moveDistance >= maxScrollExtent) {
        if (widget.scrollAxis == Axis.horizontal) {
          position =
              (maxScrollExtent - widget.ratioOfBlankToScreen + widgetWidth) / 2 - widgetWidth + pixels - maxScrollExtent;
        } else {
          position =
              (maxScrollExtent - widget.ratioOfBlankToScreen + widgetHeight) / 2 - widgetHeight + pixels - maxScrollExtent;
        }
        scrollController!.jumpTo(position);
      }
      position += _moveDistance;
      scrollController!.animateTo(position, duration: Duration(milliseconds: _timerRest), curve: Curves.linear);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Widget getBothEndsChild(GlobalKey key) {
    return Center(
      key: key,
      child: widget.child,
    );
  }

  Widget getCenterChild() {
    if (widget.scrollAxis == Axis.horizontal) {
      return Container(width:  widget.ratioOfBlankToScreen);
    } else {
      return Container(height: widget.ratioOfBlankToScreen);
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      key: _key,
      scrollDirection: widget.scrollAxis,
      controller: scrollController,
      physics: const NeverScrollableScrollPhysics(),
      children: <Widget>[
        getBothEndsChild(_keyChild1),
        getCenterChild(),
        getBothEndsChild(_keyChild2),
      ],
    );
  }
}
