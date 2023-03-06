import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// alloo自定的CheckBox
/// - 选中和未选中使用对应的图片，不使用系统的CheckBox，在选中和未选中状态切换时有渐变动画, AnimationSwitcher
/// - 可以在CheckBox的右边添加一个Widget
/// - **注意**: 右边的Widget如果是一个Text，则很有可能是是多行的，导致CheckBox和Text不在同一行，
/// 默认情况下，CheckBox和Text之间上下居中对齐，如果要让CheckBox和Text在同一行，可以使用padding来调整
/// - [value] 选中状态, 可以为空，为空时默认为false
/// - [controller] 控制器，可以为空，为空时使用内部的控制器
/// - [onChanged] 状态改变回调
/// - [enableTap] 是否允许点击，默认为true
/// - [size] 图片大小, 默认为14
/// - [padding] CheckBox的padding，默认为EdgeInsets.zero
/// - [child] 可以在CheckBox的右边添加一个Widget
/// - [space] child和CheckBox之间的间距，默认为6

class AllooCheckBox extends StatelessWidget {
  AllooCheckBox({
    Key? key,
    bool value = false,
    AllooCheckBoxController? controller,
    this.onChanged,
    this.enableTap = true,
    this.size = 14,
    this.padding,
    this.child,
    this.space = 6,
  })  : controller = controller ?? AllooCheckBoxController(value),
        super(key: key);

  final AllooCheckBoxController controller;
  final ValueChanged<bool>? onChanged;
  final bool enableTap;
  final double size;
  final EdgeInsetsGeometry? padding;
  final Widget? child;
  final double space;

  @override
  Widget build(BuildContext context) {
    Widget child = ValueListenableBuilder<bool>(
      valueListenable: controller,
      builder: (context, value, child) {
        final assetName = value ? 'assets/images/ic_check_box_selected.svg'
            : 'assets/images/ic_check_box_unselected.svg';
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: SvgPicture.asset(
            assetName,
            key: ValueKey(value ? 'selected' : 'unselected'),
            package: 'alloo_demo',
            width: size,
            height: size,
          ),
        );
      },
    );
    if (padding != null) {
      child = Padding(padding: padding!, child: child);
    }
    if (this.child != null) {
      child = Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: padding != null ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          child,
          SizedBox(width: space),
          Flexible(child: this.child!),
        ],
      );
    }
    if (enableTap) {
      child = GestureDetector(
        onTap: () {
          controller.value = !controller.value;
          onChanged?.call(controller.value);
        },
        child: child,
      );
    }
    return child;
  }
}

/// alloo自定的CheckBox的控制类
class AllooCheckBoxController extends ValueNotifier<bool> {
  AllooCheckBoxController(bool value) : super(value);
}
