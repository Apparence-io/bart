import 'package:bart/bart/bart_model.dart';
import 'package:bart/bart/widgets/bottom_bar/bottom_bar.dart';
import 'package:flutter/cupertino.dart';

class BartCupertinoBottomBar extends StatelessWidget {
  final List<BartMenuRoute> routes;
  final BottomBarTapAction onTap;
  final int currentIndex;

  final CupertinoBottomBarTheme theme;

  const BartCupertinoBottomBar({
    Key? key,
    required this.routes,
    required this.onTap,
    required this.currentIndex,
    required this.theme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoTabBar(
      items: getRouteWidgetList(context),
      currentIndex: currentIndex,
      iconSize: theme.iconSize,
      border: theme.border,
      backgroundColor: theme.bgColor,
      activeColor: theme.selectedItemColor,
      height: theme.height ?? 50.0,
      inactiveColor: theme.unselectedItemColor ?? CupertinoColors.inactiveGray,
      onTap: (index) => onTap(index),
    );
  }

  List<BottomNavigationBarItem> getRouteWidgetList(BuildContext context) =>
      routes.map(
        (route) {
          if (route.icon != null) {
            return BottomNavigationBarItem(
              icon: Icon(route.icon),
              label: route.label,
            );
          } else if (route.iconBuilder != null) {
            return BottomNavigationBarItem(
              icon: route.iconBuilder!(context),
              label: route.label,
            );
          }
          throw Exception(
            "You must provide an icon or an iconBuilder for each route",
          );
        },
      ).toList();
}
