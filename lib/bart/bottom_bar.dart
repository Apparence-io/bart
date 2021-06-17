import 'package:flutter/material.dart';

import 'bart_model.dart';
import 'bart_page.dart';

typedef BottonBarTapAction = void Function(int index);

class BartBottomBar extends StatelessWidget {
  final ValueNotifier<int> currentIndex;
  final MenuRouterDelegate menuRouterDelegate;

  final double? elevation;
  final Color? bgColor, selectedItemColor, unselectedItemColor;
  final BottomNavigationBarType? type;
  final IconThemeData? iconThemeData;
  final double iconSize;
  final double selectedFontSize, unselectedFontSize;

  /// use [BartMaterialBottomBar.bottomBarFactory] by default but you can create your own
  final BartBottomBarFactory bottomBarFactory;

  BartBottomBar._({
    required this.menuRouterDelegate,
    required this.bottomBarFactory,
    this.elevation,
    this.bgColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.type,
    this.iconThemeData,
    this.selectedFontSize = 14.0,
    this.unselectedFontSize = 12.0,
    this.iconSize = 24,
    required this.currentIndex,
  });

  factory BartBottomBar.material(
          {required List<BartMenuRoute> routes,
          String? initialRoute,
          List<NavigatorObserver>? navigatorObservers,
          double? elevation,
          Color? bgColor,
          Color? selectedItemColor,
          Color? unselectedItemColor,
          BottomNavigationBarType? type,
          IconThemeData? iconThemeData,
          double selectedFontSize = 14.0,
          double unselectedFontSize = 12.0,
          double iconSize = 24,
          int index = 0}) =>
      BartBottomBar._(
        bottomBarFactory: BartMaterialBottomBar.bottomBarFactory,
        menuRouterDelegate: MenuRouterDelegate(routes, initialRoute, navigatorObservers),
        elevation: elevation,
        bgColor: bgColor,
        selectedItemColor: selectedItemColor,
        unselectedItemColor: unselectedItemColor,
        type: type,
        iconThemeData: iconThemeData,
        selectedFontSize: selectedFontSize,
        unselectedFontSize: unselectedFontSize,
        iconSize: iconSize,
        currentIndex: ValueNotifier(index),
      );

  factory BartBottomBar.fromFactory(
          {required List<BartMenuRoute> routes,
          required BartBottomBarFactory bottomBarFactory,
          String? initialRoute,
          List<NavigatorObserver>? navigatorObservers,
          double? elevation,
          Color? bgColor,
          Color? selectedItemColor,
          Color? unselectedItemColor,
          BottomNavigationBarType? type,
          IconThemeData? iconThemeData,
          double selectedFontSize = 14.0,
          double unselectedFontSize = 12.0,
          double iconSize = 24,
          int index = 0}) =>
      BartBottomBar._(
        bottomBarFactory: bottomBarFactory,
        menuRouterDelegate: MenuRouterDelegate(routes, initialRoute, navigatorObservers),
        elevation: elevation,
        bgColor: bgColor,
        selectedItemColor: selectedItemColor,
        unselectedItemColor: unselectedItemColor,
        type: type,
        iconThemeData: iconThemeData,
        selectedFontSize: selectedFontSize,
        unselectedFontSize: unselectedFontSize,
        iconSize: iconSize,
        currentIndex: ValueNotifier(index),
      );

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: currentIndex,
      builder: (ctx, value, child) => bottomBarFactory.create(
        this,
        (index) {
          currentIndex.value = index;
          menuRouterDelegate.goPage(index);
        },
      ),
    );
  }

  List<BartMenuRoute> get routes => menuRouterDelegate.routes;
}

/// allows to create a bottom bar styled
abstract class BartBottomBarFactory {
  const BartBottomBarFactory();

  @factory
  Widget create(BartBottomBar bartBottomBar, BottonBarTapAction onTapAction);
}

class _BartMaterialBottomBarFactory extends BartBottomBarFactory {
  const _BartMaterialBottomBarFactory();

  @override
  Widget create(BartBottomBar bartBottomBar, BottonBarTapAction onTapAction) {
    return BartMaterialBottomBar(
      onTap: onTapAction,
      bartBottomBar: bartBottomBar,
    );
  }
}

class BartMaterialBottomBar extends StatelessWidget {
  final BartBottomBar bartBottomBar;
  final BottonBarTapAction onTap;

  BartMaterialBottomBar({
    required this.bartBottomBar,
    required this.onTap,
  });

  static const BartBottomBarFactory bottomBarFactory = _BartMaterialBottomBarFactory();

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: routeWidgetList,
      currentIndex: bartBottomBar.currentIndex.value,
      elevation: bartBottomBar.elevation,
      iconSize: bartBottomBar.iconSize,
      backgroundColor: bartBottomBar.bgColor,
      type: bartBottomBar.type ?? BottomNavigationBarType.fixed,
      selectedIconTheme: bartBottomBar.iconThemeData,
      selectedItemColor: bartBottomBar.selectedItemColor,
      unselectedItemColor: bartBottomBar.unselectedItemColor,
      onTap: (index) => onTap(index),
    );
  }

  List<BottomNavigationBarItem> get routeWidgetList => bartBottomBar.routes
      .where((element) => element.routingType == BartMenuRouteType.BOTTOM_NAV)
      .map((route) => BottomNavigationBarItem(
            icon: Icon(route.icon),
            label: route.label,
          ))
      .toList();
}
