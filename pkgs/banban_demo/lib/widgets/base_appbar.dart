import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../profile_v1/improve_profile.dart';

class BaseAppBar extends StatelessWidget implements PreferredSizeWidget{
  final bool hasBack;
  final String title;

  const BaseAppBar({Key? key, this.hasBack = true, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      // leading: const CupertinoNavigationBarBackButton(
      //   color: RColor.primaryTextColor,
      // ),
      leading: hasBack ? const BackButton(color: RColor.primaryTextColor) : Container(),
      //leading:  const BackButton() ,
      centerTitle: true,
      backgroundColor: RColor.backgroundColor,
      elevation: 0,
      title: Text(
        title,
        style: const TextStyle(color: RColor.primaryTextColor),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  List<DiagnosticsNode> debugDescribeChildren() {
    return [];
  }


  @override
  StatelessElement createElement() {
    return MStatelessElement(this);
  }
}

class MStatelessElement extends StatelessElement {
  MStatelessElement(StatelessWidget widget) : super(widget);

  @override
  List<DiagnosticsNode> debugDescribeChildren() {
    return [];
  }

}
