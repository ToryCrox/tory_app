import 'package:flutter/material.dart';
import 'package:tory_app/widgets/route_page_item.dart';

import 'avatar_spring.dart';

class AnimateMainPage extends StatefulWidget {
  const AnimateMainPage({Key? key}) : super(key: key);

  @override
  State<AnimateMainPage> createState() => _AnimateMainPageState();
}

class _AnimateMainPageState extends State<AnimateMainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("动画测试"),
      ),
      body: ListView(
        children: [
          RoutePageItem(
            title: "头像直播动画",
            builder: (context) => const AnimatedSpreadPage(),
          ),
        ],
      ),
    );
  }
}
