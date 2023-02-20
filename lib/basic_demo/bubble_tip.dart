import 'dart:math';

import 'package:flutter/material.dart';

import 'popup_window.dart';

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
    double degree = 0;
    if (direction == PopupDirection.top) {
      degree = 0;
    } else if (direction == PopupDirection.bottom) {
      degree = 180;
    } else if (direction.isLeft(context)) {
      degree = 90;
    } else {
      degree = 270;
    }
    final indicatorWrap = Padding(
      padding: padding,
      child: Transform.rotate(angle: pi * degree / 180, child: indicator),
    );
    final List<Widget> children;
    if (direction == PopupDirection.end || direction == PopupDirection.bottom) {
      children = [indicatorWrap, child];
    } else {
      children = [child, indicatorWrap];
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


