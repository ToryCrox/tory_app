

import 'package:flutter/material.dart';

class RoutePageItem extends StatelessWidget {
  final String title;
  final WidgetBuilder? builder;
  final VoidCallback? onPress;

  const RoutePageItem(
      {Key? key, required this.title, this.builder, this.onPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      onTap: () {
        if (onPress != null) {
          onPress?.call();
        } else if (builder != null) {
          Navigator.of(context).push(MaterialPageRoute(builder: builder!));
        }
      },
    );
  }
}