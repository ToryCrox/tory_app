// @ignore_hardcode

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tory_app/layout/tab_page.dart';
import 'package:tory_base/tory_base.dart';

import '../basic_demo/sliver/sliver_app_bar_demo_page.dart';
import 'widget/custom_spin_wheel.dart';

class BasicLayoutPage extends StatefulWidget {
  const BasicLayoutPage({Key? key}) : super(key: key);

  @override
  State<BasicLayoutPage> createState() => _BasicLayoutPageState();
}

class _BasicLayoutPageState extends State<BasicLayoutPage> {


  final SpinWheelController _controller = SpinWheelController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("布局类测试"),
      ),
      body: ListView(
        children: [
          RoutePageItem(
            title: 'TabBar测试',
            builder: (context) => const TabBarPage(),
          ),
          RoutePageItem(
            title: 'SliverAppBar测试',
            builder: (context) => const SliverAppBarDemoPage(),
          ),
          CustomSpinWheel(
            controller: _controller,
            center: const Text('center'),
            children: <Widget>[
              for (int i = 0; i < 10; i++)
                Container(
                  alignment: Alignment.center,
                  child: Text('$i'),
                ),
            ],
            builder: (context, index, child, state) {
              Color color = Colors.primaries[index % Colors.primaries.length];
              if (state == SpinWheelChildState.selected) {
                color = Colors.black;
              } else if (state == SpinWheelChildState.ticker) {
                color = Colors.grey;
              }
              return Container(
                child: child,
                color: color,
              );
            },
          ),
          ElevatedButton(
            onPressed: () {
              if (_controller.state == SpinWheelState.idle) {
                _controller.startTicker();
              } else if (_controller.state == SpinWheelState.ticker) {
                _controller.prepareLottery();
              } else if (_controller.state == SpinWheelState.lotteryPrepare){
                _controller.startLottery(Random().nextInt(8));
              } else {
                _controller.startTicker();
              }
            },
            child: Text(wheelStateText),
          ),
        ],
      ),
    );
  }

  String get wheelStateText {
    if (_controller.state == SpinWheelState.idle) {
      return '开始';
    } else if (_controller.state == SpinWheelState.ticker) {
      return '开始抽奖';
    } else if (_controller.state == SpinWheelState.lotteryPrepare) {
      return '抽奖中...';
    } else if (_controller.state == SpinWheelState.lotteryStart){
      return '抽奖中......';
    } else if (_controller.state == SpinWheelState.lotteryEnd) {
      return '抽奖结束';
    } else {
      return '重新开始';
    }
  }
}
