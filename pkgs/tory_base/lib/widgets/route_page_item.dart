import 'package:flutter/material.dart';

class RoutePageItem extends StatelessWidget {
  final String title;
  final String? subTitle;
  final IconData? icon;
  final WidgetBuilder? builder;
  final VoidCallback? onPress;

  const RoutePageItem({
    Key? key,
    required this.title,
    this.builder,
    this.onPress,
    this.icon,
    this.subTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: icon != null ? Icon(icon) : null,
      title: Text(title),
      subtitle: subTitle != null ? Text(subTitle!) : null,
      trailing: const Icon(Icons.navigate_next),
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
