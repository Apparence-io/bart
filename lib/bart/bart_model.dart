import 'package:flutter/material.dart';

abstract class MenuRoutePath {}

class BartMenuRoute {
  String label;
  IconData icon;
  String path;
  WidgetBuilder pageBuilder;
  RouteSettings settings;
  bool? maintainState;

  BartMenuRoute._({
    required this.label,
    required this.icon,
    required this.path,
    required this.pageBuilder,
    required this.settings,
    this.maintainState,
  });

  factory BartMenuRoute.bottomBar({
    required String label,
    required IconData icon,
    required String path,
    required WidgetBuilder pageBuilder,
    Object? args,
  }) =>
      BartMenuRoute._(
        label: label,
        icon: icon,
        path: path,
        pageBuilder: pageBuilder,
        settings: RouteSettings(arguments: args, name: path),
      );

  factory BartMenuRoute.innerRoute() => throw "not implemented";
}
