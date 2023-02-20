import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

const int _windowPopupDuration = 300;
const double _kWindowCloseIntervalEnd = 2.0 / 3.0;
const Duration _kWindowDuration = Duration(milliseconds: _windowPopupDuration);

typedef AnimatedWidgetBuilder = Widget Function(BuildContext context,
    Animation<double> animation, Animation<double> secondaryAnimation);

class PopupWindowButton<T> extends StatefulWidget {
  const PopupWindowButton(
      {Key? key,
      required this.buttonBuilder,
      required this.windowBuilder,
      this.direction,
      this.align,
      this.margin,
      this.duration = 300,
      this.onWindowShow,
      this.onWindowDismiss})
      : assert(buttonBuilder != null && windowBuilder != null),
        super(key: key);

  /// 显示按钮button
  /// the builder for child,
  /// button which clicked will popup a window
  final WidgetBuilder buttonBuilder;

  final PopupDirection? direction;
  final PopupAlign? align;
  final EdgeInsetsGeometry? margin;

  /// 按钮按钮后到显示window 出现的时间
  /// the transition duration before [buttonBuilder] show up
  final int duration;

  /// 需要显示的window
  /// the target window
  final AnimatedWidgetBuilder windowBuilder;

  final VoidCallback? onWindowShow;

  final VoidCallback? onWindowDismiss;

  @override
  _PopupWindowButtonState createState() {
    return _PopupWindowButtonState();
  }

  static _PopupWindowButtonState? of(BuildContext context) {
    final _PopupWindowScope? scope =
        context.dependOnInheritedWidgetOfExactType<_PopupWindowScope>();
    return scope?.state;
  }
}

class _PopupWindowButtonState<T> extends State<PopupWindowButton> {
  void showPopup() {
    showPopupWindow<T>(
      context: context,
      anchorContext: context,
      direction: widget.direction,
      align: widget.align,
      margin: widget.margin,
      duration: widget.duration,
      builder: widget.windowBuilder,
      onWindowShow: widget.onWindowShow,
      onWindowDismiss: widget.onWindowDismiss,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _PopupWindowScope(
        state: this,
        child: InkWell(
          onTap: showPopup,
          child: widget.buttonBuilder.call(context),
        ));
  }
}

class _PopupWindowRoute<T> extends PopupRoute<T> {
  _PopupWindowRoute({
    required this.position,
    this.direction,
    this.align,
    this.margin,
    this.barrierLabel,
    this.semanticLabel,
    this.duration,
    required this.builder,
    this.onWindowShow,
    this.onWindowDismiss,
    required this.capturedThemes,
    this.constraints,
  });

  @override
  Animation<double> createAnimation() {
    return CurvedAnimation(
        parent: super.createAnimation(),
        curve: Curves.linear,
        reverseCurve: const Interval(0.0, _kWindowCloseIntervalEnd));
  }

  final RelativeRect position;
  final PopupDirection? direction;
  final PopupAlign? align;
  final EdgeInsetsGeometry? margin;
  final String? semanticLabel;
  @override
  final String? barrierLabel;
  final int? duration;
  final AnimatedWidgetBuilder builder;
  final VoidCallback? onWindowShow;
  final VoidCallback? onWindowDismiss;
  final CapturedThemes capturedThemes;
  final BoxConstraints? constraints;

  @override
  Duration get transitionDuration =>
      duration == null ? _kWindowDuration : Duration(milliseconds: duration!);

  @override
  bool get barrierDismissible => true;

  @override
  Color? get barrierColor => null;

  @override
  bool didPop(T? result) {
    onWindowDismiss?.call();
    return super.didPop(result);
  }

