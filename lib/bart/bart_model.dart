import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

abstract class MenuRoutePath {}

enum BartMenuRouteType { bottomNavigation, subRoute }

typedef BartPageBuilder = Widget Function(
  BuildContext parentContext,
  BuildContext tabContext,
  RouteSettings? settings,
);

class BartMenuRoute {
  String? label;
  IconData? icon;

  /// The optional [IconData] that's displayed when this
  /// [NavigationDestination] is selected.
  /// Only used for material 3 style bottom bar.
  IconData? selectedIcon;
  String path;
  BartPageBuilder pageBuilder;
  RouteSettings settings;
  bool? maintainState;
  bool cache;
  BartMenuRouteType type;
  final RouteTransitionsBuilder? transitionsBuilder;
  final Duration? transitionDuration;

  BartMenuRoute._({
    this.label,
    this.icon,
    this.selectedIcon,
    required this.path,
    required this.pageBuilder,
    required this.settings,
    required this.type,
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
    IconData? selectedIcon,
  }) =>
      BartMenuRoute._(
        label: label,
        icon: icon,
        path: path,
        cache: cache,
        type: BartMenuRouteType.bottomNavigation,
        pageBuilder: pageBuilder,
        settings: RouteSettings(name: path),
        transitionsBuilder: transitionsBuilder,
        transitionDuration: transitionDuration,
        selectedIcon: selectedIcon,
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
        type: BartMenuRouteType.subRoute,
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

@immutable
class BartBottomBarTheme {
  final Color? bgColor, selectedItemColor, unselectedItemColor;
  final BottomNavigationBarType? type;
  final IconThemeData? iconThemeData;
  final double? height, elevation;
  final double selectedFontSize, unselectedFontSize, iconSize;

  /// Only for cupertino style bottom bar
  final Border? border;

  /// Only for material3 style bottom bar
  final Duration? animationDuration;
  final NavigationDestinationLabelBehavior? labelBehavior;

  const BartBottomBarTheme._({
    this.bgColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.type,
    this.iconThemeData,
    this.elevation,
    this.height,
    this.border,
    this.iconSize = 24,
    this.selectedFontSize = 14.0,
    this.unselectedFontSize = 12.0,
    this.animationDuration,
    this.labelBehavior,
  });

  factory BartBottomBarTheme.material2({
    Color? bgColor,
    Color? selectedItemColor,
    Color? unselectedItemColor,
    double? height,
    BottomNavigationBarType? type,
    IconThemeData? iconThemeData,
    double selectedFontSize = 14.0,
    double unselectedFontSize = 12.0,
    double iconSize = 24,
    double? elevation,
  }) {
    return BartBottomBarTheme._(
      bgColor: bgColor,
      selectedItemColor: selectedItemColor,
      unselectedItemColor: unselectedItemColor,
      type: type,
      elevation: elevation,
      iconThemeData: iconThemeData,
      height: height,
      iconSize: iconSize,
      selectedFontSize: selectedFontSize,
      unselectedFontSize: unselectedFontSize,
    );
  }

  factory BartBottomBarTheme.cupertino({
    Color? bgColor,
    Color? selectedItemColor,
    Color? unselectedItemColor,
    BottomNavigationBarType? type,
    double iconSize = 24,
    double? height,
    Border? border,
  }) {
    return BartBottomBarTheme._(
      bgColor: bgColor,
      selectedItemColor: selectedItemColor,
      unselectedItemColor: unselectedItemColor,
      type: type,
      height: height,
      iconSize: iconSize,
      border: border,
    );
  }

  factory BartBottomBarTheme.material3({
    Duration? animationDuration,
    NavigationDestinationLabelBehavior? labelBehavior,
    double? height,
    double? elevation,
    Color? bgColor,
  }) {
    return BartBottomBarTheme._(
      animationDuration: animationDuration,
      labelBehavior: labelBehavior,
      height: height,
      elevation: elevation,
      bgColor: bgColor,
    );
  }

  BartBottomBarTheme copyWith({
    Color? bgColor,
    Color? selectedItemColor,
    Color? unselectedItemColor,
    BottomNavigationBarType? type,
    IconThemeData? iconThemeData,
    double? height,
    double? iconSize,
    double? elevation,
    double? selectedFontSize,
    double? unselectedFontSize,
    Border? border,
    Duration? animationDuration,
    NavigationDestinationLabelBehavior? labelBehavior,
  }) {
    return BartBottomBarTheme._(
      bgColor: bgColor ?? this.bgColor,
      selectedItemColor: selectedItemColor ?? this.selectedItemColor,
      unselectedItemColor: unselectedItemColor ?? this.unselectedItemColor,
      type: type ?? this.type,
      iconThemeData: iconThemeData ?? this.iconThemeData,
      height: height ?? this.height,
      iconSize: iconSize ?? this.iconSize,
      elevation: elevation ?? this.elevation,
      selectedFontSize: selectedFontSize ?? this.selectedFontSize,
      unselectedFontSize: unselectedFontSize ?? this.unselectedFontSize,
      border: border ?? this.border,
      animationDuration: animationDuration ?? this.animationDuration,
      labelBehavior: labelBehavior ?? this.labelBehavior,
    );
  }
}
