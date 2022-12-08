// @dart=2.12

import 'package:banban_demo/welcome/room_welcome_animate_widget.dart';
import 'package:banban_demo/welcome/room_welcome_item.dart';
import 'package:banban_demo/welcome/room_welcome_item_widget.dart';
import 'package:flutter/material.dart';

class RoomWelcomeImplWidget extends StatefulWidget {
  final RoomWelcomeItem welcome;
  final VoidCallback? onComplete;

  const RoomWelcomeImplWidget(
      {Key? key, required this.welcome, this.onComplete})
      : super(key: key);

  @override
  State<RoomWelcomeImplWidget> createState() => _RoomWelcomeImplWidgetState();
}

class _RoomWelcomeImplWidgetState extends State<RoomWelcomeImplWidget> {


  @override
  void initState() {
    super.initState();

  }


  @override
  Widget build(BuildContext context) {
    return RoomWelcomeAnimateWidget(
      child: RoomWelcomeItemWidget(
        welcome: widget.welcome,
      ),
      onComplete: widget.onComplete,
    );
  }
}
