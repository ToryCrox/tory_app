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

class BubbleTip extends StatelessWidget {
  final PopupDirection direction;
  final PopupAlign align;
  final double? arrowPadding;

  final Color? color;

  final Widget content;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;

  const BubbleTip({
    Key? key,
    required this.direction,
    required this.align,
    required this.content,
    this.arrowPadding,
    this.color,
    this.padding,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BubbleTipWrapperWidget(
      direction: direction,
      align: align,
      indicator: Image.asset(
        'assets/images/bubble_bottom_indicator_black.png',
        width: 25,
        height: 13,
        color: color,
      ),
      indicatorPadding: arrowPadding ?? 0,
      child: Container(
        color: color,
        padding: padding,
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          color: color,
        ),
        child: content,
      ),
    );
  }
}

PopupWindowRoute? showBubbleTip<T>({
  required BuildContext context,
  required BuildContext anchorContext,
  PopupDirection direction = PopupDirection.top,
  PopupAlign align = PopupAlign.end,
  EdgeInsetsGeometry? margin,
  Color? color,
  double arrowPadding = 8,
  required Widget content,
  EdgeInsetsGeometry? contentPadding,
  BorderRadius? borderRadius,
  Duration? autoDismissDuration,
}) {
  PopupWindowRoute? route;
  route = showPopupWindow<T>(
    context: context,
    anchorContext: context,
    direction: direction,
    align: align,
    margin: margin,
    settings: const RouteSettings(name: '/popup_window/bubble_tip'),
    builder: (BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation) {
      return FadeTransition(
        opacity: animation,
        child: BubbleTip(
          content: content,
          direction: direction,
          align: align,
          arrowPadding: arrowPadding,
          color: color,
          padding: contentPadding,
          borderRadius: borderRadius,
        ),
      );
    },
    onWindowDismiss: () {
      route = null;
    },
  );
  if (autoDismissDuration != null) {
    Future.delayed(autoDismissDuration).then((value) {
      route?.mayPop();
    });
  }

  return route;
}
