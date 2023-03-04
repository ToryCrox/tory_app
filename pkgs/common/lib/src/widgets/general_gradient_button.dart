import 'package:flutter/material.dart';

import '../../common.dart';

/// 背景渐变的按钮GeneralGradientButton
/// - 内部的点击使用ThrottleInkWell实现
/// - 内部空间默认居中
/// - 默认字体颜色为Colors.white
/// - 通过[width]设置宽度，可空，默认包裹子控件
/// - 通过[height]设置高度，可空，默认包裹子控件
/// - 通过[constraints]设置约束，可空，默认为null
/// - 通过[color]设置背景颜色, 默认为ThemeData中的primaryColor, 如果设置了[colors]，则[color]会被忽略
/// - 通过[colors]设置渐变色, 默认为null，不为空的时候会覆盖[color]
/// - 通过[begin]设置渐变开始位置, 默认为AlignmentDirectional.centerStart
/// - 通过[end]设置渐变结束位置, 默认为AlignmentDirectional.centerEnd
/// - 通过[disabledColor]设置不可点击时的背景颜色, 默认为ThemeData中的disabledColor
/// - 通过[borderRadius]设置圆角
/// - 通过[border]设置边框, 默认为EdgeInsets.all(8)
/// - 通过[shape]设置形状，例如设置两边半圆用StadiumBorder，如果设置了shape，则[borderRadius]会被忽略
/// - 通过[decoration]设置背景装饰，可空，默认为null，如果设置了，则[color]、[colors]、[border]、[shape]会被忽略
/// - 通过[onTap]设置点击事件
/// - 通过[enable]设置是否可点击
/// - 通过[padding]设置内边距，可空，默认为EdgeInsets.symmetric(horizontal: 16, vertical: 8)
/// - 通过[margin]设置外边距，可空，默认为EdgeInsets.zero

class GeneralGradientButton extends StatelessWidget {
  final Widget child;
  final GestureTapCallback? onTap;
  final Color? color;
  final List<Color>? colors;
  final AlignmentGeometry? begin;
  final AlignmentGeometry? end;
  final Color? disabledColor;
  final double? width;
  final double? height;
  final BoxConstraints? constraints;
  final double? borderRadius;
  final Border? border;
  final ShapeBorder? shape;
  final Decoration? decoration;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final bool enable;

  const GeneralGradientButton({
    Key? key,
    required this.child,
    this.onTap,
    this.color,
    this.colors,
    this.begin,
    this.end,
    this.disabledColor,
    this.width,
    this.height,
    this.constraints,
    this.borderRadius,
    this.border,
    this.shape,
    this.decoration,
    this.padding,
    this.margin,
    this.enable = true,
  }) : super(key: key);

  GeneralGradientButton.text(
    String text, {
    Key? key,
    TextStyle? style,
    this.onTap,
    this.color,
    this.colors,
    this.begin,
    this.end,
    this.disabledColor,
    this.width,
    this.height,
    this.constraints,
    this.borderRadius,
    this.border,
    this.shape,
    this.decoration,
    this.padding,
    this.margin,
    this.enable = true,
  })  : child = Center(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: style,
          ),
        ),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final enable = (this.enable && onTap != null);
    final color = enable
        ? (this.colors?.isNotEmpty == true
            ? null
            : this.color ?? theme.primaryColor)
        : disabledColor ?? theme.disabledColor;
    final colors =
        enable ? (this.colors?.isNotEmpty == true ? this.colors : null) : null;

    final borderRadius = BorderRadius.circular(this.borderRadius ?? 8);
    final Decoration decoration;
    if (this.decoration != null) {
      decoration = this.decoration!;
    } else if (shape != null) {
      decoration = ShapeDecoration(
        shape: shape!,
        color: color,
        gradient:
            colors?.isNotEmpty == true ? LinearGradient(colors: colors!) : null,
      );
    } else {
      decoration = BoxDecoration(
        color: color,
        borderRadius: shape == null ? borderRadius : null,
        border: shape == null ? border : null,
        gradient: colors?.isNotEmpty == true
            ? LinearGradient(
                colors: colors!,
                begin: begin ?? AlignmentDirectional.centerStart,
                end: end ?? AlignmentDirectional.centerEnd,
              )
            : null,
      );
    }
    return Container(
      width: width,
      height: height,
      constraints: constraints,
      margin: margin,
      decoration: decoration,
      child: ThrottleInkWell(
        onTap: enable ? onTap : null,
        padding:
            padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: shape,
        borderRadius: borderRadius,
        child: DefaultTextStyle(
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
          child: child,
        ),
      ),
    );
  }
}
