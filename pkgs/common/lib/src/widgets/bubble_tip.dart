import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'popup_window.dart';

/// 气泡提示控件
/// 可以设置气泡的方向和对齐方式
/// - [direction] 气泡相对控件的位置，上下左右
/// - [align] 气泡相对控件的对齐方式, 左对齐或者右对齐
/// - [indicator] 气泡的指示器，可以是一个控件，也可以是一个图片，一般是一个三角形
/// - [indicatorPadding] 气泡指示器的距离对齐边缘的距离，
/// 如果align是start，那么气泡指示器距离控件的左边缘的距离，
/// 如果align是end，那么气泡指示器距离控件的右边缘的距离
class BubbleTipWrapperWidget extends StatelessWidget {
  final PopupDirection direction;
  final PopupAlign align;
  final Widget child;
  final Widget indicator;
  final double indicatorPadding;

  const BubbleTipWrapperWidget({
    Key? key,
    required this.direction,
    required this.align,
    required this.child,
    required this.indicator,
    this.indicatorPadding = 12,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    EdgeInsetsGeometry padding;
    if (direction.isHorizontal) {
      padding = EdgeInsetsDirectional.only(
        top: align == PopupAlign.start ? indicatorPadding : 0,
        bottom: align == PopupAlign.end ? indicatorPadding : 0,
      );
    } else {
      padding = EdgeInsetsDirectional.only(
        start: align == PopupAlign.start ? indicatorPadding : 0,
        end: align == PopupAlign.end ? indicatorPadding : 0,
      );
    }
    int quarterTurns = 0;
    if (direction == PopupDirection.top) {
      quarterTurns = 0;
    } else if (direction == PopupDirection.bottom) {
      quarterTurns = 2;
    } else if (direction.isLeft(context)) {
      quarterTurns = 3;
    } else {
      quarterTurns = 1;
    }
    final indicatorWrap = Padding(
      padding: padding,
      child: RotatedBox(quarterTurns: quarterTurns, child: indicator),
    );
    final List<Widget> children;
    if (direction == PopupDirection.end || direction == PopupDirection.bottom) {
      children = [indicatorWrap, Flexible(child: child)];
    } else {
      children = [Flexible(child: child), indicatorWrap];
    }
    return Flex(
      mainAxisSize: MainAxisSize.min,
      direction: direction.isHorizontal ? Axis.horizontal : Axis.vertical,
      crossAxisAlignment: align == PopupAlign.start
          ? CrossAxisAlignment.start
          : align == PopupAlign.end
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.center,
      children: children,
    );
  }
}
