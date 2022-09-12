import 'package:flutter/material.dart';

// @ignore_hardcode

class GenderPickerPage extends StatefulWidget {
  const GenderPickerPage({Key? key}) : super(key: key);

  @override
  State<GenderPickerPage> createState() => _GenderPickerPageState();
}

class _GenderPickerPageState extends State<GenderPickerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: const BackButton(
          color: Colors.black,
        ),
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      //extendBody: true,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Image.asset(
          //   "assets/images/bg_login_top.webp",
          //   width: 200,
          //   height: 300,
          // ),
          SafeArea(
              child: Column(
            children: [

              Text("选择性别"),
            ],
          ))
        ],
      ),
    );
  }
}
