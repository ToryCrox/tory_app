import 'package:common/common.dart';
import 'package:flutter/material.dart';

/// AllooGradientButton
/// Alloo定制的背景渐变的Button，基于[GeneralGradientButton]，可以设置渐变色，圆角，阴影，边框等
/// - [colors] 默认背景渐变色为[Color(0xFFB77DFF)]到[Color(0xFF7658FF)]，可以修改
/// - [borderRadius] 默认圆角为[BorderRadius.circular(6)]，可以修改
/// - [padding] 默认内边距为[EdgeInsets.symmetric(horizontal: 20, vertical: 10)]，可以修改
/// - [height] 默认高度为[42]，可以修改
/// - [margin] 外边距，默认为null
/// - [onTap] 点击事件

class AllooGradientButton extends GeneralGradientButton {

  const AllooGradientButton({
    Key? key,
    required Widget child,
    required OnTapThrottle onTap,
    TextStyle? textStyle,
    List<Color>? colors,
    Color? color,
    double? borderRadius,
    EdgeInsetsGeometry? padding,
    double? height,
    EdgeInsetsGeometry? margin,
  }) : super(
          key: key,
          onTap: onTap,
          child: child,
          textStyle: textStyle,
          colors: color != null ? null : colors ?? const [Color(0xFFB77DFF), Color(0xFF7658FF)],
          color: color,
          borderRadius: borderRadius ?? 6.0,
          padding: padding ??
              const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          height: height ?? 42,
          margin: margin,
        );

  AllooGradientButton.text({
    Key? key,
    required String text,
    required OnTapThrottle onTap,
    List<Color>? colors,
    TextStyle? textStyle,
    double? borderRadius,
    EdgeInsetsGeometry? padding,
    double? height,
    EdgeInsetsGeometry? margin,
  }) : super(
          key: key,
          onTap: onTap,
          child: Center(child: Text(text)),
          textStyle: textStyle,
          colors: colors ?? const [Color(0xFFB77DFF), Color(0xFF7658FF)],
          borderRadius: borderRadius ?? 6.0,
          padding: padding ??
              const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          height: height ?? 42,
          margin: margin,
        );
}
