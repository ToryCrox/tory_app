
import 'dart:math';

import 'package:flutter/material.dart';

class AnimatedSpreadEffect extends StatefulWidget {
  final double maxRadius;
  final double minRadius;
  final Color color;

  /// 初始透明度
  final double startOpacity;
  final double ringWidth;
  final int ringNum;
  final bool isShowCenterCircle;
  final Duration duration;

  const AnimatedSpreadEffect({
    Key? key,
    required this.maxRadius,
    required this.minRadius,
    this.color = Colors.white,
    this.startOpacity = 0.7,
    this.ringWidth = 2,
    this.ringNum = 3,
    this.isShowCenterCircle = true,
    this.duration = const Duration(milliseconds: 2000),
  })  : assert(maxRadius > minRadius),
        super(key: key);

  @override
  State<AnimatedSpreadEffect> createState() => _AnimatedSpreadEffectState();
}

class _AnimatedSpreadEffectState extends State<AnimatedSpreadEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<SpreadRing> _rings;

  @override
  void initState() {
    super.initState();
    _rings = List.generate(
        widget.ringNum,
            (index) => SpreadRing(
          startFraction: index / widget.ringNum,
          color: widget.color,
          ringWidth: widget.ringWidth,
        ));
    if (widget.isShowCenterCircle) {
      _rings.add(SpreadRing(
          startFraction: 0,
          radius: widget.minRadius,
          color: widget.color,
          isFill: true,
          isCalculable: false));
    }
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Colors.grey,
      width: widget.maxRadius * 2,
      height: widget.maxRadius * 2,
      child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            for (var ring in _rings) {
              ring.calculate(
                  widget.minRadius, widget.maxRadius, _controller.value);
            }
            // 要包裹上RepaintBoundary，否则会导致其他组件重绘
            return RepaintBoundary(
              child: CustomPaint(
                painter: AnimatedSpreadPainter(_rings),
              ),
            );
          }),
    );
  }
}

class AnimatedSpreadPainter extends CustomPainter {
  final List<SpreadRing> _rings;

  AnimatedSpreadPainter(this._rings);

  @override
  void paint(Canvas canvas, Size size) {
    final painter = Paint();
    final center = size.center(Offset.zero);
    for (var ring in _rings) {
      painter.style = ring.isFill ? PaintingStyle.fill : PaintingStyle.stroke;
      painter.color = ring.color;
      painter.strokeWidth = ring.ringWidth;
      canvas.drawCircle(center, ring.radius, painter);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class SpreadRing {
  final double startFraction;
  double radius = 0;
  double ringWidth = 2;
  Color color = Colors.white;
  bool isFill = false;
  bool isCalculable = true;

  SpreadRing(
      {required this.startFraction,
        this.radius = 0,
        this.color = Colors.white,
        this.ringWidth = 2,
        this.isFill = false,
        this.isCalculable = true});

  void calculate(double minRadius, double maxRadius, double fraction) {
    if (!isCalculable) return;
    var f = fraction >= startFraction
        ? fraction - startFraction
        : 1 - startFraction + fraction;
    f = max(0, min(f, 1.0));
    radius = (maxRadius + ringWidth - minRadius) * f + minRadius;
    //print("calculate: $startFraction, $fraction, $f, radius: $radius");
    color = color.withOpacity(0.7 * (1 - f));
  }
}
