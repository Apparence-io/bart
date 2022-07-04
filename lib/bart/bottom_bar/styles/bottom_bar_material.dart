import 'package:bart/bart/bart_model.dart';
import 'package:bart/bart/bottom_bar/bottom_bar.dart';
import 'package:flutter/material.dart';

class _BartMaterialBottomBarFactory extends BartBottomBarFactory {
  const _BartMaterialBottomBarFactory();

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
    return BartMaterialBottomBar(
      onTap: onTapAction,
      routes: routes,
      elevation: elevation,
      bgColor: bgColor,
      selectedItemColor: selectedItemColor,
      unselectedItemColor: unselectedItemColor,
      type: type,
      iconThemeData: iconThemeData,
      selectedFontSize: selectedFontSize ?? 14.0,
      unselectedFontSize: unselectedFontSize ?? 12.0,
      iconSize: iconSize,
      height: height,
      currentIndex: currentIndex,
    );
  }
}

class BartMaterialBottomBar extends StatelessWidget {
  final List<BartMenuRoute> routes;
  final BottomBarTapAction onTap;
  final int currentIndex;

  final double? elevation;
  final Color? bgColor, selectedItemColor, unselectedItemColor;
  final BottomNavigationBarType? type;
  final IconThemeData? iconThemeData;
  final double? height;
  final double iconSize;
  final double selectedFontSize, unselectedFontSize;

  const BartMaterialBottomBar({
    Key? key,
    required this.routes,
    required this.onTap,
    required this.currentIndex,
    this.height,
    this.elevation,
    this.bgColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.type,
    this.iconThemeData,
    this.selectedFontSize = 14.0,
    this.unselectedFontSize = 12.0,
    this.iconSize = 24,
  }) : super(key: key);

  static const BartBottomBarFactory bottomBarFactory =
      _BartMaterialBottomBarFactory();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: BottomNavigationBar(
        items: routeWidgetList,
        currentIndex: currentIndex,
        elevation: elevation,
        iconSize: iconSize,
        backgroundColor: bgColor,
        type: type ?? BottomNavigationBarType.fixed,
        selectedIconTheme: iconThemeData,
        selectedItemColor: selectedItemColor,
        unselectedItemColor: unselectedItemColor,
        selectedFontSize: selectedFontSize,
        unselectedFontSize: unselectedFontSize,
        onTap: (index) => onTap(index),
      ),
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
