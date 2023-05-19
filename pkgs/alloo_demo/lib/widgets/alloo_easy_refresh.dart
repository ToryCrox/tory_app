import 'package:alloo_demo/widgets/alloo_loading.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';

class AllooEasyRefresh extends StatefulWidget {
  const AllooEasyRefresh({
    Key? key,
    required this.child,
    required this.onRefresh,
  }) : super(key: key);

  final Widget child;
  final RefreshCallback onRefresh;

  @override
  State<AllooEasyRefresh> createState() => _AllooEasyRefreshState();
}

class _AllooEasyRefreshState extends State<AllooEasyRefresh> {
  final _controller = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: false,
  );

  @override
  Widget build(BuildContext context) {
    return EasyRefresh(
      header: BuilderHeader(
        triggerOffset: 100,
        builder: (BuildContext context, IndicatorState state) {
          print('${state.offset}');
          if (state.mode == IndicatorMode.drag || state.mode == IndicatorMode.processing) {
            return AllooLoading();
          }
          return SizedBox();
        },
        clamping: false,
        position: IndicatorPosition.above,
      ),
      onRefresh: () async {
        await widget.onRefresh();
        _controller.finishRefresh();
      },
      child: widget.child,
    );
  }
}
