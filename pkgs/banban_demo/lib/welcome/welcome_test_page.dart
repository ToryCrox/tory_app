import 'package:banban_demo/welcome/room_welcome_animate_widget.dart';
import 'package:banban_demo/welcome/room_welcome_item.dart';
import 'package:flutter/material.dart';

import 'room_welcome_impl_widget.dart';

class WelcomeTestPage extends StatefulWidget {
  const WelcomeTestPage({Key? key}) : super(key: key);

  @override
  State<WelcomeTestPage> createState() => _WelcomeTestPageState();
}

class _WelcomeTestPageState extends State<WelcomeTestPage> {
  int _animateKey = 0;

  @override
  void initState() {
    super.initState();
    _showNext();
  }

  void _showNext() {
    if (!mounted) return;
    setState(() {
      _animateKey = DateTime.now().millisecondsSinceEpoch;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("入场横幅测试"),
      ),
      body: Container(
        alignment: AlignmentDirectional.centerStart,
        child: RoomWelcomeImplWidget(
          key: ValueKey(_animateKey),
          onComplete: () {
            debugPrint("完成");
            _showNext();
          },
          welcome: const RoomWelcomeItem(
            name: "dfafdfdsfdfdfewtew",
            isNewer: true,
            financeLevel: 1,
            fontColor: 0,
            background:
                "http://bb-admin-test.oss-cn-hangzhou.aliyuncs.com/static/commodity/22120111311528.webp",
          ),
        ),
      ),
    );
  }
}
