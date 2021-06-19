import 'package:flutter/material.dart';

abstract class MenuRoutePath {}

enum BartMenuRouteType { BOTTOM_NAV, SUB_ROUTE }

class BartMenuRoute {
  String? label;
  IconData? icon;
  String path;
  WidgetBuilder pageBuilder;
  RouteSettings settings;
  bool? maintainState;
  bool cache;
  BartMenuRouteType routingType;

  BartMenuRoute._({
    this.label,
    this.icon,
    required this.path,
    required this.pageBuilder,
    required this.settings,
    required this.routingType,
    required this.cache,
    this.maintainState,
  });

  factory BartMenuRoute.bottomBar({
    required String label,
    required IconData icon,
    required String path,
    required WidgetBuilder pageBuilder,
    bool cache = true,
    Object? args,
  }) =>
      BartMenuRoute._(
        label: label,
        icon: icon,
        path: path,
        cache: cache,
        routingType: BartMenuRouteType.BOTTOM_NAV,
        pageBuilder: pageBuilder,
        settings: RouteSettings(arguments: args, name: path),
      );

  factory BartMenuRoute.innerRoute({
    required String path,
    required WidgetBuilder pageBuilder,
    bool cache = false,
    Object? args,
  }) =>
      BartMenuRoute._(
        path: path,
        routingType: BartMenuRouteType.SUB_ROUTE,
        pageBuilder: pageBuilder,
        cache: cache,
        settings: RouteSettings(arguments: args, name: path),
      );
}
