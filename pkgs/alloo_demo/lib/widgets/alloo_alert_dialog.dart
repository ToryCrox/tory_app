import 'dart:async';

import 'package:alloo_demo/widgets/alloo_gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Alloo业务自己的dialog弹框，主要用来确认和取消
/// - 可以设置标题，内容，取消按钮，确认按钮
/// - [title] 标题，可以为空
/// - [content] 内容Widget，不允许为空，内容的字体颜色和大小在有标题和无标题时不一样，
/// 有标题时为[Color(0xFF949494)]，字号14, 无标题时为[Color(0xFF313131)]， 字号16
/// - [positiveButton] 确认按钮，不能为空, 默认为[AllooPositiveButton]
/// - [negativeButton] 取消按钮，可以为空
/// - [positiveButton] 和 [negativeButton] 上下排列
/// - [showClose] 是否显示右上角关闭按钮，默认为false

class AllooAlertDialog extends StatelessWidget {
  final String? title;
  final Widget content;
  final bool showClose;
  final bool showDefaultBackground;
  final AllooPositiveButton positiveButton;
  final AllooNegativeButton? negativeButton;

  const AllooAlertDialog({
    Key? key,
    this.title,
    required this.content,
    this.positiveButton = const AllooPositiveButton(),
    this.negativeButton,
    this.showClose = false,
    this.showDefaultBackground = true,
  }) : super(key: key);

  /// 显示Alloo自定义的确认弹框
  /// - [context] BuildContext
  /// - [title] 标题，可以为空
  /// - [content], [contentText], [contentRich] 都是内容设置，只能有一个且不为空， 内容有默认的文字颜色和字号，并且在有标题和无标题时不一样
  /// - [content] 内容Widget, 可使用富文本，建议不要使用RichText，
  /// 因为RichText不会继承父级的TextStyle
  /// 可以使用Text.rich()来实现
  /// - [contentText] 内容文本，当[content]为空时，使用[contentText]作为内容
  /// - [contentRich] 内容富文本，当[content]为空时，使用[contentRich]作为内容
  /// - [content]和[contentText][contentRich]不能同时为空
  /// - [positiveButton] 确认按钮, 默认为[AllooPositiveButton], 不会为空， 默认文字为'确认'
  /// - [positiveText] 确认按钮的文字，当[positiveButton]为空时，使用[positiveText]作为确认按钮的文字
  /// - [negativeButton] 取消按钮，可以为空, 默认是不展示的，如果需要展示可以直接使用AllooNegativeButton(), 默认文字为'取消'
  /// - [negativeText] 取消按钮的文字，当[negativeButton]为空时，使用[negativeText]作为取消按钮的文字
  /// - [showDefaultBackground] 是否显示默认的背景，默认为true
  /// - [showClose] 是否显示右上角关闭按钮，默认为false
  /// - [dismissible] 点击空白区域是否可以关闭弹框，默认为true
  /// - 返回值为bool?类型，注意可以为null, 点击确认按钮返回true，点击取消按钮返回false，点击空白区域返回null
  static Future<bool?> show({
    required BuildContext context,
    String? title,
    Widget? content,
    String? contentText,
    List<InlineSpan>? contentRich,
    AllooPositiveButton? positiveButton,
    String? positiveText,
    AllooNegativeButton? negativeButton,
    String? negativeText,
    bool showDefaultBackground = true,
    bool showClose = false,
    bool dismissible = true,
    AllooAlertDialogController? controller,
  }) async {
    assert(content != null || contentText != null || contentRich != null,
    'content and contentText cannot be null at the same time');

    final Widget contentWidget;
    if (content != null) {
      contentWidget = content;
    } else if (contentRich != null) {
      contentWidget = Text.rich(
        TextSpan(children: contentRich),
        textAlign: TextAlign.center,
      );
    } else {
      contentWidget = Text(
        contentText ?? '',
        textAlign: TextAlign.center,
      );
    }
    final result = await showGeneralDialog<bool>(
      context: context,
      barrierDismissible: dismissible,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      pageBuilder: (context, animation, secondaryAnimation) {
        controller?._dialogContext = context;
        return AllooAlertDialog(
          title: title,
          content: contentWidget,
          positiveButton: positiveButton ??
              (positiveText != null
                  ? AllooPositiveButton(text: positiveText)
                  : const AllooPositiveButton()),
          negativeButton: negativeButton ??
              (negativeText != null
                  ? AllooNegativeButton(text: negativeText)
                  : null),
          showClose: showClose,
          showDefaultBackground: showDefaultBackground,
        );
      },
    );
    controller?._dialogContext = null;
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          children: [
            if (showDefaultBackground)
              PositionedDirectional(
                top: 0,
                start: 0,
                end: 0,
                child: Image.asset(
                  'assets/images/alloo_alert_dialog_background.webp',
                  package: 'alloo_demo',
                  fit: BoxFit.fitWidth,
                ),
              ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(20, 30, 20, 10),
              child: _buildBody(),
            ),
            if (showClose)
              PositionedDirectional(
                top: 0,
                end: 0,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: SvgPicture.asset(
                      'assets/images/ic_close.svg',
                      package: 'alloo_demo',
                      width: 24,
                      height: 24,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Column _buildBody() {
    final isTitleEmpty = title == null || title!.isEmpty;
    final hasNegativeButton = negativeButton != null;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (!isTitleEmpty)
          DefaultTextStyle(
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF313131),
            ),
            child: Text(title!, textAlign: TextAlign.center),
          ),
        if (!isTitleEmpty) const SizedBox(height: 16),

        /// 内容的字体颜色和大小在有标题和无标题时不一样，
        DefaultTextStyle(
          style: TextStyle(
            color: isTitleEmpty
                ? const Color(0xFF313131)
                : const Color(0xFF949494),
            fontSize: isTitleEmpty ? 16 : 14,
          ),
          child: content,
        ),
        const SizedBox(height: 22),
        positiveButton,
        hasNegativeButton
            ? const SizedBox(height: 4)
            : const SizedBox(height: 10),
        if (hasNegativeButton) negativeButton!,
      ],
    );
  }
}

