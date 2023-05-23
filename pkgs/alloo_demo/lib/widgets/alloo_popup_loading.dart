import 'package:alloo_demo/widgets/alloo_loading.dart';
import 'package:flutter/material.dart';

OverlayEntry? _loadingEntry;
GlobalKey<_LazyAllooLoadingState>? _loadingKey;

Future showPopupAllooLoading(BuildContext context,
    {Duration delay = const Duration(milliseconds: 300)}) async {
  if (_loadingEntry != null) {
    return;
  }
  final overlay = Overlay.of(context);
  if (overlay == null) {
    return;
  }
  print('showPopupAllooLoading');
  final key = GlobalKey<_LazyAllooLoadingState>();
  final entry = OverlayEntry(
    maintainState: true,
    builder: (context) {
      return _LazyAllooLoading(
        key: key,
        delay: delay,
        text: '',
      );
    },
  );
  _loadingKey = key;
  _loadingEntry = entry;
  overlay.insert(entry);
}

Future hidePopupAllooLoading(BuildContext context) async {
  print('hidePopupAllooLoading');
  if (_loadingKey == null || _loadingKey?.currentState == null) {
    return;
  }
  await _loadingKey?.currentState?.dismiss().whenComplete(() {
    _reset();
  });
}

void _reset() {
  _loadingEntry?.remove();
  _loadingKey = null;
  _loadingEntry = null;
}

typedef _LoadingDismissCallback = void Function();

_LoadingDismissCallback? _loadingDismissCallback;

void showLoadingDialog(
  BuildContext context, {
  String? text,
  Duration delay = const Duration(milliseconds: 300),
})  {
  if (_loadingDismissCallback != null) {
    return;
  }
  showGeneralDialog(
    context: context,
    barrierDismissible: false,
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
          )
        ],
      );
    },
    routeSettings: const RouteSettings(name: 'loading_dialog'),
  );
}

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
  }) : super(key: key);

  final String text;
  final Duration delay;

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
    _controller.addStatusListener((status) {
      print('status: $status');
    });

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

  Future dismiss() async {
    if (!_isShow) {
      return;
    }
    await _controller.reverse();
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
        return false;
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
