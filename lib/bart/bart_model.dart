import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

abstract class MenuRoutePath {}

enum BartMenuRouteType { bottomNavigation, subRoute }

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
    // ignore: unused_element
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
        routingType: BartMenuRouteType.bottomNavigation,
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
        routingType: BartMenuRouteType.subRoute,
        pageBuilder: pageBuilder,
        cache: cache,
        settings: RouteSettings(name: path),
        transitionsBuilder: transitionsBuilder,
        transitionDuration: transitionDuration,
      );
}

class ScaffoldOptions {
  final Key? key;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final FloatingActionButtonAnimator? floatingActionButtonAnimator;
  final List<Widget>? persistentFooterButtons;
  final Widget? drawer;
  final DrawerCallback? onDrawerChanged;
  final Widget? endDrawer;
  final DrawerCallback? onEndDrawerChanged;
  final Widget? bottomSheet;
  final Color? backgroundColor;
  final bool? resizeToAvoidBottomInset;
  final bool? primary;
  final DragStartBehavior? drawerDragStartBehavior;
  final bool? extendBody;
  final Color? drawerScrimColor;
  final double? drawerEdgeDragWidth;
  final bool? drawerEnableOpenDragGesture;
  final bool? endDrawerEnableOpenDragGesture;
  final String? restorationId;
  final bool? extendBodyBehindAppBar;

  ScaffoldOptions({
    this.key,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.floatingActionButtonAnimator,
    this.persistentFooterButtons,
    this.drawer,
    this.onDrawerChanged,
    this.endDrawer,
    this.onEndDrawerChanged,
    this.bottomSheet,
    this.backgroundColor,
    this.resizeToAvoidBottomInset,
    this.primary,
    this.drawerDragStartBehavior,
    this.extendBody,
    this.drawerScrimColor,
    this.drawerEdgeDragWidth,
    this.drawerEnableOpenDragGesture,
    this.endDrawerEnableOpenDragGesture,
    this.restorationId,
    this.extendBodyBehindAppBar,
  });
}
