import 'dart:math';

import 'package:flutter/material.dart';

const int _windowPopupDuration = 300;
const double _kWindowCloseIntervalEnd = 2.0 / 3.0;
const Duration _kWindowDuration = Duration(milliseconds: _windowPopupDuration);

typedef AnimatedWidgetBuilder = Widget Function(BuildContext context,
    Animation<double> animation, Animation<double> secondaryAnimation);

class PopupWindowButton<T> extends StatefulWidget {
  const PopupWindowButton({
    Key? key,
    required this.buttonBuilder,
    required this.windowBuilder,
    this.direction,
    this.align,
    this.margin,
    this.duration = 300,
    this.onWindowShow,
    this.onWindowDismiss,
  }) : super(key: key);

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
  PopupWindowButtonState createState() {
    return PopupWindowButtonState();
  }

  static PopupWindowButtonState? of(BuildContext context) {
    final _PopupWindowScope? scope =
    context.dependOnInheritedWidgetOfExactType<_PopupWindowScope>();
    return scope?.state;
  }
}

class PopupWindowButtonState<T> extends State<PopupWindowButton> {
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

class _PopupWindowRoute<T> extends PopupRoute<T> with PopupWindowRoute {
  _PopupWindowRoute({
    required this.position,
    this.anchorContext,
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
    this.dismissible = true,
    this.barrierDuration,
    RouteSettings? settings,
  }) : super(settings: settings);

  @override
  Animation<double> createAnimation() {
    return CurvedAnimation(
      parent: super.createAnimation(),
      curve: Curves.linear,
      reverseCurve: const Interval(0.0, _kWindowCloseIntervalEnd),
    );
  }

  RelativeRect position;
  BuildContext? anchorContext;
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
  bool dismissible;
  final Duration? barrierDuration;

  bool _isShow = false;
  final _popupPageKey = GlobalKey<_PopupPageWidgetState>();

  @override
  Duration get transitionDuration =>
      duration == null ? _kWindowDuration : Duration(milliseconds: duration!);

  @override
  bool get barrierDismissible => dismissible;

  @override
  Color? get barrierColor => Colors.transparent;

  @override
  TickerFuture didPush() {
    _isShow = true;
    onWindowShow?.call();
    if (anchorContext != null) {
      _autoAdjustPositionByAnchor(anchorContext!);
    }
    return super.didPush();
  }

  @override
  bool didPop(T? result) {
    _isShow = false;
    onWindowDismiss?.call();
    return super.didPop(result);
  }

  @override
  Widget buildPage(BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,) {
    return _PopupPageWidget(
      key: _popupPageKey,
      position: position,
      direction: direction,
      align: align,
      margin: margin,
      capturedThemes: capturedThemes,
      builder: (context) => AnimatedBuilder(
        animation: animation,
        builder: (BuildContext context, Widget? child) {
          return capturedThemes
              .wrap(builder(context, animation, secondaryAnimation));
        },
      ),
    );
  }

  void _autoAdjustPositionByAnchor(BuildContext anchorContext) {
    final position = findAnchorPosition(anchorContext);
    if (position != null && this.position != position) {
      this.position = position;
      _popupPageKey.currentState?.updatePosition(position);
      debugPrint('_autoAdjustPositionByAnchor update......');
    }
    if (!_isShow) return;
    WidgetsBinding.instance.addPostFrameCallback((t) {
      try {
        _autoAdjustPositionByAnchor(anchorContext);
      } catch(e) {
        debugPrint('_autoAdjustPositionByAnchor error: $e');
      }
    });
  }
}

class _PopupPageWidget extends StatefulWidget {
  const _PopupPageWidget({
    Key? key,
    required this.position,
    required this.direction,
    required this.align,
    required this.margin,
    required this.capturedThemes,
    required this.builder,
  }) : super(key: key);

  final RelativeRect position;
  final PopupDirection? direction;
  final PopupAlign? align;
  final EdgeInsetsGeometry? margin;
  final CapturedThemes capturedThemes;
  final WidgetBuilder builder;

  @override
  State<_PopupPageWidget> createState() => _PopupPageWidgetState();
}

class _PopupPageWidgetState extends State<_PopupPageWidget> {
  late RelativeRect _position;

  @override
  void initState() {
    super.initState();
    _position = widget.position;
  }

  void updatePosition(RelativeRect position) {
    if (mounted) {
      setState(() {
        _position = position;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomSingleChildLayout(
      delegate: _PopupWindowLayout(
        _position,
        Directionality.of(context),
        widget.direction ?? PopupDirection.bottom,
        widget.align ?? PopupAlign.start,
        widget.margin ?? EdgeInsets.zero,
      ),
      child: widget.builder(context),
    );
  }
}

class _PopupWindowLayout extends SingleChildLayoutDelegate {
  _PopupWindowLayout(this.position,
      this.textDirection,
      this.direction,
      this.align,
      this.margin,);

  // Rectangle of underlying button, relative to the overlay's dimensions.
  RelativeRect position;

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
        maxWidth = biggest.width - position.right;
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
        maxHeight = biggest.height - position.bottom;
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
        x = position.left + margin.left;
      } else if (isAlignRight) {
        x = size.width - position.right - childSize.width - margin.right;
      } else {
        x = (size.width - position.right + position.left) / 2 -
            childSize.width / 2 -
            (margin.left + margin.right) / 2 + margin.left;
      }
    } else if (isLeft) {
      x = position.left - childSize.width - margin.right;
    } else if (isRight) {
      x = size.width - position.right + margin.left;
    }

    double y = 0;
    if (isLeft || isRight) {
      if (align == PopupAlign.start) {
        /// 顶部对齐
        y = position.top + margin.top;
      } else if (align == PopupAlign.end) {
        /// 底部对齐
        y = size.height - position.bottom - childSize.height - margin.bottom;
      } else {
        y = (size.height - position.bottom + position.top) / 2 -
            childSize.height / 2 -
            (margin.top + margin.bottom) / 2 + margin.top;
      }
    } else if (isTop) {
      y = position.top - childSize.height - margin.bottom;
    } else if (isBottom) {
      y = size.height - position.bottom + margin.top;
    }

    return Offset(x, y);
  }

