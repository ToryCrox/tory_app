import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class SliverCustomHeader extends StatefulWidget {
  const SliverCustomHeader({Key? key}) : super(key: key);

  @override
  State<SliverCustomHeader> createState() => _SliverCustomHeaderState();
}

class _SliverCustomHeaderState extends State<SliverCustomHeader> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('"自定义Sliver'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return CustomScrollView(
      physics:
          const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      slivers: [
        SliverFlexibleHeader(
          visibleExtent: 200,
          builder: (BuildContext context, double maxExtent, ScrollDirection direction) {
            return Container();
          },
        ),
        _buildSliverList(30),
      ],
    );
  }

  Widget _buildSliverList(int count) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text("$index"),
        );
      },
      itemCount: count,
    );
  }
}

typedef SliverFlexibleHeaderBuilder = Widget Function(
  BuildContext context,
  double maxExtent,
  ScrollDirection direction,
);

class ExtraInfoBoxConstraints<T> extends BoxConstraints {
  ExtraInfoBoxConstraints(
    this.extra,
    BoxConstraints constraints,
  ) : super(
          minWidth: constraints.minWidth,
          minHeight: constraints.minHeight,
          maxWidth: constraints.maxWidth,
          maxHeight: constraints.maxHeight,
        );

  final T extra;

  BoxConstraints asBoxConstraints() => copyWith();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is ExtraInfoBoxConstraints &&
          runtimeType == other.runtimeType &&
          extra == other.extra;

  @override
  int get hashCode => super.hashCode ^ extra.hashCode;
}

class SliverFlexibleHeader extends StatelessWidget {
  const SliverFlexibleHeader({
    Key? key,
    required this.builder,
    required this.visibleExtent,
  }) : super(key: key);

  final SliverFlexibleHeaderBuilder builder;
  final double visibleExtent;

  @override
  Widget build(BuildContext context) {
    return _SliverFlexibleHeader(
      visibleExtent: visibleExtent,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return builder(context, constraints.maxHeight,
              (constraints as ExtraInfoBoxConstraints<ScrollDirection>).extra);
        },
      ),
    );
  }
}

class _SliverFlexibleHeader extends SingleChildRenderObjectWidget {
  final double visibleExtent;

  const _SliverFlexibleHeader({
    Key? key,
    required this.visibleExtent,
    required Widget child,
  }) : super(key: key, child: child);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _SliverFlexibleHeaderSliver(visibleExtent);
  }

  @override
  void updateRenderObject(
      BuildContext context, _SliverFlexibleHeaderSliver renderObject) {
    renderObject._visibleExtent = visibleExtent;
  }
}

class _SliverFlexibleHeaderSliver extends RenderSliverSingleBoxAdapter {
  _SliverFlexibleHeaderSliver(double visibleExtent)
      : _visibleExtent = visibleExtent;

  double _visibleExtent;
  double _lastOverScroll = 0;
  double _lastScrollOffset = 0;

  ScrollDirection _direction = ScrollDirection.idle;

  // 该变量用来确保Sliver完全离开屏幕时会通知child且只通知一次.
  bool _reported = false;

  @override
  void performLayout() {
    // 布局
  }
}
