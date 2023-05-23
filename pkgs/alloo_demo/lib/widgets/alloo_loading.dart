import 'package:alloo_demo/widgets/frame_image_animation.dart';
import 'package:flutter/material.dart';

class AllooLoading extends StatelessWidget {
  const AllooLoading({Key? key, this.size = 66, this.controller})
      : super(key: key);

  final double size;
  final FrameImageAnimationController? controller;

  static const loadingFrames = [
    'assets/images/ic_alloo_loading/ic_alloo_loading_frame_00.webp',
    'assets/images/ic_alloo_loading/ic_alloo_loading_frame_01.webp',
    'assets/images/ic_alloo_loading/ic_alloo_loading_frame_02.webp',
    'assets/images/ic_alloo_loading/ic_alloo_loading_frame_03.webp',
    'assets/images/ic_alloo_loading/ic_alloo_loading_frame_04.webp',
    'assets/images/ic_alloo_loading/ic_alloo_loading_frame_05.webp',
    'assets/images/ic_alloo_loading/ic_alloo_loading_frame_06.webp',
    'assets/images/ic_alloo_loading/ic_alloo_loading_frame_07.webp',
    'assets/images/ic_alloo_loading/ic_alloo_loading_frame_08.webp',
    'assets/images/ic_alloo_loading/ic_alloo_loading_frame_09.webp',
    'assets/images/ic_alloo_loading/ic_alloo_loading_frame_10.webp',
    'assets/images/ic_alloo_loading/ic_alloo_loading_frame_11.webp',
    'assets/images/ic_alloo_loading/ic_alloo_loading_frame_12.webp',
    'assets/images/ic_alloo_loading/ic_alloo_loading_frame_13.webp',
    'assets/images/ic_alloo_loading/ic_alloo_loading_frame_14.webp',
    'assets/images/ic_alloo_loading/ic_alloo_loading_frame_15.webp',
    'assets/images/ic_alloo_loading/ic_alloo_loading_frame_16.webp',
    'assets/images/ic_alloo_loading/ic_alloo_loading_frame_17.webp',
  ];

  @override
  Widget build(BuildContext context) {
    return FrameImageAnimation(
      frameImages: loadingFrames,
      width: size,
      height: size,
      package: 'alloo_demo',
      totalDuration: const Duration(milliseconds: 720),
      controller: controller,
    );
  }
}


class AllooFullLoading extends StatelessWidget {
  const AllooFullLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: AllooLoading(size: 80,),
    );
  }
}
