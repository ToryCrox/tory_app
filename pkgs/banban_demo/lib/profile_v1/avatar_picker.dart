import 'package:flutter/material.dart';

import '../widgets/base_appbar.dart';
import 'banban_button.dart';
import 'improve_profile.dart';
// @ignore_hardcode
class AvatarPicker extends StatefulWidget {
  const AvatarPicker({Key? key}) : super(key: key);

  @override
  State<AvatarPicker> createState() => _AvatarPickerState();
}

class _AvatarPickerState extends State<AvatarPicker> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BaseAppBar(title: '选择一个你喜欢的头像'),
      backgroundColor: RColor.backgroundColor,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            const SizedBox(height: 40),
            GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
              itemBuilder: (context, index) {
                return Container();
              },
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 8,
              ),
              child: BanBanButton(
                title: '换一批',
                onTap: () {},
                activeBgColor: RColor.secondBgColor,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 8,
              ),
              child: BanBanButton(
                title: '自定义',
                onTap: () {},
              ),
            )
          ],
        ),
      ),
    );
  }
}
