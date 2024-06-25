import 'package:flutter/material.dart';

import 'alloo_loading.dart';

typedef _LoadingDismissCallback = void Function();

_LoadingDismissCallback? _loadingDismissCallback;

/// 显示loading弹框
void showLoadingDialog(
  BuildContext context, {
  String? text,
  Duration delay = const Duration(milliseconds: 300),
  bool dismissible = false,
}) {
  if (_loadingDismissCallback != null) {
    return;
  }
  showGeneralDialog(
    context: context,
    barrierDismissible: dismissible,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.transparent,
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation) {
      _loadingDismissCallback = () {
        Navigator.of(context).pop();
      };
      return Stack(
        children: [
          _LazyAllooLoading(
            delay: delay,
            text: text ?? '',
            dismissible: dismissible,
          )
        ],
      );
    },
    routeSettings: const RouteSettings(name: '/loading_dialog'),
  ).whenComplete(() {
    _loadingDismissCallback = null;
  });
}

/// 隐藏loading弹框
void hideLoadingDialog() {
  if (_loadingDismissCallback == null) {
    return;
  }
  _loadingDismissCallback?.call();
  _loadingDismissCallback = null;
}

class _LazyAllooLoading extends StatefulWidget {
  const _LazyAllooLoading({
    Key? key,
    required this.delay,
    required this.text,
    required this.dismissible,
  }) : super(key: key);

  final String text;
  final Duration delay;
  final bool dismissible;

  @override
  State<_LazyAllooLoading> createState() => _LazyAllooLoadingState();
}

class _LazyAllooLoadingState extends State<_LazyAllooLoading>
    with SingleTickerProviderStateMixin {
  bool _isShow = false;
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 300),
  );

  @override
  void initState() {
    super.initState();

    Future.delayed(widget.delay, () {
      if (mounted) {
        setState(() {
          _isShow = true;
          _controller.forward();
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Widget child;
    if (_isShow) {
      child = Container(
        width: 88,
        decoration: BoxDecoration(
          color: const Color(0xB2111111),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const AllooLoading(size: 80),
            if (widget.text.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  widget.text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
          ],
        ),
      );
    } else {
      child = const SizedBox();
    }
    return WillPopScope(
      onWillPop: () async {
        return widget.dismissible;
      },
      child: Positioned.fill(
        child: AbsorbPointer(
          absorbing: true,
          child: Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Opacity(
                  opacity: _controller.value,
                  child: child,
                );
              },
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
