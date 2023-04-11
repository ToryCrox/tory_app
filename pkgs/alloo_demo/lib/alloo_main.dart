

import 'package:flutter/material.dart';
import 'package:tory_base/tory_base.dart';

import 'alloo_picker_test_page.dart';
import 'dialog_test_page.dart';

class AllooMainPage extends StatefulWidget {
  const AllooMainPage({Key? key}) : super(key: key);

  @override
  State<AllooMainPage> createState() => _AllooMainPageState();
}

class _AllooMainPageState extends State<AllooMainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Allo 相关'),),
      body: ListView(
        children: [
          RoutePageItem(
            title: "Dialog相关测试",
            builder: (context) => const AllooTestDialogPage(),
          ),
          RoutePageItem(
            title: "Picker相关测试",
            builder: (context) => const AllooPickerTestPage(),
          ),
        ],
      ),
    );
  }
}
