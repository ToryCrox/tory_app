// @ignore_hardcode

import 'package:flutter/material.dart';

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

        ],
      ),
    );
  }
}
