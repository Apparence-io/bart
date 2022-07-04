import 'package:bart/bart/bart_model.dart';
import 'package:bart/bart/bottom_bar/bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class _BartCupertinoBottomBarFactory extends BartBottomBarFactory {
  const _BartCupertinoBottomBarFactory();

  @override
  Widget create({
    required List<BartMenuRoute> routes,
    required BottomBarTapAction onTapAction,
    double? elevation,
    Color? bgColor,
    Border? border,
    Color? selectedItemColor,
    Color? unselectedItemColor,
    BottomNavigationBarType? type,
    IconThemeData? iconThemeData,
    double? selectedFontSize,
    double? unselectedFontSize,
    double? height,
    required double iconSize,
    required int currentIndex,
  }) {
    return BartCupertinoBottomBar(
      onTap: onTapAction,
      routes: routes,
      bgColor: bgColor,
      selectedItemColor: selectedItemColor,
      unselectedItemColor: unselectedItemColor,
      iconSize: iconSize,
      currentIndex: currentIndex,
      height: height ?? 50.0,
      border: border,
    );
  }
}

class BartCupertinoBottomBar extends StatelessWidget {
  final List<BartMenuRoute> routes;
  final BottomBarTapAction onTap;
  final int currentIndex;

  final Color? bgColor, selectedItemColor, unselectedItemColor;
  final double iconSize;
  final Border? border;
  final double height;

  const BartCupertinoBottomBar({
    Key? key,
    required this.routes,
    required this.onTap,
    required this.currentIndex,
    this.bgColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.border,
    this.iconSize = 24,
    this.height = 50.0,
  }) : super(key: key);

  static const BartBottomBarFactory bottomBarFactory =
      _BartCupertinoBottomBarFactory();

  @override
  Widget build(BuildContext context) {
    return CupertinoTabBar(
      items: routeWidgetList,
      currentIndex: currentIndex,
      iconSize: iconSize,
      border: border,
      backgroundColor: bgColor,
      activeColor: selectedItemColor,
      height: height,
      inactiveColor: unselectedItemColor ?? CupertinoColors.inactiveGray,
      onTap: (index) => onTap(index),
    );
  }

  List<BottomNavigationBarItem> get routeWidgetList => routes
      .where((element) =>
          element.routingType == BartMenuRouteType.bottomNavigation)
      .map((route) => BottomNavigationBarItem(
            icon: Icon(route.icon),
            label: route.label,
          ))
      .toList();
}
