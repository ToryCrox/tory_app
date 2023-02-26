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
    final direction = PopupDirection.top;
    final align = PopupAlign.end;
    final margin =
        const EdgeInsetsDirectional.only(start: 0, end: 10, top: 0, bottom: 0);
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 0),
      child: Stack(
        children: [
          Center(
            // child: PopupWindowButton(
            //   direction: direction,
            //   align: align,
            //   margin: margin,
            //   buttonBuilder: (BuildContext context) {
            //     return const Text('Test Popup');
            //   },
            //   windowBuilder: (BuildContext context, Animation<double> animation,
            //       Animation<double> secondaryAnimation) {
            //     return FadeTransition(
            //       opacity: animation,
            //       child: BubbleTipWrapperWidget(
            //         direction: direction,
            //         align: align,
            //         indicator: Image.asset(
            //           'assets/images/bubble_bottom_indicator_black.png',
            //           width: 25,
            //           height: 13,
            //           color: Colors.greenAccent,
            //         ),
            //         //const Icon(Icons.arrow_downward),
            //         indicatorPadding: 6,
            //         child: Container(
            //           color: Colors.greenAccent,
            //           padding: EdgeInsets.all(10),
            //           child: Text('TTTTTTTTTTTTTTDDDDDDDDDDDDDEEEEEEEEEEEE'),
            //         ),
            //       ),
            //     );
            //   },
            // ),
            child: ElevatedButton(
              key: btnKey,
              onPressed: () {
                final context = btnKey.currentContext;
                if (context == null) return;
                showBubbleTip(
                  context: context,
                  anchorContext: context,
                  followAnchor: true,
                  content: const Text(
                      'Here you can set whether to enter the room automatically on the table~'),
                  //autoDismissDuration: const Duration(seconds: 5),
                );
              },
              child: Text('Test'),
            ),
          )
        ],
      ),
    );
  }

  final btnKey = GlobalKey();
}
