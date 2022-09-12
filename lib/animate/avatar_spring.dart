import 'dart:math';

import 'package:flutter/material.dart';

import 'animate_spred_effect.dart';

class AnimatedSpreadPage extends StatefulWidget {
  const AnimatedSpreadPage({Key? key}) : super(key: key);

  @override
  State<AnimatedSpreadPage> createState() => _AnimatedSpreadPageState();
}

class _AnimatedSpreadPageState extends State<AnimatedSpreadPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("自定义扩散动画"),
      ),
      body: Container(
        color: Colors.blue,
        child: Center(
          child: Row(
            children: [
              AnimatedSpreadEffect(
                maxRadius: 300,
                minRadius: 100,
                color: Colors.white,
                ringWidth: 3,
                startOpacity: 0.5,
                isShowCenterCircle: false,
              ),
              Container(
                width: 200,
                  height: 200,
                  color: Colors.amber,
                  child: CustomPaint(painter: TestPainter(),))
            ],
          ),
        ),
      ),
    );
  }
}

class TestPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    print("TestPainter: $size");
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

}