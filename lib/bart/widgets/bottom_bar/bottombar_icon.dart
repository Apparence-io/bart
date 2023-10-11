import 'package:flutter/material.dart';

typedef NotificationBuilder = Widget Function(
  BuildContext context,
);

class BottomBarIcon extends StatelessWidget {
  final Icon icon;
  final NotificationBuilder? notificationBuilder;

  const BottomBarIcon({
    super.key,
    required this.icon,
    this.notificationBuilder,
  });

  factory BottomBarIcon.builder({
    required Icon icon,
    required NotificationBuilder notificationBuilder,
  }) =>
      BottomBarIcon(
        icon: icon,
        notificationBuilder: notificationBuilder,
      );

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      icon,
      Positioned(
        top: -1.0,
        right: -1.0,
        child: Stack(
          children: <Widget>[
            if (notificationBuilder != null) notificationBuilder!(context),
          ],
        ),
      )
    ]);
  }
}
