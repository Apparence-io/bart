import 'package:flutter/material.dart';

abstract class MenuRoutePath {}

class BartMenuRoute {

  String label;
  IconData icon;
  String path;
  WidgetBuilder pageBuilder;
  RouteSettings settings;
  bool maintainState;

  BartMenuRoute({
    @required this.label,
    @required this.icon,
    @required this.path,
    @required this.pageBuilder,
    @required this.settings,
    this.maintainState
  });
}