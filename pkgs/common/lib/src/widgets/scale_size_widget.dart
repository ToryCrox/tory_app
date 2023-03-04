import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// 缩放控件，可以同时缩放控件大小，只用Transform.scale的话无法缩放控件大小
/// 通过textAligned设置文字的对齐方式，缩放后保证baseline对齐
/// 通过scale设置缩放比例
/// 通过child设置子控件
class ScaleSizeWidget extends SingleChildRenderObjectWidget {
  ScaleSizeWidget({
    Key? key,
    required this.scale,
    required Widget? child,
    this.textAligned = Alignment.center,
  }) : super(
    key: key,
    child: Transform.scale(
      scale: scale,
      child: child,
    ),
  );

  final double scale;
  /// 文字的对齐方式，缩放后保证baseline对齐
  final AlignmentGeometry? textAligned;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _ScaleSizeRenderObject(scale: scale);
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant _ScaleSizeRenderObject renderObject) {
    renderObject.scale = scale;
    renderObject.textAligned = textAligned;
  }
}

class _ScaleSizeRenderObject extends RenderShiftedBox {
  double _scale;
  AlignmentGeometry? _textAligned;

  _ScaleSizeRenderObject({RenderBox? child, required double scale, AlignmentGeometry? textAligned})
      : _scale = scale,
        _textAligned = textAligned,
        super(child);

  set scale(double scale) {
    if (_scale != scale) {
      _scale = scale;
      markNeedsLayout();
    }
  }

  set textAligned(AlignmentGeometry? textAligned) {
    if (_textAligned != textAligned) {
      _textAligned = textAligned;
      markNeedsLayout();
    }
  }

  @override
  void performLayout() {
    final child = this.child;
    if (child != null) {
      child.layout(constraints.tighten(), parentUsesSize: true);
      final childSize = child.size;
      final scaleSize = childSize * _scale;
      size = constraints.constrain(scaleSize);

      /// 对子级进行布局
      /// 经过测量后，可通过 child.size 拿到 child 测量后的大小
      /// 这里parentData即负责存储父节点所需要的子节点的布局信息
      final BoxParentData childParentData = child.parentData as BoxParentData;
      Offset offset = Offset((size.width - child.size.width) / 2,
          (size.height - child.size.height) / 2);

      final textAligned = _textAligned;
      if (_textAligned != null) {
        final childBaseLine = child.getDistanceToBaseline(TextBaseline.alphabetic);
        if (childBaseLine != null) {
          double scaledBaseLine = childBaseLine * _scale - (scaleSize.height - size.height) / 2;
          if (textAligned == Alignment.center) {
            final dy = scaledBaseLine - (offset.dy + childBaseLine);
            offset = Offset(offset.dx, offset.dy - dy);
          } else if (textAligned == Alignment.bottomCenter) {
            final dy = scaledBaseLine - (size.height - child.size.height + childBaseLine);
            offset = Offset(offset.dx, offset.dy - dy);
          }
        }
      }

      childParentData.offset = offset;
    } else {
      size = constraints.smallest;
    }
  }
}
