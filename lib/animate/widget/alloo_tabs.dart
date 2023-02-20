import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tory_base/app/logger.dart';

import 'mtabs.dart';

class AllooIndicatorDecoration extends CustomTabIndicatorDecoration {
  final ImageProvider image =
      const AssetImage('assets/images/img_tab_indicator.png');

  final Size imageSize = const Size(55, 24);

  ImageStream? _imageStream;
  ImageInfo? _image;

  @override
  void paint(Canvas canvas, TextDirection textDirection, Rect start, Rect? end,
      double progress) {
    final ImageStream newImageStream = image.resolve(ImageConfiguration(
      size: imageSize,
      textDirection: textDirection,
    ));
    if (newImageStream.key != _imageStream?.key) {
      final ImageStreamListener listener = ImageStreamListener(
        _handleImage,
        onError: _onError,
      );
      _imageStream?.removeListener(listener);
      _imageStream = newImageStream;
      _imageStream!.addListener(listener);
    }

    if (_image == null) {
      return;
    }
    final fraction = max(0.0, min(1.0, progress));
    paintImage(
      canvas: canvas,
      rect: imageRect(start),
      image: _image!.image,
      opacity: 1 - fraction,
    );
    // final paint = Paint();
    // paint.color = Colors.black;
    // paint.style = PaintingStyle.stroke;
    // canvas.drawRect(imageRect(start), paint);
    if (end != null && fraction > 0) {
      paintImage(
        canvas: canvas,
        rect: imageRect(end),
        image: _image!.image,
        fit: BoxFit.cover,
        opacity: fraction,
      );
    }
  }

  Rect imageRect(Rect rect) {
    final double right = rect.right;
    final double left = right - imageSize.width;
    final double bottom = rect.bottom - 11;
    final double top = bottom - imageSize.height;

    return Rect.fromLTRB(left, top, right, bottom);
  }

  void _handleImage(ImageInfo value, bool synchronousCall) {
    if (_image == value) {
      return;
    }
    if (_image != null && _image!.isCloneOf(value)) {
      value.dispose();
      return;
    }
    logger.d(
        'YougobIndicatorDecoration _handleImage end! synchronousCall: $synchronousCall');
    _image?.dispose();
    _image = value;
    assert(paintCallback != null);
    if (!synchronousCall) {
      paintCallback?.call();
    }
  }

  void _onError(Object exception, StackTrace? stackTrace) {
    logger.e(
        'YougobIndicatorDecoration:' + exception.toString(), '', stackTrace);
  }

  @override
  void dispose() {}
}

/// 一级TabBar
class AllooPrimaryTabBar extends StatelessWidget {
  final List<MTabMeta> tabs;
  final TabController controller;
  final bool fadeEnd;
  final List<Widget> tails;
  final VoidCallback? onSpaceDoubleTap;

  const AllooPrimaryTabBar({
    Key? key,
    required this.tabs,
    required this.controller,
    this.fadeEnd = false,
    this.tails = const [],
    this.onSpaceDoubleTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget child = MTabBar(
      controller: controller,
      isScrollable: true,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      indicatorSize: TabBarIndicatorSize.label,
      labelPadding: const EdgeInsetsDirectional.fromSTEB(12, 0, 12, 11),
      labelAlignment: AlignmentDirectional.bottomCenter,
      labelStyle: const TextStyle(
        fontSize: 22,
        color: Color(0xFF313131),
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: const TextStyle(
        fontSize: 16,
        color: Color(0xFF949494),
        fontWeight: FontWeight.w500,
      ),
      customTabIndicator: AllooIndicatorDecoration(),
      tabsMeta: tabs,
      indicatorWeight: 0,
    );

    /// 空白处双击
    if (onSpaceDoubleTap != null) {
      final c = child;
      child = LayoutBuilder(
          builder: (context, constraint) {
            return Row(
              children: [
                LimitedBox(maxWidth: constraint.maxWidth, child: c,),
                Expanded(child: GestureDetector(onDoubleTap: onSpaceDoubleTap)),
              ],
            );
          }
      );
    }

    if (fadeEnd) {
      child = ShaderMask(
        shaderCallback: (Rect bounds) {
          return const LinearGradient(
            colors: [Colors.transparent, Colors.transparent, Colors.white],
            stops: [0.0, 0.9, 1.0],
          ).createShader(bounds, textDirection: TextDirection.ltr);
        },
        blendMode: BlendMode.dstOut,
        child: child,
      );
    }

    if (tails.isNotEmpty) {
      child = Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(child: child),
          ...tails,
        ],
      );
    }
    return Container(
      height: 48,
      alignment: AlignmentDirectional.centerStart,
      child: child,
    );
  }
}

class AllooSecondaryTabBar extends StatelessWidget {
  final List<MTabMeta> tabs;
  final TabController controller;
  final bool fadeEnd;

  const AllooSecondaryTabBar({
    Key? key,
    required this.tabs,
    required this.controller,
    this.fadeEnd = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget child = MTabBar(
      controller: controller,
      isScrollable: true,
      tabHeight: 32,
      padding: const EdgeInsets.symmetric(horizontal: 1),
      indicatorSize: TabBarIndicatorSize.label,
      labelPadding: const EdgeInsetsDirectional.fromSTEB(15, 0, 15, 0),
      labelAlignment: AlignmentDirectional.center,
      labelStyle: const TextStyle(
        fontSize: 14,
        color: Color(0xFF313131),
        fontWeight: FontWeight.w500,
      ),
      unselectedLabelStyle: const TextStyle(
        fontSize: 14,
        color: Color(0xFF949494),
        fontWeight: FontWeight.w400,
      ),
      indicator: const MUnderlineTabIndicator(
        borderSide: BorderSide(color: Color(0xFF313131), width: 2),
        wantWidth: 8,
      ),
      tabsMeta: tabs,
      indicatorWeight: 0,
    );
    if (fadeEnd) {
      child = Stack(
        children: [
          child,
          PositionedDirectional(
            top: 0,
            bottom: 0,
            end: 0,
            child: Container(
              width: 31,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0x00FFFFFF), Color(0x5CFFFFFF), Color(0xFFFFFFFF)],
                  begin: AlignmentDirectional.centerStart,
                  end: AlignmentDirectional.centerEnd,
                ),
              ),
            ),
          )
        ],
      );
    }
    return Container(
      height: 32,
      alignment: AlignmentDirectional.centerStart,
      child: child,
    );
  }
}
