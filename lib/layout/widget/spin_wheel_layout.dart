import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';

class SpinWheelLayout extends StatelessWidget {
  const SpinWheelLayout({
    super.key,
    this.width,
    this.height,
    this.padding,
    this.center,
    required this.children,
    this.horizontalCount,
    this.verticalCount,
    this.horizontalSpacing,
    this.verticalSpacing,
    this.childAspectRatio,
  })  : assert(horizontalCount == null || horizontalCount >= 3,
            'horizontalCount must be greater than or equal to 3.'),
        assert(verticalCount == null || verticalCount >= 3,
            'verticalCount must be greater than or equal to 3.'),
        assert(horizontalSpacing == null || horizontalSpacing >= 0,
            'horizontalSpacing must be greater than or equal to 0.'),
        assert(verticalSpacing == null || verticalSpacing >= 0,
            'verticalSpacing must be greater than or equal to 0.'),
        assert(childAspectRatio == null || childAspectRatio > 0,
            'childAspectRatio must be greater than 0.'),
        assert(
            children.length <=
                (2 * (horizontalCount ?? 3) + 2 * (verticalCount ?? 3) - 4),
            'children.length must be equal to horizontalCount * verticalCount.');

  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;

  /// 节点宽高比
  final double? childAspectRatio;

  /// 中心节点
  final Widget? center;

  /// 四周的节点
  final List<Widget> children;

  /// 横向数量, 必须大于等于3，默认为3
  final int? horizontalCount;

  /// 纵向数量， 必须大于等于3，默认为3
  final int? verticalCount;

  /// 横向间距
  final double? horizontalSpacing;

  /// 纵向间距
  final double? verticalSpacing;

  static const String _centerLayoutIdPrefix = 'center#';
  static const String _childLayoutIdPrefix = 'child#';

  String _toWidgetId(Widget? widget, String prefix) {
    final String type = objectRuntimeType(widget, 'Widget');
    final key = widget?.key;
    return key == null ? prefix + type : '$prefix$type-$key';
  }

  @override
  Widget build(BuildContext context) {
    final centerLayoutId = _toWidgetId(center, _centerLayoutIdPrefix);
    final childrenLayoutIds = [
      for (int i = 0; i < children.length; i++)
        _toWidgetId(children[i], _childLayoutIdPrefix + '$i#'),
    ];

    return Container(
      width: width,
      height: height,
      padding: padding,
      child: CustomMultiChildLayout(
        delegate: _SpinWheelLayoutDelegate(
          horizontalCount: horizontalCount ?? 3,
          verticalCount: verticalCount ?? 3,
          horizontalSpacing: horizontalSpacing ?? 0,
          verticalSpacing: verticalSpacing ?? 0,
          centerId: centerLayoutId,
          childrenIds: childrenLayoutIds,
          childAspectRatio: childAspectRatio,
        ),
        children: [
          if (center != null)
            LayoutId(
              id: centerLayoutId,
              child: center!,
            ),
          for (int i = 0; i < children.length; i++)
            LayoutId(
              id: childrenLayoutIds[i],
              child: children[i],
            ),
        ],
      ),
    );
  }
}

class _SpinWheelLayoutDelegate extends MultiChildLayoutDelegate {
  _SpinWheelLayoutDelegate({
    required this.horizontalCount,
    required this.verticalCount,
    required this.horizontalSpacing,
    required this.verticalSpacing,
    required this.centerId,
    required this.childrenIds,
    this.childAspectRatio,
  });

  final int horizontalCount;
  final int verticalCount;
  final double horizontalSpacing;
  final double verticalSpacing;
  final double? childAspectRatio;
  final String centerId;
  final List<String> childrenIds;