  @override
  TickerFuture didPush() {
    onWindowShow?.call();
    return super.didPush();
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return CustomSingleChildLayout(
      delegate: _PopupWindowLayout(
        position,
        Directionality.of(context),
        direction ?? PopupDirection.bottom,
        align ?? PopupAlign.start,
        margin ?? EdgeInsets.zero,
      ),
      child: AnimatedBuilder(
          animation: animation,
          builder: (BuildContext context, Widget? child) {
            return capturedThemes
                .wrap(builder(context, animation, secondaryAnimation));
          }),
    );
  }
}

class _PopupWindowLayout extends SingleChildLayoutDelegate {
  _PopupWindowLayout(this.position, this.textDirection, this.direction,
      this.align, this.margin);

  // Rectangle of underlying button, relative to the overlay's dimensions.
  final RelativeRect position;

  final TextDirection textDirection;
  final PopupDirection direction;
  final PopupAlign align;
  final EdgeInsetsGeometry margin;

  // We put the child wherever position specifies, so long as it will fit within
  // the specified parent size padded (inset) by 8. If necessary, we adjust the
  // child's position so that it fits.

  bool get isLtr => textDirection == TextDirection.ltr;

  bool get isAlignLeft =>
      (isLtr && align == PopupAlign.start) ||
      (!isLtr && align == PopupAlign.end);

  bool get isAlignRight =>
      (isLtr && align == PopupAlign.end) ||
      (!isLtr && align == PopupAlign.start);

  bool get isLeft =>
      (isLtr && direction == PopupDirection.start) ||
      (!isLtr && direction == PopupDirection.end);

  bool get isRight =>
      (isLtr && direction == PopupDirection.end) ||
      (!isLtr && direction == PopupDirection.start);

  bool get isTop => direction == PopupDirection.top;

  bool get isBottom => direction == PopupDirection.bottom;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    // The menu can be at most the size of the overlay minus 8.0 pixels in each
    // direction.

    /// 计算剩余空间
    final margin = this.margin.resolve(textDirection);
    final biggest = constraints.biggest;
    double maxWidth = biggest.width;

    if (isTop || isBottom) {
      if (isAlignLeft) {
        maxWidth = biggest.width - position.left;
      } else if (isAlignRight) {
        /// 右对齐
        maxWidth = position.right;
      } else {
        /// 居中对齐
        maxWidth = biggest.width -
            position.left -
            position.right +
            min(position.left, position.right) * 2;
      }
    } else if (isLeft) {
      maxWidth = position.left;
    } else if (isRight) {
      maxWidth = position.right;
    }
    maxWidth = maxWidth - margin.horizontal;

    double maxHeight = biggest.height;
    if (isLeft || isRight) {
      if (align == PopupAlign.start) {
        /// 顶部对齐
        maxHeight = biggest.height - position.top;
      } else if (align == PopupAlign.end) {
        maxHeight = position.bottom;
      } else {
        maxHeight = biggest.height -
            position.top -
            position.bottom +
            min(position.top, position.bottom) * 2;
      }
    } else if (isTop) {
      maxHeight = position.top;
    } else if (isBottom) {
      maxHeight = position.bottom;
    }

    print('getConstraintsForChild:  $maxWidth, $maxHeight');
    return BoxConstraints.loose(Size(maxWidth, maxHeight));
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    // size: The size of the overlay.
    // childSize: The size of the menu, when fully open, as determined by
    // getConstraintsForChild.

    final margin = this.margin.resolve(textDirection);

    double x = 0;
    if (isTop || isBottom) {
      if (isAlignLeft) {
        x = position.left;
      } else if (isAlignRight) {
        x = size.width - position.right - childSize.width;
      } else {
        x = (size.width - position.right + position.left) / 2 -
            childSize.width / 2 -
            (margin.left + margin.right) / 2;
      }
    } else if (isLeft) {
      x = 0;
    } else if (isRight) {
      x = size.width - position.right;
    }
    x += margin.left;

