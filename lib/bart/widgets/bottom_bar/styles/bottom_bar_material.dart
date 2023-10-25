import 'package:bart/bart/bart_model.dart';
import 'package:bart/bart/widgets/bottom_bar/bottom_bar.dart';
import 'package:flutter/material.dart';

class BartMaterialBottomBar extends StatefulWidget {
  final List<BartMenuRoute> routes;
  final BottomBarTapAction onTap;
  final Material2BottomBarTheme theme;
  final ValueNotifier<int> currentIndexNotifier;

  const BartMaterialBottomBar({
    super.key,
    required this.routes,
    required this.onTap,
    required this.currentIndexNotifier,
    required this.theme,
  });

  @override
  State<BartMaterialBottomBar> createState() => _BartMaterialBottomBarState();
}

class _BartMaterialBottomBarState extends State<BartMaterialBottomBar> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.currentIndexNotifier,
      builder: (context, int index, child) {
        return SizedBox(
          height: widget.theme.height,
          child: BottomNavigationBar(
            items: routeWidgetList,
            currentIndex: widget.currentIndexNotifier.value,
            elevation: widget.theme.elevation,
            iconSize: widget.theme.iconSize,
            backgroundColor: widget.theme.bgColor,
            type: widget.theme.type ?? BottomNavigationBarType.fixed,
            selectedIconTheme: widget.theme.iconThemeData,
            selectedItemColor: widget.theme.selectedItemColor,
            unselectedItemColor: widget.theme.unselectedItemColor,
            selectedFontSize: widget.theme.selectedFontSize,
            unselectedFontSize: widget.theme.unselectedFontSize,
            onTap: (index) => widget.onTap(index),
          ),
        );
      },
    );
  }

  List<BottomNavigationBarItem> get routeWidgetList => widget.routes
      .map((route) => BottomNavigationBarItem(
            icon: Icon(route.icon),
            label: route.label,
          ))
      .toList();
}

class BartMaterial3BottomBar extends StatefulWidget {
  final List<BartMenuRoute> routes;
  final BottomBarTapAction onTap;
  final Material3BottomBarTheme theme;
  final ValueNotifier<int> currentIndexNotifier;

  const BartMaterial3BottomBar({
    super.key,
    required this.routes,
    required this.onTap,
    required this.currentIndexNotifier,
    required this.theme,
  });

  @override
  State<BartMaterial3BottomBar> createState() => _BartMaterial3BottomBarState();
}

class _BartMaterial3BottomBarState extends State<BartMaterial3BottomBar> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.currentIndexNotifier,
      builder: (context, int index, child) {
        return NavigationBar(
          selectedIndex: index,
          destinations: getRouteWidgetList(context),
          elevation: widget.theme.elevation,
          backgroundColor: widget.theme.bgColor,
          height: widget.theme.height,
          onDestinationSelected: widget.onTap,
          animationDuration: widget.theme.animationDuration,
          labelBehavior: widget.theme.labelBehavior,
        );
      },
    );
  }

  List<NavigationDestination> getRouteWidgetList(BuildContext context) =>
      widget.routes
          .where(
              (element) => element.type == BartMenuRouteType.bottomNavigation)
          .map(
        (route) {
          if (route.icon != null) {
            return NavigationDestination(
              icon: Icon(route.icon),
              label: route.label ?? '',
              selectedIcon:
                  route.selectedIcon != null ? Icon(route.selectedIcon) : null,
            );
          } else if (route.iconBuilder != null) {
            return NavigationDestination(
              icon: route.iconBuilder!(context),
              label: route.label ?? '',
              // selectedIcon: route.selectedIconBuilder != null
              //     ? route.selectedIconBuilder!(context)
              //     : null,
            );
          }
          throw Exception(
            "You must provide an icon or an iconBuilder for each route",
          );
        },
      ).toList();
}
