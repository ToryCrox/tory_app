import 'package:flutter/material.dart';
import 'package:tory_app/animate/transform_page.dart';
import 'package:tory_base/tory_base.dart';

import 'avatar_spring.dart';
import 'marquee_demo.dart';

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
          RoutePageItem(
            title: "Maqueen例子",
            builder: (context) =>  MarqueeDemo(),
          ),
          RoutePageItem(
            title: "TransformPage",
            builder: (context) =>  TransformPage(),
          ),
        ],
      ),
    );
  }
}