    double y = 0;
    if (isLeft || isRight) {
      if (align == PopupAlign.start) {
        /// 顶部对齐
        y = position.top;
      } else if (align == PopupAlign.end) {
        /// 底部对齐
        y = size.height - position.bottom;
      } else {
        y = (size.height - position.bottom + position.top) / 2 -
            childSize.height / 2 -
            (margin.top + margin.bottom) / 2;
      }
    } else if (isTop) {
      y = position.top - childSize.height;
    } else if (isBottom) {
      y = size.height - position.bottom;
    }
    y += margin.top;
    print(
        'getPositionForChild: $x, ${size.width}, childWidth:${childSize.width}');

    return Offset(x, y);
  }

  @override
  bool shouldRelayout(_PopupWindowLayout oldDelegate) {
    return position != oldDelegate.position;
  }
}

class _PopupWindowScope extends InheritedWidget {
  const _PopupWindowScope(
      {Key? key, required this.state, required Widget child})
      : super(key: key, child: child);

  final _PopupWindowButtonState state;

  @override
  bool updateShouldNotify(_PopupWindowScope oldWidget) {
    return state != oldWidget.state;
  }
}

Future<T?> showWindow<T>({
  required BuildContext context,
  required RelativeRect position,
  int? duration,
  PopupDirection? direction,
  PopupAlign? align,
  EdgeInsetsGeometry? margin,
  String? semanticLabel,
  required AnimatedWidgetBuilder builder,
  VoidCallback? onWindowShow,
  VoidCallback? onWindowDismiss,
}) {
  final NavigatorState navigator = Navigator.of(context);
  return navigator.push(
    _PopupWindowRoute<T>(
      position: position,
      duration: duration,
      semanticLabel: semanticLabel,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      builder: builder,
      direction: direction,
      align: align,
      margin: margin,
      onWindowShow: onWindowShow,
      onWindowDismiss: onWindowDismiss,
      capturedThemes:
          InheritedTheme.capture(from: context, to: navigator.context),
    ),
  );
}

Future<T?> showPopupWindow<T>({
  required BuildContext context,
  required BuildContext anchorContext,
  required AnimatedWidgetBuilder builder,
  PopupDirection? direction,
  PopupAlign? align,
  EdgeInsetsGeometry? margin,
  int? duration,
  VoidCallback? onWindowShow,
  VoidCallback? onWindowDismiss,
}) async {
  final RenderBox? button = anchorContext.findRenderObject() as RenderBox?;
  final RenderBox? overlay =
      Navigator.of(context).overlay?.context.findRenderObject()! as RenderBox?;
  if (button == null || overlay == null) return null;
  final RelativeRect position = RelativeRect.fromRect(
    Rect.fromPoints(
      button.localToGlobal(Offset.zero, ancestor: overlay),
      button.localToGlobal(button.size.bottomRight(Offset.zero),
          ancestor: overlay),
    ),
    Offset.zero & overlay.size,
  );
  print('showPopupWindow: $position， ${overlay.size}');
  return await showWindow<T>(
      context: context,
      position: position,
      duration: duration,
      builder: builder,
      direction: direction,
      align: align,
      margin: margin,
      onWindowShow: onWindowShow,
      onWindowDismiss: onWindowDismiss);
}

/// 位于目标位置的方位
enum PopupDirection {
  start,
  top,
  end,
  bottom,
}

extension PopupDirectionExt on PopupDirection {

  bool get isHorizontal => this == PopupDirection.start || this == PopupDirection.end;

  bool get isVertical => this == PopupDirection.top || this == PopupDirection.bottom;

  bool isLtr(BuildContext context) => Directionality.of(context) == TextDirection.ltr;

  bool isLeft(BuildContext context) =>
      (isLtr(context) && this == PopupDirection.start) ||
          (!isLtr(context) && this == PopupDirection.end);

  bool isRight(BuildContext context) =>
      (isLtr(context) && this == PopupDirection.end) ||
          (!isLtr(context) && this == PopupDirection.start);
}

/// 位于目标位置的对齐
enum PopupAlign {
  start,
  center,
  end,
}

