// @ignore_hardcode

import 'package:flutter/material.dart';
import 'package:tory_app/layout/tab_page.dart';
import 'package:tory_base/tory_base.dart';

import '../basic_demo/sliver/sliver_app_bar_demo_page.dart';

class BasicLayoutPage extends StatefulWidget {
  const BasicLayoutPage({Key? key}) : super(key: key);

  @override
  State<BasicLayoutPage> createState() => _BasicLayoutPageState();
}

class _BasicLayoutPageState extends State<BasicLayoutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("布局类测试"),
      ),
      body: ListView(
        children: [
          RoutePageItem(title: 'TabBar测试', builder: (context) => const TabBarPage(),),
          RoutePageItem(title: 'SliverAppBar测试', builder: (context) => const SliverAppBarDemoPage(),)
        ],
      ),
    );
  }
}
