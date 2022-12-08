// @dart=2.12

import 'package:banban_demo/assets.dart';
import 'package:flutter/material.dart';

import 'room_welcome_item.dart';

/// 进场横幅UI
class RoomWelcomeItemWidget extends StatelessWidget {

  final RoomWelcomeItem welcome;

  const RoomWelcomeItemWidget({Key? key, required this.welcome})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> res = [];

    // 显示爵位
    if (welcome.isNewer) {
      // 萌新
      res.add(SizedBox.square(dimension: 24,));
      res.add(SizedBox(width: 1,));
    }

    final textStyle = TextStyle(
      color: Color(welcome.fontColor != 0 ? welcome.fontColor: 0xFF041969),
      fontSize: 14,
      fontWeight: FontWeight.w500,
    );
    res.add(Flexible(
        child: Text(
          welcome.name ?? '',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: textStyle,
        )),);

    res.add(SizedBox(width: 2));

    res.add(Text("来了", style: textStyle));

    return SizedBox(
      width: 280,
      height: 56,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(Assets.banban_demo$assets_images_bg_welcome_entry_1_png,
              height: 56, fit: BoxFit.fitHeight),
          Container(
            padding: EdgeInsetsDirectional.only(start: 44),
            alignment: AlignmentDirectional.centerStart,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: res,
            ),
          ),
        ],
      ),
    );
  }
}