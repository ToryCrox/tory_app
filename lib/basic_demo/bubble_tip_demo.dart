import 'package:flutter/material.dart';
import 'package:tory_app/basic_demo/popup_window.dart';

import 'bubble_tip.dart';

class BubbleTipDemo extends StatefulWidget {
  const BubbleTipDemo({Key? key}) : super(key: key);

  @override
  State<BubbleTipDemo> createState() => _BubbleTipDemoState();
}

class _BubbleTipDemoState extends State<BubbleTipDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("气泡组件测试"),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    final direction = PopupDirection.end;
    final align = PopupAlign.start;
    final margin = const EdgeInsetsDirectional.only(
        start: 0, end: 0, top: 0, bottom: 0);
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 0),
      child: Stack(
        children: [
          Center(
            child: PopupWindowButton(
              direction: direction,
              align: align,
              margin: margin,
              buttonBuilder: (BuildContext context) {
                return const Text('Test Popup');
              },
              windowBuilder: (BuildContext context, Animation<double> animation,
                  Animation<double> secondaryAnimation) {
                return FadeTransition(
                  opacity: animation,
                  child: BubbleTipWrapperWidget(
                    direction: direction,
                    align: align,
                    indicator: Icon(Icons.arrow_downward),
                    child: Container(
                      color: Colors.greenAccent,
                      padding: EdgeInsets.all(10),
                      child: Text('TTTTTTTTTTTTTTDDDDDDDDDDDDDEEEEEEEEEEEE'),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
