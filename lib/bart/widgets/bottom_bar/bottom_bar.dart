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

enum Theme { material, cupertino, custom }

class BartBottomBar extends StatefulWidget {
  final int currentIndex;
  final double? elevation;
  final double? height;
  final Color? bgColor, selectedItemColor, unselectedItemColor;
  final BottomNavigationBarType? type;
  final IconThemeData? iconThemeData;
  final double iconSize;
  final bool enableHapticFeedback;
  final double selectedFontSize, unselectedFontSize;
  final Theme theme;
  final BartBottomBarCustom? bottomBarCustom;

  const BartBottomBar._({
    this.elevation,
    this.bgColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.type,
    this.height,
    this.enableHapticFeedback = true,
    this.iconThemeData,
    this.selectedFontSize = 14.0,
    this.unselectedFontSize = 12.0,
    this.iconSize = 24,
    this.bottomBarCustom,
    required this.theme,
    required this.currentIndex,
  });

  factory BartBottomBar.material({
    double? elevation,
    Color? bgColor,
    Color? selectedItemColor,
    Color? unselectedItemColor,
    double? height,
    BottomNavigationBarType? type,
    bool enableHapticFeedback = true,
    IconThemeData? iconThemeData,
    double selectedFontSize = 14.0,
    double unselectedFontSize = 12.0,
    double iconSize = 24,
    int index = 0,
  }) =>
      BartBottomBar._(
        elevation: elevation,
        bgColor: bgColor,
        enableHapticFeedback: enableHapticFeedback,
        selectedItemColor: selectedItemColor,
        unselectedItemColor: unselectedItemColor,
        type: type,
        iconThemeData: iconThemeData,
        selectedFontSize: selectedFontSize,
        unselectedFontSize: unselectedFontSize,
        iconSize: iconSize,
        height: height,
        theme: Theme.material,
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
    bool enableHapticFeedback = true,
    double iconSize = 24,
    double? height,
    int index = 0,
  }) =>
      BartBottomBar._(
        bgColor: bgColor,
        enableHapticFeedback: enableHapticFeedback,
        selectedItemColor: selectedItemColor,
        unselectedItemColor: unselectedItemColor,
        type: type,
        height: height,
        iconSize: iconSize,
        theme: Theme.cupertino,
        currentIndex: index,
      );

  factory BartBottomBar.adaptive({
    double? elevation,
    Color? bgColor,
    Color? selectedItemColor,
    Color? unselectedItemColor,
    BottomNavigationBarType? type,
    bool enableHapticFeedback = true,
    IconThemeData? iconThemeData,
    double selectedFontSize = 14.0,
    double unselectedFontSize = 12.0,
    double iconSize = 24,
    double? height,
    int index = 0,
  }) =>
      BartBottomBar._(
        elevation: elevation,
        bgColor: bgColor,
        height: height,
        enableHapticFeedback: enableHapticFeedback,
        selectedItemColor: selectedItemColor,
        unselectedItemColor: unselectedItemColor,
        type: type,
        iconThemeData: iconThemeData,
        selectedFontSize: selectedFontSize,
        unselectedFontSize: unselectedFontSize,
        iconSize: iconSize,
        theme: Platform.isIOS ? Theme.cupertino : Theme.material,
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
        Widget bottomBar;
        switch (widget.theme) {
          case Theme.cupertino:
            bottomBar = BartCupertinoBottomBar(
              routes: mainRoutes,
              height: widget.height,
              bgColor: widget.bgColor,
              selectedItemColor: widget.selectedItemColor,
              unselectedItemColor: widget.unselectedItemColor,
              iconSize: widget.iconSize,
              currentIndex: index,
              onTap: onTap,
            );
            break;
          case Theme.material:
            bottomBar = BartMaterialBottomBar(
              routes: mainRoutes,
              elevation: widget.elevation,
              height: widget.height,
              bgColor: widget.bgColor,
              selectedItemColor: widget.selectedItemColor,
              unselectedItemColor: widget.unselectedItemColor,
              type: widget.type,
              iconThemeData: widget.iconThemeData,
              selectedFontSize: widget.selectedFontSize,
              unselectedFontSize: widget.unselectedFontSize,
              iconSize: widget.iconSize,
              currentIndex: index,
              onTap: onTap,
            );
            break;
          default:
            bottomBar = widget.bottomBarCustom!.create(
              routes: mainRoutes,
              currentIndex: index,
              onTap: onTap,
            );
        }
        return bottomBar;
      }),
    );
  }
}
