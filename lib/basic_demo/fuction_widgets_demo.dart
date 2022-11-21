// @ignore_hardcode
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tory_app/widgets/route_page_item.dart';

import 'async_demo_page.dart';

class FunctionWidgetsDemo extends StatefulWidget {
  const FunctionWidgetsDemo({Key? key}) : super(key: key);

  @override
  State<FunctionWidgetsDemo> createState() => _FunctionWidgetsDemoState();
}

class _FunctionWidgetsDemoState extends State<FunctionWidgetsDemo> with WidgetsBindingObserver {
  var _lastPressTime = 0;

  var shareData = SharedData(0);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    debugPrint("FunctionWidgetsDemo initState");
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    debugPrint("FunctionWidgetsDemo dispose");
    super.dispose();
  }

  @override
  void activate() {
    super.activate();
    debugPrint("FunctionWidgetsDemo activate");
  }

  @override
  void deactivate() {
    debugPrint("FunctionWidgetsDemo deactivate");
    super.deactivate();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    debugPrint("FunctionWidgetsDemo didChangeAppLifecycleState: $state");
  }

  @override
  Widget build(BuildContext context) {
    return SharedDataWidget(
      data: shareData,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("功能组件测试"),
        ),
        body: WillPopScope(
            child: createBody(),
            onWillPop: () async {
              final timeStamp = DateTime.now().millisecondsSinceEpoch; // 当前时间戳
              var diff = timeStamp - _lastPressTime;
              debugPrint("当前时间戳: $timeStamp, diff: $diff");
              if (diff < 1000) {
                return true;
              }
              _lastPressTime = timeStamp;
              return false;
            },
        ),
      ),
    );
  }

  Widget createBody() {
    return ListView(
      children: [
        Row(
          children: [
            _TestWidget(),
            IconButton(
              onPressed: () {
                setState(() {
                  shareData = SharedData(shareData.counter + 1);
                });
              },
              icon: const Icon(Icons.thumb_up),
              color: Theme.of(context).primaryColorDark,
            ),
          ],
        ),
        RoutePageItem(title: "异步测试", builder: (context) => AsyncDemoPage(),),
      ],
    );
  }
}

class SharedDataWidget extends InheritedWidget {
  final SharedData data;

  const SharedDataWidget({Key? key, required this.data, required Widget child})
      : super(key: key, child: child);

  static SharedDataWidget? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<SharedDataWidget>();
    // final widget = context
    //     .getElementForInheritedWidgetOfExactType()?.widget;
    // return widget != null ? widget as SharedDataWidget : null;
  }

  @override
  bool updateShouldNotify(covariant SharedDataWidget oldWidget) {
    var isChanged = data != oldWidget.data;
    debugPrint("updateShouldNotify isChanged:$isChanged");
    return isChanged;
  }
}

class SharedData {
  final int counter;

  SharedData(this.counter);
}

class _TestWidget extends StatefulWidget {
  const _TestWidget({Key? key}) : super(key: key);

  @override
  State<_TestWidget> createState() => _TestWidgetState();
}

class _TestWidgetState extends State<_TestWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Text("counter: ${SharedDataWidget.of(context)?.data.counter}"),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    debugPrint("didChangeDependencies _TestWidgetState");
  }
}