  /// 节点宽高比
  Size _applyAspectRatio(BoxConstraints constraints, double aspectRatio) {
    assert(constraints.debugAssertIsValid());
    assert(() {
      if (!constraints.hasBoundedWidth && !constraints.hasBoundedHeight) {
        throw FlutterError(
          '$runtimeType has unbounded constraints.\n'
          'This $runtimeType was given an aspect ratio of $aspectRatio but was given '
          'both unbounded width and unbounded height constraints. Because both '
          "constraints were unbounded, this render object doesn't know how much "
          'size to consume.',
        );
      }
      return true;
    }());

    if (constraints.isTight) {
      return constraints.smallest;
    }

    double width = constraints.maxWidth;
    double height;

    // We default to picking the height based on the width, but if the width
    // would be infinite, that's not sensible so we try to infer the height
    // from the width.
    if (width.isFinite) {
      height = width / aspectRatio;
    } else {
      height = constraints.maxHeight;
      width = height * aspectRatio;
    }

    // Similar to RenderImage, we iteratively attempt to fit within the given
    // constraints while maintaining the given aspect ratio. The order of
    // applying the constraints is also biased towards inferring the height
    // from the width.

    if (width > constraints.maxWidth) {
      width = constraints.maxWidth;
      height = width / aspectRatio;
    }

    if (height > constraints.maxHeight) {
      height = constraints.maxHeight;
      width = height * aspectRatio;
    }

    if (width < constraints.minWidth) {
      width = constraints.minWidth;
      height = width / aspectRatio;
    }

    if (height < constraints.minHeight) {
      height = constraints.minHeight;
      width = height * aspectRatio;
    }

    return constraints.constrain(Size(width, height));
  }

  @override
  Size getSize(BoxConstraints constraints) {
    final aspectRatio = childAspectRatio;
    if (aspectRatio != null && aspectRatio > 0) {
      return _applyAspectRatio(constraints, aspectRatio);
    }
    return super.getSize(constraints);
  }

  @override
  void performLayout(Size size) {
    final itemWidth = (size.width - horizontalSpacing * (horizontalCount - 1)) /
        horizontalCount;
    final itemHeight =
        (size.height - verticalSpacing * (verticalCount - 1)) / verticalCount;
    final h = horizontalCount;
    final v = verticalCount;
    for (var i = 0; i < childrenIds.length; i++) {
      final childId = childrenIds[i];
      if (!hasChild(childId)) continue;
      layoutChild(childId,
          BoxConstraints.tightFor(width: itemWidth, height: itemHeight));
      double x = 0;
      double y = 0;
      if (i >= 0 && i < h - 1) {
        // top
        x = i * (itemWidth + horizontalSpacing);
        y = 0;
      } else if (i >= h - 1 && i < h - 1 + v - 1) {
        // right
        x = size.width - itemWidth;
        y = (i - h + 1) * (itemHeight + verticalSpacing);
      } else if (i >= h - 1 + v - 1 && i < (h - 1) * 2 + v - 1) {
        // bottom
        x = ((h - 1) * 2 + v - 1 - i) * (itemWidth + horizontalSpacing);
        y = size.height - itemHeight;
      } else if (i >= h - 1 + v - 1 + h - 1) {
        // left
        x = 0;
        y = (h * 2 + v * 2 - 4 - i) * (itemHeight + verticalSpacing);
      }
      positionChild(childId, Offset(x, y));
    }

    if (hasChild(centerId)) {
      final width = size.width - (itemWidth + horizontalSpacing) * 2;
      final height = size.height - (itemHeight + verticalSpacing) * 2;
      layoutChild(
          centerId, BoxConstraints.tightFor(width: width, height: height));
      positionChild(
        centerId,
        Offset(itemWidth + horizontalSpacing, itemHeight + verticalSpacing),
      );
    }
  }

  @override
  bool shouldRelayout(covariant MultiChildLayoutDelegate oldDelegate) {
    if (oldDelegate is _SpinWheelLayoutDelegate) {
      final shouldRelayout = oldDelegate.horizontalCount != horizontalCount ||
          oldDelegate.verticalCount != verticalCount ||
          oldDelegate.horizontalSpacing != horizontalSpacing ||
          oldDelegate.verticalSpacing != verticalSpacing ||
          oldDelegate.centerId != centerId ||
          !listEquals(oldDelegate.childrenIds, childrenIds);
      return shouldRelayout;
    }
    return false;
  }
}
