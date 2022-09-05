import 'package:bart/bart/bart_model.dart';
import 'package:bart/bart/widgets/bottom_bar/bottom_bar.dart';
import 'package:flutter/material.dart';

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
          element.type == BartMenuRouteType.bottomNavigation)
      .map((route) => BottomNavigationBarItem(
            icon: Icon(route.icon),
            label: route.label,
          ))
      .toList();
}
