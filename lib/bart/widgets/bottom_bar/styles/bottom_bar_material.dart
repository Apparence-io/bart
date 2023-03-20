import 'package:bart/bart/bart_model.dart';
import 'package:bart/bart/widgets/bottom_bar/bottom_bar.dart';
import 'package:flutter/material.dart';

class BartMaterialBottomBar extends StatelessWidget {
  final List<BartMenuRoute> routes;
  final BottomBarTapAction onTap;
  final int currentIndex;
  final Material2BottomBarTheme theme;

  const BartMaterialBottomBar({
    Key? key,
    required this.routes,
    required this.onTap,
    required this.currentIndex,
    required this.theme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: theme.height,
      child: BottomNavigationBar(
        items: routeWidgetList,
        currentIndex: currentIndex,
        elevation: theme.elevation,
        iconSize: theme.iconSize,
        backgroundColor: theme.bgColor,
        type: theme.type ?? BottomNavigationBarType.fixed,
        selectedIconTheme: theme.iconThemeData,
        selectedItemColor: theme.selectedItemColor,
        unselectedItemColor: theme.unselectedItemColor,
        selectedFontSize: theme.selectedFontSize,
        unselectedFontSize: theme.unselectedFontSize,
        onTap: (index) => onTap(index),
      ),
    );
  }

  List<BottomNavigationBarItem> get routeWidgetList => routes
      .map((route) => BottomNavigationBarItem(
            icon: Icon(route.icon),
            label: route.label,
          ))
      .toList();
}

class BartMaterial3BottomBar extends StatelessWidget {
  final List<BartMenuRoute> routes;
  final BottomBarTapAction onTap;
  final int currentIndex;
  final Material3BottomBarTheme theme;

  const BartMaterial3BottomBar({
    Key? key,
    required this.routes,
    required this.onTap,
    required this.currentIndex,
    required this.theme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      destinations: routeWidgetList,
      elevation: theme.elevation,
      backgroundColor: theme.bgColor,
      height: theme.height,
      onDestinationSelected: onTap,
      animationDuration: theme.animationDuration,
      labelBehavior: theme.labelBehavior,
    );
  }

  List<NavigationDestination> get routeWidgetList => routes
      .where((element) => element.type == BartMenuRouteType.bottomNavigation)
      .map((route) => NavigationDestination(
            icon: Icon(route.icon),
            label: route.label ?? '',
            selectedIcon:
                route.selectedIcon != null ? Icon(route.selectedIcon) : null,
          ))
      .toList();
}
