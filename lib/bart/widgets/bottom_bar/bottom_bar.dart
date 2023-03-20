import 'package:bart/bart/bart_model.dart';
import 'package:bart/bart/router_delegate.dart';
import 'package:bart/bart/widgets/bottom_bar/styles/bottom_bar_cupertino.dart';
import 'package:bart/bart/widgets/bottom_bar/styles/bottom_bar_custom.dart';
import 'package:bart/bart/widgets/bottom_bar/styles/bottom_bar_material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:universal_io/io.dart';

typedef BottomBarTapAction = void Function(int index);

typedef BartRouteBuilder = List<BartMenuRoute> Function();

enum Theme { material, material3, cupertino, custom }

class BartBottomBar extends StatefulWidget {
  final int currentIndex;
  final Theme theme;
  final BartBottomBarCustom? bottomBarCustom;
  final CommonBottomBarTheme? bottomBarTheme;
  final bool enableHapticFeedback;

  const BartBottomBar._({
    this.enableHapticFeedback = true,
    this.bottomBarCustom,
    this.bottomBarTheme,
    required this.theme,
    required this.currentIndex,
  });

  factory BartBottomBar.material({
    bool enableHapticFeedback = true,
    int index = 0,
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
  }) =>
      BartBottomBar._(
        enableHapticFeedback: enableHapticFeedback,
        bottomBarTheme: Material2BottomBarTheme().copyWith(
          bgColor: bgColor,
          selectedItemColor: selectedItemColor,
          unselectedItemColor: unselectedItemColor,
          type: type,
          iconThemeData: iconThemeData,
          elevation: elevation,
          height: height,
          iconSize: iconSize,
          selectedFontSize: selectedFontSize,
          unselectedFontSize: unselectedFontSize,
        ),
        theme: Theme.material,
        currentIndex: index,
      );

  factory BartBottomBar.material3({
    Duration? animationDuration,
    NavigationDestinationLabelBehavior? labelBehavior,
    double? elevation,
    Color? bgColor,
    double? height,
    bool enableHapticFeedback = true,
    int index = 0,
  }) =>
      BartBottomBar._(
        enableHapticFeedback: enableHapticFeedback,
        bottomBarTheme: Material3BottomBarTheme().copyWith(
          animationDuration: animationDuration,
          labelBehavior: labelBehavior,
          elevation: elevation,
          bgColor: bgColor,
          height: height,
        ),
        theme: Theme.material3,
        currentIndex: index,
      );

  factory BartBottomBar.custom({
    required BartBottomBarCustom bottomBarCustom,
    int index = 0,
  }) =>
      BartBottomBar._(
        theme: Theme.custom,
        bottomBarCustom: bottomBarCustom,
        currentIndex: index,
      );

  factory BartBottomBar.cupertino({
    Color? bgColor,
    Color? selectedItemColor,
    Color? unselectedItemColor,
    BottomNavigationBarType? type,
    double iconSize = 24,
    double? height,
    Border? border,
    bool enableHapticFeedback = true,
    int index = 0,
  }) =>
      BartBottomBar._(
        bottomBarTheme: CupertinoBottomBarTheme().copyWith(
          bgColor: bgColor,
          selectedItemColor: selectedItemColor,
          unselectedItemColor: unselectedItemColor,
          type: type,
          iconSize: iconSize,
          height: height,
          border: border,
        ),
        enableHapticFeedback: enableHapticFeedback,
        theme: Theme.cupertino,
        currentIndex: index,
      );

  factory BartBottomBar.adaptive({
    Material3BottomBarTheme? materialBottomBarTheme,
    CupertinoBottomBarTheme? cupertinoBottomBarTheme,
    bool enableHapticFeedback = true,
    int index = 0,
  }) =>
      BartBottomBar._(
        bottomBarTheme: Platform.isIOS
            ? cupertinoBottomBarTheme ?? CupertinoBottomBarTheme()
            : materialBottomBarTheme ?? Material3BottomBarTheme(),
        enableHapticFeedback: enableHapticFeedback,
        theme: Platform.isIOS ? Theme.cupertino : Theme.material3,
        currentIndex: index,
      );

  @override
  BartBottomBarState createState() => BartBottomBarState();
}

@visibleForTesting
class BartBottomBarState extends State<BartBottomBar> {
  List<BartMenuRoute> get routes => MenuRouter.of(context).routesBuilder();
  ValueNotifier<int> get currentIndexNotifier =>
      MenuRouter.of(context).indexNotifier;
  ValueNotifier<BartMenuRouteType> get currentRoutingTypeNotifier =>
      MenuRouter.of(context).routingTypeNotifier;

  void onTap(int index) {
    if (currentIndexNotifier.value == index &&
        currentRoutingTypeNotifier.value ==
            BartMenuRouteType.bottomNavigation) {
      return;
    }

    if (widget.enableHapticFeedback) {
      HapticFeedback.selectionClick();
    }
    final nestedContext = MenuRouter.of(context).navigationKey.currentContext;
    if (nestedContext != null) {
      Navigator.of(nestedContext).pushReplacementNamed(routes[index].path);
    }
  }

  List<BartMenuRoute> get mainRoutes => routes
      .where((route) => route.type == BartMenuRouteType.bottomNavigation)
      .toList();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: currentIndexNotifier,
      builder: ((context, int index, child) {
        switch (widget.theme) {
          case Theme.cupertino:
            return BartCupertinoBottomBar(
              routes: mainRoutes,
              theme: widget.bottomBarTheme! as CupertinoBottomBarTheme,
              currentIndex: index,
              onTap: onTap,
            );

          case Theme.material:
            return BartMaterialBottomBar(
              routes: mainRoutes,
              theme: widget.bottomBarTheme! as Material2BottomBarTheme,
              currentIndex: index,
              onTap: onTap,
            );
          case Theme.material3:
            return BartMaterial3BottomBar(
              routes: routes,
              theme: widget.bottomBarTheme! as Material3BottomBarTheme,
              currentIndex: index,
              onTap: onTap,
            );
          default:
            return widget.bottomBarCustom!.create(
              routes: mainRoutes,
              currentIndex: index,
              onTap: onTap,
            );
        }
      }),
    );
  }
}
