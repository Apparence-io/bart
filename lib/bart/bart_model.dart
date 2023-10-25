import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

abstract class MenuRoutePath {}

enum BartMenuRouteType { bottomNavigation, subRoute }

typedef BartPageBuilder = Widget Function(
  BuildContext parentContext,
  BuildContext tabContext,
  RouteSettings? settings,
);

typedef IconBuilder = Widget Function(
  BuildContext context,
);

class BartMenuRoute {
  String? label;
  IconData? icon;
  IconBuilder? iconBuilder;

  /// The optional [IconData] that's displayed when this
  /// [NavigationDestination] is selected.
  /// Only used for material 3 style bottom bar.
  IconData? selectedIcon;
  String path;
  BartPageBuilder pageBuilder;
  RouteSettings settings;
  bool? maintainState;
  bool cache;
  bool showBottomBar;
  BartMenuRouteType type;
  final RouteTransitionsBuilder? transitionsBuilder;
  final Duration? transitionDuration;

  BartMenuRoute._({
    this.label,
    this.icon,
    this.iconBuilder,
    this.selectedIcon,
    required this.path,
    required this.pageBuilder,
    required this.settings,
    required this.type,
    required this.cache,
    required this.showBottomBar,
    // ignore: unused_element
    this.maintainState,
    this.transitionsBuilder,
    this.transitionDuration,
  }) {
    // assert(
    //   icon != null || iconBuilder != null,
    //   "You must provide an icon or an iconWidget",
    // );
    assert(
      icon == null || iconBuilder == null,
      "You can't provide both an icon and an iconWidget",
    );
  }

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
        showBottomBar: true,
      );

  factory BartMenuRoute.bottomBarBuilder({
    required String? label,
    required IconBuilder builder,
    required String path,
    required BartPageBuilder pageBuilder,
    RouteTransitionsBuilder? transitionsBuilder,
    Duration? transitionDuration,
    bool cache = true,
    IconData? selectedIcon,
  }) =>
      BartMenuRoute._(
        label: label,
        iconBuilder: builder,
        path: path,
        cache: cache,
        type: BartMenuRouteType.bottomNavigation,
        pageBuilder: pageBuilder,
        settings: RouteSettings(name: path),
        transitionsBuilder: transitionsBuilder,
        transitionDuration: transitionDuration,
        selectedIcon: selectedIcon,
        showBottomBar: true,
      );

  factory BartMenuRoute.innerRoute({
    required String path,
    required BartPageBuilder pageBuilder,
    RouteTransitionsBuilder? transitionsBuilder,
    Duration? transitionDuration,
    bool cache = false,
    bool showBottomBar = true,
  }) =>
      BartMenuRoute._(
        path: path,
        type: BartMenuRouteType.subRoute,
        pageBuilder: pageBuilder,
        cache: cache,
        settings: RouteSettings(name: path),
        transitionsBuilder: transitionsBuilder,
        transitionDuration: transitionDuration,
        showBottomBar: showBottomBar,
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

class CommonBottomBarTheme {
  final Color? bgColor;
  final double? height;
  CommonBottomBarTheme({
    this.bgColor,
    this.height,
  });
}

@immutable
class Material3BottomBarTheme extends CommonBottomBarTheme {
  final Duration? animationDuration;
  final NavigationDestinationLabelBehavior? labelBehavior;
  final double? elevation;

  Material3BottomBarTheme({
    super.bgColor,
    super.height,
    this.animationDuration,
    this.labelBehavior,
    this.elevation,
  });

  Material3BottomBarTheme copyWith({
    Duration? animationDuration,
    NavigationDestinationLabelBehavior? labelBehavior,
    double? elevation,
    Color? bgColor,
    double? height,
  }) {
    return Material3BottomBarTheme(
      animationDuration: animationDuration ?? this.animationDuration,
      labelBehavior: labelBehavior ?? this.labelBehavior,
      elevation: elevation ?? this.elevation,
      bgColor: bgColor ?? this.bgColor,
      height: height ?? this.height,
    );
  }
}

@immutable
class CupertinoBottomBarTheme extends CommonBottomBarTheme {
  final Color? selectedItemColor;
  final Color? unselectedItemColor;
  final BottomNavigationBarType? type;
  final double iconSize;
  final Border? border;

  CupertinoBottomBarTheme({
    super.bgColor,
    super.height,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.type,
    this.border,
    this.iconSize = 24,
  });

  CupertinoBottomBarTheme copyWith({
    Color? selectedItemColor,
    Color? unselectedItemColor,
    Color? bgColor,
    BottomNavigationBarType? type,
    double? iconSize,
    double? height,
    Border? border,
  }) {
    return CupertinoBottomBarTheme(
      bgColor: bgColor ?? this.bgColor,
      height: height ?? this.height,
      selectedItemColor: selectedItemColor ?? this.selectedItemColor,
      unselectedItemColor: unselectedItemColor ?? this.unselectedItemColor,
      type: type ?? this.type,
      iconSize: iconSize ?? this.iconSize,
      border: border ?? this.border,
    );
  }
}

@immutable
class Material2BottomBarTheme extends CommonBottomBarTheme {
  final Color? selectedItemColor, unselectedItemColor;
  final BottomNavigationBarType? type;
  final IconThemeData? iconThemeData;
  final double? elevation;
  final double selectedFontSize, unselectedFontSize, iconSize;

  Material2BottomBarTheme({
    super.bgColor,
    super.height,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.type,
    this.iconThemeData,
    this.elevation,
    this.selectedFontSize = 14.0,
    this.unselectedFontSize = 12.0,
    this.iconSize = 24,
  });

  Material2BottomBarTheme copyWith({
    Color? selectedItemColor,
    Color? unselectedItemColor,
    Color? bgColor,
    BottomNavigationBarType? type,
    IconThemeData? iconThemeData,
    double? elevation,
    double? selectedFontSize,
    double? unselectedFontSize,
    double? iconSize,
    double? height,
  }) {
    return Material2BottomBarTheme(
      unselectedItemColor: unselectedItemColor ?? this.unselectedItemColor,
      type: type ?? this.type,
      iconThemeData: iconThemeData ?? this.iconThemeData,
      elevation: elevation ?? this.elevation,
      iconSize: iconSize ?? this.iconSize,
      bgColor: bgColor ?? this.bgColor,
      selectedItemColor: selectedItemColor ?? this.selectedItemColor,
      selectedFontSize: selectedFontSize ?? this.selectedFontSize,
      height: height ?? this.height,
      unselectedFontSize: unselectedFontSize ?? this.unselectedFontSize,
    );
  }
}
