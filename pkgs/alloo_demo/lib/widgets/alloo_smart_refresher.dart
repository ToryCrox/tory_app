import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class AllooSmartRefresher extends StatefulWidget {
  const AllooSmartRefresher({
    Key? key,
    required this.child,
    required this.onRefresh,
  }) : super(key: key);

  final Widget child;
  final RefreshCallback onRefresh;

  @override
  State<AllooSmartRefresher> createState() => _AllooSmartRefresherState();
}

class _AllooSmartRefresherState extends State<AllooSmartRefresher> {
  final RefreshController controller = RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: controller,
      header: const ClassicHeader(),
      enablePullDown: true,
      onRefresh: () async {
        await widget.onRefresh();
        controller.refreshCompleted();
      },
      child: widget.child,
    );
  }
}
