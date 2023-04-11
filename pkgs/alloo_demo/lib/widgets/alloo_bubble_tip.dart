
import 'package:flutter/material.dart';
import 'package:common/common.dart';
import 'package:flutter_svg/svg.dart';

class _BubbleTip extends StatelessWidget {
  final PopupDirection direction;
  final PopupAlign align;
  final double? arrowPadding;

  final Color? color;

  final Widget content;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;

  final BoxConstraints? constraints;

  const _BubbleTip({
    Key? key,
    required this.direction,
    required this.align,
    required this.content,
    this.arrowPadding,
    this.color,
    this.padding,
    this.borderRadius,
    this.constraints,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BubbleTipWrapperWidget(
      direction: direction,
      align: align,
      indicator: SvgPicture.asset(
        'assets/images/bubble_bottom_indicator_black.svg',
        package: 'alloo_demo',
        width: 19,
        height: 9.59,
        color: color,
      ),
      indicatorPadding: arrowPadding ?? 0,
      child: Container(
        padding: padding,
        constraints: constraints,
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          color: color,
        ),
        child: content,
      ),
    );
  }
}


/// @return cancelable
PopupWindowRoute<T>? showAllooBubbleTip<T>({
  required BuildContext context,
  required BuildContext anchorContext,
  bool followAnchor = false,
  PopupDirection direction = PopupDirection.top,
  PopupAlign align = PopupAlign.end,
  bool dismissible = true,
  EdgeInsetsGeometry? margin,
  Color color = const Color(0xF07039FF),
  double arrowPadding = 13,
  required Widget content,
  EdgeInsetsGeometry contentPadding = const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
  BorderRadius borderRadius = const BorderRadius.all(Radius.circular(6)),
  Duration? autoDismissDuration,
  BoxConstraints? constraints = const BoxConstraints(maxWidth: 192),
}) {
  PopupWindowRoute<T>? route;
  route = showPopupWindow<T>(
    context: context,
    anchorContext: anchorContext,
    followAnchor: followAnchor,
    direction: direction,
    align: align,
    margin: margin,
    dismissible: dismissible,
    settings: const RouteSettings(name: '/popup_window/bubble_tip'),
    builder: (BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation) {
      return FadeTransition(
        opacity: animation,
        child: DefaultTextStyle(
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white,
          ),
          child: _BubbleTip(
            content: content,
            direction: direction,
            align: align,
            arrowPadding: arrowPadding,
            color: color,
            constraints: constraints,
            padding: contentPadding,
            borderRadius: borderRadius,
          ),
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