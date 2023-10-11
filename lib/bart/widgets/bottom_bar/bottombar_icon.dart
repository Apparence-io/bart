import 'package:flutter/material.dart';

typedef NotificationBuilder = Widget Function(
  BuildContext context,
);

class BottomBarIcon extends StatelessWidget {
  final Icon icon;
  final NotificationBuilder? notificationBuilder;
  final double? top;
  final double? right;
  final Text? notificationLabel;
  final Color? notificationColor;

  const BottomBarIcon({
    super.key,
    required this.icon,
    this.notificationBuilder,
    this.top,
    this.right,
    this.notificationLabel,
    this.notificationColor,
  });

  factory BottomBarIcon.builder({
    required Icon icon,
    required NotificationBuilder notificationBuilder,
    double? top,
    double? right,
  }) =>
      BottomBarIcon(
        icon: icon,
        notificationBuilder: notificationBuilder,
        top: top,
        right: right,
      );

  factory BottomBarIcon.withNotification({
    required Icon icon,
    required Text notificationLabel,
    required Color notificationColor,
    double? top,
    double? right,
  }) =>
      BottomBarIcon(
        icon: icon,
        top: top,
        right: right,
        notificationLabel: notificationLabel,
        notificationColor: notificationColor,
      );

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      icon,
      Positioned(
        top: top ?? -1.0,
        right: right ?? -1.0,
        child: Stack(
          children: <Widget>[
            if (notificationBuilder != null) notificationBuilder!(context),
            if (notificationBuilder == null)
              Container(
                decoration: BoxDecoration(
                  color: notificationColor,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(4),
                child: notificationLabel,
              ),
          ],
        ),
      )
    ]);
  }
}
