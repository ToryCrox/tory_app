import 'dart:async';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyMarqueeTest extends StatefulWidget {
  const MyMarqueeTest({Key? key}) : super(key: key);

  @override
  State<MyMarqueeTest> createState() => _MyMarqueeTestState();
}

class _MyMarqueeTestState extends State<MyMarqueeTest> {
  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("测试"),
      ),
      body: Center(
        child: Container(
          color: Colors.black38,
          width: 200,
          alignment: Alignment.center,
          child: Column(
            children: [
              _buildScrollerText(),
              Container(
                width: 200,
                height: 20,
                color: Colors.green,
                child:  VerticalSwiper(
                  swiperDuration: Duration(milliseconds: 500),
                  onItemTap: (index){
                    debugPrint("tap index: $index");
                  },
                  children: [
                    Text("1111111111111"),
                    Text("222222222222222222222222222222222222"),
                    // Text("33333333333333333333333333333333333333333333"),
                    Text("444444444444444444"),
                    // Text("55555555555"),
                    // Text("666666666666666"),
                    // Text("777777777777777777"),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      print("onListener: ${_controller.position}");
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      print("onFrameCallback: ${_controller.position}");
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildScrollerText() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      controller: _controller,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [Text("测试文本1111111112222222222222222333333333333333")],
        ),
      ),
    );
  }
}

class VerticalSwiper extends StatefulWidget {
  final List<Widget> children;
  final Duration swiperDuration;
  final Duration delayStartDuration;
  final Duration delayEndDuration;
  final Function(int index)? onItemTap;

  const VerticalSwiper({
    Key? key,
    required this.children,
    required this.swiperDuration,
    this.delayStartDuration = const Duration(milliseconds: 1500),
    this.delayEndDuration = const Duration(milliseconds: 1500),
    this.onItemTap,
  }) : super(key: key);

  @override
  State<VerticalSwiper> createState() => _VerticalSwiperState();
}

class _VerticalSwiperState extends State<VerticalSwiper> {
  var _index = 0;

  final List<_SlideEndWidget> _Items = [];

  int get realIndex => _index % _Items.length;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _isDisposed = false;
    debugPrint("VerticalSwiper initState");
    _rebuildItems();
  }

  @override
  void dispose() {
    _isDisposed = true;
    debugPrint("VerticalSwiper dispose");
    _Items.clear();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    debugPrint("VerticalSwiper didChangeDependencies");
  }

  @override
  void didUpdateWidget(covariant VerticalSwiper oldWidget) {
    super.didUpdateWidget(oldWidget);
    debugPrint("VerticalSwiper didUpdateWidget");
    if (widget.children != oldWidget.children) {
      _rebuildItems();
    }
  }

  void _rebuildItems() {
    _Items.clear();
    widget.children.asMap().forEach((key, value) {
      _Items.add(_SlideEndWidget(
        key: UniqueKey(),
        child: value,
        index: key,
        delayDuration: widget.delayEndDuration,
        onSlideEnd: (isScrollable) {
          _goNext();
        },
      ));
    });
    _onItemShow(realIndex);
  }

  void _onItemShow(int index) async {
    await Future.delayed(const Duration(milliseconds: 10));
    for (var item in _Items) {
      item.isShown.value = item.index == index;
    }
    //debugPrint("_onItemShow $index");
  }

  void _goNext() async {
    await Future.delayed(widget.delayStartDuration);
    if (_isDisposed) {
      print("_goNext isDisposed");
      return;
    }
    setState(() {
      _index++;
      _onItemShow(-1);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget child = LayoutBuilder(builder: (context, constraint) {
      final height = constraint.minHeight;
      return TweenAnimationBuilder<double>(
        tween: Tween(end: _index.toDouble()),
        curve: Curves.easeInOut,
        duration: widget.swiperDuration,
        onEnd: () {
          //_goNext();
          _onItemShow(realIndex);
        },
        builder: (context, value, child) {
          final len = _Items.length;
          final whole = value ~/ 1; // 取整
          final cur = whole % len;
          final next = (cur + 1) % len;
          final decimal = value - whole;
          return Stack(
            children: [
              PositionedDirectional(
                start: 0,
                end: 0,
                top: -height * decimal,
                child: Opacity(
                  opacity: 1 - decimal,
                  child: Center(child: _Items[cur]),
                ),
              ),
              PositionedDirectional(
                start: 0,
                end: 0,
                top: height * (1 - decimal),
                child: Opacity(
                  opacity: decimal,
                  child: Center(child: _Items[next]),
                ),
              ),
            ],
          );
        },
      );
    });
    if (widget.onItemTap != null) {
      child = GestureDetector(
        child: child,
        onTap: (){
          widget.onItemTap?.call(realIndex);
        },
      );
    }
    return child;
  }
}

class _SlideEndWidget extends StatefulWidget {
  final Widget child;
  final int index;
  final Function(bool isScrollable)? onSlideEnd;
  final ValueNotifier<bool> isShown = ValueNotifier(false);
  final int speed;
  final Duration delayDuration;

  _SlideEndWidget({
    Key? key,
    required this.child,
    required this.index,
    this.onSlideEnd,
    this.speed = 50,
    required this.delayDuration,
  }) : super(key: key);

  @override
  State<_SlideEndWidget> createState() => _SlideEndWidgetState();
}

class _SlideEndWidgetState extends State<_SlideEndWidget> {
  final ScrollController _controller = ScrollController();

  bool? _isCanScroll;

  bool get isAtEnd =>
      _controller.position.pixels == _controller.position.maxScrollExtent;

  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _isDisposed = false;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _isCanScroll = !isAtEnd;
      //_isCanScroll = _controller.position.outOfRange;
      _readySlidEnd();
    });
    _controller.addListener(() {
      final isAtEnd =
          _controller.position.pixels == _controller.position.maxScrollExtent;
      if (isAtEnd) {
        debugPrint(
            "_AutoMarqueeItem onListener ${widget.index} atEnd: ${widget.index}");
        widget.onSlideEnd?.call(true);
      }
    });
    widget.isShown.addListener(_outReady);
  }

  @override
  void dispose() {
    _isDisposed = true;
    _isCanScroll = null;
    _controller.dispose();
    widget.isShown.removeListener(_outReady);
    super.dispose();
  }

  void _outReady() {
    _readySlidEnd();
  }

  void _readySlidEnd() async {
    if (widget.isShown.value) {
      await Future.delayed(widget.delayDuration);
      if (_isDisposed) {
        debugPrint("_AutoMarqueeItem isDisposed");
        return;
      }
      if (_isCanScroll == true) {
        final distance = (_controller.position.maxScrollExtent - _controller.position.minScrollExtent).abs();
        _controller.animateTo(_controller.position.maxScrollExtent,
            duration: Duration(milliseconds: (distance * widget.speed).toInt()), curve: Curves.linear);
      } else if (_isCanScroll == false) {
        widget.onSlideEnd?.call(false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _controller,
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: widget.child,
    );
  }
}
