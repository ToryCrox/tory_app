import 'package:common/common.dart';
import 'package:flutter/material.dart';

/// AllooButton
/// Alloo定制的的Button, 默认为鳖精渐变的，基于[GeneralGradientButton]，可以设置渐变色，圆角，阴影，边框等
/// - 项目中button基本可以用一下几种构造方法进行构造
/// - [AllooButton] 默认的Button，渐变色为渐变色，圆角为6，内边距为[EdgeInsets.symmetric(horizontal: 20, vertical: 10)]
/// - [AllooButton.gradient] 渐变色为渐变色，圆角为6，具有禁止点击状态
/// - [AllooButton.light] 白色的Button, 文字为浅灰色，圆角为6
/// - [textStyle] 默认文字样式为[TextStyle(color: Colors.white, fontSize: 14)]，可以修改
/// - [colors] 默认背景渐变色为[Color(0xFFB77DFF)]到[Color(0xFF7658FF)]，可以修改
/// - [borderRadius] 默认圆角为[BorderRadius.circular(6)]，可以修改
/// - [padding] 默认内边距为[EdgeInsets.symmetric(horizontal: 20, vertical: 10)]，可以修改
/// - [height] 默认高度为[40]，可以修改
/// - [margin] 外边距，默认为null
/// - [onTap] 点击事件

class AllooButton extends GeneralGradientButton {
  const AllooButton({
    Key? key,
    Widget? child,
    String? text,
    OnTapThrottle? onTap,
    TextStyle? textStyle,
    List<Color>? colors,
    Color? color,
    Color? disabledColor,
    double? borderRadius,
    Border? border,
    EdgeInsetsGeometry? padding,
    double? width,
    double? height,
    EdgeInsetsGeometry? margin,
    bool enable = true,
  }) : super(
          key: key,
          onTap: onTap,
          child: child,
          text: text,
          textStyle: textStyle,
          colors: color != null
              ? null
              : colors ?? const [Color(0xFFB77DFF), Color(0xFF7658FF)],
          color: color,
          border: border,
          disabledColor: disabledColor,
          borderRadius: borderRadius ?? 6.0,
          padding: padding ??
              const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
          width: width,
          height: height ?? 40,
          margin: margin,
          enable: enable,
        );

  /// 彩色渐变的Button
  const AllooButton.gradient({
    Key? key,
    Widget? child,
    String? text,
    OnTapThrottle? onTap,
    bool enable = true,
    TextStyle? textStyle,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
  }) : this(
          key: key,
          child: child,
          text: text,
          onTap: onTap,
          enable: enable,
          textStyle: textStyle,
          disabledColor: const Color(0xFFE3E3E3),
          borderRadius: 6.0,
          margin: margin,
        );

  /// 白色的Button, 文字为浅灰色
  AllooButton.light({
    Key? key,
    Widget? child,
    String? text,
    OnTapThrottle? onTap,
    TextStyle? textStyle,
    List<Color>? colors,
    double? borderRadius,
    EdgeInsetsGeometry? padding,
    double? height,
    EdgeInsetsGeometry? margin,
  }) : this(
          key: key,
          onTap: onTap,
          child: child,
          text: text,
          textStyle: const TextStyle(color: Color(0xFF949494), fontSize: 14)
              .merge(textStyle),
          color: Colors.white,
          margin: margin,
        );

  /// 边框的Button，边框和文字颜色一致, 都是紫色
  AllooButton.outline({
    Key? key,
    Widget? child,
    String? text,
    OnTapThrottle? onTap,
    TextStyle? textStyle,
    double? borderRadius,
    EdgeInsetsGeometry? padding,
    double? height,
    EdgeInsetsGeometry? margin,
  }) : this(
          key: key,
          onTap: onTap,
          child: child,
          text: text,
          textStyle: const TextStyle(color: Color(0xFF7039FF), fontSize: 14)
              .merge(textStyle),
          border: Border.all(color: const Color(0xFF7039FF), width: 1),
          margin: margin,
        );

  // 边框的Button，弱化边框和文字颜色一致
  AllooButton.outlineWeak({
    Key? key,
    Widget? child,
    String? text,
    OnTapThrottle? onTap,
    TextStyle? textStyle,
    double? borderRadius,
    EdgeInsetsGeometry? padding,
    double? height,
    EdgeInsetsGeometry? margin,
  }) : this(
          key: key,
          onTap: onTap,
          child: child,
          text: text,
          textStyle: const TextStyle(color: Color(0xFF313131), fontSize: 14)
              .merge(textStyle),
          border: Border.all(color: const Color(0xFFE3E3E3), width: 1),
          margin: margin,
        );


  /// 旧的Button，渐变色为渐变色，圆角为12，具有禁止点击状态
  const AllooButton.gradientBig({
    Key? key,
    Widget? child,
    String? text,
    OnTapThrottle? onTap,
    bool enable = true,
    TextStyle? textStyle,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
  }) : this(
    key: key,
    child: child,
    text: text,
    onTap: onTap,
    enable: enable,
    textStyle: textStyle ?? const TextStyle(fontSize: 16),
    disabledColor: const Color(0xFFE3E3E3),
    margin: margin,
    height: 56,
    borderRadius: 16,
  );
}
