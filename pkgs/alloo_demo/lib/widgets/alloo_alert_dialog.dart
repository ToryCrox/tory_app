import 'package:alloo_demo/widgets/alloo_gradient_button.dart';
import 'package:flutter/material.dart';

/// Alloo业务自己的dialog弹框，主要用来确认和取消
/// 可以设置标题，内容，取消按钮，确认按钮
/// [title] 标题，可以为空
/// [content] 内容Widget，不允许为空
/// [positiveButton] 确认按钮，不能为空
/// [negativeButton] 取消按钮，可以为空

class AllooAlertDialog extends StatefulWidget {
  final String? title;
  final Widget content;

  const AllooAlertDialog({
    Key? key,
    this.title,
    required this.content,
  }) : super(key: key);

  @override
  State<AllooAlertDialog> createState() => _AllooAlertDialogState();
}

class _AllooAlertDialogState extends State<AllooAlertDialog> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

/// PositiveButton内部由AllooGradientButton实现
/// [text] 按钮文字, 默认为'确认'
/// [child] 自定义的按钮内容，可以为空，为空时使用[text]作为按钮内容
/// [onTap] 点击事件, 可以为空，为空时按钮时点击退出弹框

class PositiveButton extends StatelessWidget {
  final String? text;
  final Widget? child;
  final VoidCallback? onTap;

  const PositiveButton({
    Key? key,
    this.text,
    this.child,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Widget child = Center(child: this.child ?? Text(text ?? '确认'));
    return AllooGradientButton(
        onTap: onTap ??
            () {
              Navigator.of(context).pop();
            },
        child: child);
  }
}