  @override
  bool shouldRelayout(_PopupWindowLayout oldDelegate) {
    return position != oldDelegate.position ||
        textDirection != oldDelegate.textDirection ||
        direction != oldDelegate.direction ||
        align != oldDelegate.align ||
        margin != oldDelegate.margin;
  }
}

class _PopupWindowScope extends InheritedWidget {
  const _PopupWindowScope(
      {Key? key, required this.state, required Widget child})
      : super(key: key, child: child);

  final PopupWindowButtonState state;

  @override
  bool updateShouldNotify(_PopupWindowScope oldWidget) {
    return state != oldWidget.state;
  }
}

PopupWindowRoute<T> showWindow<T>({
  required BuildContext context,
  required RelativeRect position,
  BuildContext? anchorContext,
  int? duration,
  PopupDirection? direction,
  PopupAlign? align,
  EdgeInsetsGeometry? margin,
  String? semanticLabel,
  required AnimatedWidgetBuilder builder,
  VoidCallback? onWindowShow,
  VoidCallback? onWindowDismiss,
  bool dismissible = true,
  Duration? barrierDuration,
  RouteSettings? settings,
}) {
  final NavigatorState navigator = Navigator.of(context);
  final route = _PopupWindowRoute<T>(
    position: position,
    duration: duration,
    anchorContext: anchorContext,
    semanticLabel: semanticLabel,
    barrierLabel: MaterialLocalizations
        .of(context)
        .modalBarrierDismissLabel,
    builder: builder,
    direction: direction,
    align: align,
    margin: margin,
    onWindowShow: onWindowShow,
    onWindowDismiss: onWindowDismiss,
    dismissible: dismissible,
    barrierDuration: barrierDuration,
    settings: settings,
    capturedThemes: InheritedTheme.capture(
      from: context,
      to: navigator.context,
    ),
  );
  navigator.push(route);
  return route;
}

///
/// @anchorContext 相对的Widget对应的Context
/// @followAnchor 是否跟随相对的widget
/// @dismissible 是否可以点击空白处消失
/// @barrierDuration 多长时间内点击空白处不消失，防止误触
PopupWindowRoute<T>? showPopupWindow<T>({
  required BuildContext context,
  required BuildContext anchorContext,
  required AnimatedWidgetBuilder builder,
  PopupDirection? direction,
  PopupAlign? align,
  EdgeInsetsGeometry? margin,
  int? duration,
  VoidCallback? onWindowShow,
  VoidCallback? onWindowDismiss,
  bool followAnchor = false,
  bool dismissible = true,
  Duration? barrierDuration,
  RouteSettings? settings,
}) {
  final RelativeRect? position = findAnchorPosition(anchorContext);
  if (position == null) return null;
  return showWindow<T>(
    context: context,
    position: position,
    anchorContext: followAnchor ? anchorContext : null,
    duration: duration,
    builder: builder,
    direction: direction,
    align: align,
    margin: margin,
    onWindowShow: onWindowShow,
    dismissible: dismissible,
    barrierDuration: barrierDuration,
    settings: settings,
    onWindowDismiss: onWindowDismiss,
  );
}

RelativeRect? findAnchorPosition(BuildContext anchorContext) {
  final RenderBox? button = anchorContext.findRenderObject() as RenderBox?;
  final RenderBox? overlay = Navigator
      .of(anchorContext)
      .overlay
      ?.context
      .findRenderObject() as RenderBox?;
  if (button == null || overlay == null) return null;
  final RelativeRect position = RelativeRect.fromRect(
    Rect.fromPoints(
      button.localToGlobal(Offset.zero, ancestor: overlay),
      button.localToGlobal(button.size.bottomRight(Offset.zero),
          ancestor: overlay),
    ),
    Offset.zero & overlay.size,
  );
  return position;
}

/// 位于目标位置的方位
enum PopupDirection {
  start,
  top,
  end,
  bottom,
}

extension PopupDirectionExt on PopupDirection {
  bool get isHorizontal =>
      this == PopupDirection.start || this == PopupDirection.end;

  bool get isVertical =>
      this == PopupDirection.top || this == PopupDirection.bottom;

  bool isLtr(BuildContext context) =>
      Directionality.of(context) == TextDirection.ltr;

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

mixin PopupWindowRoute<T> on PopupRoute<T> {
  void mayPop() {
    final BuildContext? context = subtreeContext;
    if (context != null) {
      Navigator.of(context).pop();
    }
  }
}
