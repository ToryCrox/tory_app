import 'package:flutter/material.dart';

class AllooLoading extends StatelessWidget {
  const AllooLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/ic_alloo_loading.webp',
      width: 60,
      height: 60,
      scale: 3,
      package: 'alloo_demo',
    );
  }
}
