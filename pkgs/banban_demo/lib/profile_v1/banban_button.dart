import 'package:flutter/material.dart';

import 'improve_profile.dart';

class BanBanButton extends StatelessWidget {
  final bool isEnable;
  final String title;
  final Color activeBgColor;
  final VoidCallback onTap;

  const BanBanButton({
    Key? key,
    this.isEnable = true,
    required this.title,
    required this.onTap,
    this.activeBgColor = RColor.primaryColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(24);
    return InkWell(
      onTap: isEnable ? onTap : null,
      borderRadius: borderRadius,
      child: Ink(
        width: double.infinity,
        height: 48,
        decoration: BoxDecoration(
          color: isEnable ? activeBgColor : RColor.disableButtonColor,
          borderRadius: borderRadius,
        ),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
