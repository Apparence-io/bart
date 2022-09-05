import 'package:bart/bart/bart_model.dart';
import 'package:bart/bart/widgets/bottom_bar/bottom_bar.dart';
import 'package:flutter/cupertino.dart';

class BartCupertinoBottomBar extends StatelessWidget {
  final List<BartMenuRoute> routes;
  final BottomBarTapAction onTap;
  final int currentIndex;

  final Color? bgColor, selectedItemColor, unselectedItemColor;
  final double iconSize;
  final Border? border;
  final double? height;

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
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoTabBar(
      items: routeWidgetList,
      currentIndex: currentIndex,
      iconSize: iconSize,
      border: border,
      backgroundColor: bgColor,
      activeColor: selectedItemColor,
      height: height ?? 50.0,
      inactiveColor: unselectedItemColor ?? CupertinoColors.inactiveGray,
      onTap: (index) => onTap(index),
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
