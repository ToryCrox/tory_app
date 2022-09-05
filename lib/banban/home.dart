

import 'package:flutter/material.dart';

class BanBanHomePage extends StatefulWidget {
  const BanBanHomePage({Key? key}) : super(key: key);

  @override
  State<BanBanHomePage> createState() => _BanBanHomePageState();
}

class _BanBanHomePageState extends State<BanBanHomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text("首页"),
      ),
    );
  }
}