/// PositiveButton内部由AllooGradientButton实现
/// [text] 按钮文字, 默认为'确认'
/// [child] 自定义的按钮内容，可以为空，为空时使用[text]作为按钮内容
/// [onTap] 点击事件, 可以为空，为空时按钮时点击退出弹框

class AllooPositiveButton extends StatelessWidget {
  final String? text;
  final Widget? child;
  final FutureOr<bool> Function()? onTap;

  const AllooPositiveButton({
    Key? key,
    this.text,
    this.child,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Widget child = Center(child: this.child ?? Text(text ?? '确认'));
    return AllooGradientButton(
      onTap: () async {
        final popContext= context;
        if ((await onTap?.call()) ?? true) {
          Navigator.of(popContext).pop(true);
        }
      },
      child: child,
    );
  }
}

/// AllooNegativeButton内部由AllooGradientButton实现
/// [text] 按钮文字, 默认为'取消'
/// [child] 自定义的按钮内容，可以为空，为空时使用[text]作为按钮内容
class AllooNegativeButton extends StatelessWidget {
  final String? text;
  final Widget? child;
  final FutureOr<bool> Function()? onTap;

  const AllooNegativeButton({
    Key? key,
    this.text,
    this.child,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Widget child = Center(child: this.child ?? Text(text ?? '取消'));
    return AllooGradientButton(
        color: Colors.white,
        textStyle: const TextStyle(color: Color(0xFF313131)),
        margin: EdgeInsets.zero,
        onTap: () async {
          final popContext = context;
          if ((await onTap?.call()) ?? true) {
            Navigator.of(popContext).pop(false);
          }
        },
        child: child,
    );
  }
}


/// AllooAlertDialog关闭的控制类，可以通过此类关闭弹框
class AllooAlertDialogController {
  BuildContext? _dialogContext;

  AllooAlertDialogController();

  /// 关闭弹框
  void close() {
    final context = _dialogContext;
    if (context != null) {
      Navigator.of(context).pop();
    }
  }
}