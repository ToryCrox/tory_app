

import 'package:flutter/material.dart';
import 'package:tory_app/third/location_demo_page.dart';
import 'package:tory_base/tory_base.dart';

class ThirdPackageDemoPage extends StatefulWidget {
  const ThirdPackageDemoPage({Key? key}) : super(key: key);

  @override
  State<ThirdPackageDemoPage> createState() => _ThirdPackageDemoPageState();
}

class _ThirdPackageDemoPageState extends State<ThirdPackageDemoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('三方仓库'),),
      body: ListView(
        children: [
          RoutePageItem(title: '位置获取', builder: (context) => const LocationDemoPage(),),
        ],
      ),
    );
  }
}
