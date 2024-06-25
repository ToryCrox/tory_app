import 'package:alloo_demo/alloo_demo.dart';
import 'package:common/common.dart';
import 'package:flutter/material.dart';

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
      body: CustomOverlay(child: _buildBody()),
    );
  }

  IOverlayWrapper? _overlayWrapper;

  Widget _buildBody() {
    const direction = PopupDirection.top;
    const align = PopupAlign.end;
    const margin =
        EdgeInsetsDirectional.only(start: 0, end: 10, top: 0, bottom: 0);
    return SizedBox.expand(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          PopupWindowButton(
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
                  indicator: Image.asset(
                    'assets/images/bubble_bottom_indicator_black.png',
                    width: 25,
                    height: 13,
                    color: Colors.greenAccent,
                  ),
                  //const Icon(Icons.arrow_downward),
                  indicatorPadding: 6,
                  child: Container(
                    color: Colors.greenAccent,
                    padding: const EdgeInsets.all(10),
                    child: const Text(
                        'Here you can set whether to enter the room automatically on the table~'),
                  ),
                ),
              );
            },
          ),
          !_showBtn
              ? const SizedBox()
              : ElevatedButton(
                  key: btnKey,
                  onPressed: () async {
                    final context = btnKey.currentContext;
                    if (context == null) return;
                    Future.delayed(const Duration(seconds: 2), () {
                      setState(() {
                        //_showBtn = false;
                      });
                    });
                    _overlayWrapper?.remove();

                    if (true) {
                      _overlayWrapper = showPopupOverlay(
                        context: context,
                        anchorContext: context,
                        align: PopupAlign.start,
                        direction: PopupDirection.end,
                        delayRemove: const Duration(seconds: 2),
                        margin: EdgeInsetsDirectional.only(start: 20, end: 20),
                        builder: (context) {
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.greenAccent,
                            ),
                            padding: const EdgeInsets.all(10),
                            child: const Text(
                                'Here you can set whether to enter the room automatically on the table~'),
                          );
                        },
                      );
                    } else {
                      showAllooBubbleTip(
                        context: context,
                        anchorContext: context,
                        followAnchor: true,
                        dismissible: false,
                        content: const Text(
                            'Here you can set whether to enter the room automatically on the table~'),
                        //autoDismissDuration: const Duration(seconds: 5),
                      );
                    }
                  },
                  child: const Text('Test'),
                ),
        ],
      ),
    );
  }

  final btnKey = GlobalKey();
  bool _showBtn = true;
}
