import 'package:flutter/material.dart';
import 'package:tory_app/widgets/route_page_item.dart';

import 'gridview_demo.dart';

// @ignore_hardcode
class SliverNaviPage extends StatelessWidget {
  const SliverNaviPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("滚动组件测试"),
      ),
      body: ListView(
        children: [
          RoutePageItem(
            title: "GridView测试",
            builder: (context) {
              return const GridViewTestPage();
            },
          )
        ],
      ),
    );
  }
}
