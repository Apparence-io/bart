import 'package:flutter/material.dart';

abstract class MenuRoutePath {}

enum BartMenuRouteType { BOTTOM_NAV, SUB_ROUTE }

typedef BartPageBuilder = Widget Function(
    BuildContext context, RouteSettings? settings);

class BartMenuRoute {
  String? label;
  IconData? icon;
  String path;
  BartPageBuilder pageBuilder;
  RouteSettings settings;
  bool? maintainState;
  bool cache;
  BartMenuRouteType routingType;
  final RouteTransitionsBuilder? transitionsBuilder;
  final Duration? transitionDuration;

  BartMenuRoute._({
    this.label,
    this.icon,
    required this.path,
    required this.pageBuilder,
    required this.settings,
    required this.routingType,
    required this.cache,
    this.maintainState,
    this.transitionsBuilder,
    this.transitionDuration,
  });

  factory BartMenuRoute.bottomBar({
    required String label,
    required IconData icon,
    required String path,
    required BartPageBuilder pageBuilder,
    RouteTransitionsBuilder? transitionsBuilder,
    Duration? transitionDuration,
    bool cache = true,
  }) =>
      BartMenuRoute._(
        label: label,
        icon: icon,
        path: path,
        cache: cache,
        routingType: BartMenuRouteType.BOTTOM_NAV,
        pageBuilder: pageBuilder,
        settings: RouteSettings(name: path),
        transitionsBuilder: transitionsBuilder,
        transitionDuration: transitionDuration,
      );

  factory BartMenuRoute.innerRoute({
    required String path,
    required BartPageBuilder pageBuilder,
    RouteTransitionsBuilder? transitionsBuilder,
    Duration? transitionDuration,
    bool cache = false,
  }) =>
      BartMenuRoute._(
        path: path,
        routingType: BartMenuRouteType.SUB_ROUTE,
        pageBuilder: pageBuilder,
        cache: cache,
        settings: RouteSettings(name: path),
        transitionsBuilder: transitionsBuilder,
        transitionDuration: transitionDuration,
      );
}
