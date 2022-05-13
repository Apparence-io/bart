import 'package:bart/bart/utils.dart';
import 'package:flutter/material.dart';

import 'bart_model.dart';
import 'router_delegate.dart';

typedef BottonBarTapAction = void Function(int index);

typedef BartRouteBuilder = List<BartMenuRoute> Function();

class BartBottomBar extends StatefulWidget {
  final ValueNotifier<int> currentIndex;
  final double? elevation;
  final Color? bgColor, selectedItemColor, unselectedItemColor;
  final BottomNavigationBarType? type;
  final IconThemeData? iconThemeData;
  final double iconSize;
  final double selectedFontSize, unselectedFontSize;

  /// use [BartMaterialBottomBar.bottomBarFactory] by default but you can create your own
  final BartBottomBarFactory bottomBarFactory;

  BartBottomBar._({
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
          {double? elevation,
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
          {required BartBottomBarFactory bottomBarFactory,
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
  _BartBottomBarState createState() => _BartBottomBarState();
}

class _BartBottomBarState extends State<BartBottomBar> {
  List<BartMenuRoute> get routes =>
      MenuRouter.of(context).routerDelegate.routes;

  MenuRouterDelegate get routerDelegate =>
      MenuRouter.of(context).routerDelegate;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: widget.currentIndex,
      builder: (ctx, value, child) => widget.bottomBarFactory.create(
        routes: routes,
        elevation: widget.elevation,
        bgColor: widget.bgColor,
        selectedItemColor: widget.selectedItemColor,
        unselectedItemColor: widget.unselectedItemColor,
        type: widget.type,
        iconThemeData: widget.iconThemeData,
        selectedFontSize: widget.selectedFontSize,
        unselectedFontSize: widget.unselectedFontSize,
        iconSize: widget.iconSize,
        currentIndex: value,
        onTapAction: (index) {
          widget.currentIndex.value = index;
          routerDelegate.goPage(index);
        },
      ),
    );
  }
}

/// allows to create a bottom bar styled
abstract class BartBottomBarFactory {
  const BartBottomBarFactory();

  @factory
  Widget create({
    required List<BartMenuRoute> routes,
    required BottonBarTapAction onTapAction,
    double? elevation,
    Color? bgColor,
    Color? selectedItemColor,
    Color? unselectedItemColor,
    BottomNavigationBarType? type,
    IconThemeData? iconThemeData,
    required double selectedFontSize,
    required double unselectedFontSize,
    required double iconSize,
    required int currentIndex,
  });
}

class _BartMaterialBottomBarFactory extends BartBottomBarFactory {
  const _BartMaterialBottomBarFactory();

  @override
  Widget create({
    required List<BartMenuRoute> routes,
    required BottonBarTapAction onTapAction,
    double? elevation,
    Color? bgColor,
    Color? selectedItemColor,
    Color? unselectedItemColor,
    BottomNavigationBarType? type,
    IconThemeData? iconThemeData,
    required double selectedFontSize,
    required double unselectedFontSize,
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
      selectedFontSize: selectedFontSize,
      unselectedFontSize: unselectedFontSize,
      iconSize: iconSize,
      currentIndex: currentIndex,
    );
  }
}

class BartMaterialBottomBar extends StatelessWidget {
  final List<BartMenuRoute> routes;
  final BottonBarTapAction onTap;
  final int currentIndex;

  final double? elevation;
  final Color? bgColor, selectedItemColor, unselectedItemColor;
  final BottomNavigationBarType? type;
  final IconThemeData? iconThemeData;
  final double iconSize;
  final double selectedFontSize, unselectedFontSize;

  BartMaterialBottomBar({
    required this.routes,
    required this.onTap,
    required this.currentIndex,
    this.elevation,
    this.bgColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.type,
    this.iconThemeData,
    this.selectedFontSize = 14.0,
    this.unselectedFontSize = 12.0,
    this.iconSize = 24,
  });

  static const BartBottomBarFactory bottomBarFactory =
      _BartMaterialBottomBarFactory();

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: routeWidgetList,
      currentIndex: currentIndex,
      elevation: elevation,
      iconSize: iconSize,
      backgroundColor: bgColor,
      type: type ?? BottomNavigationBarType.fixed,
      selectedIconTheme: iconThemeData,
      selectedItemColor: selectedItemColor,
      unselectedItemColor: unselectedItemColor,
      onTap: (index) => onTap(index),
    );
  }

  List<BottomNavigationBarItem> get routeWidgetList => routes
      .where((element) => element.routingType == BartMenuRouteType.BOTTOM_NAV)
      .map((route) => BottomNavigationBarItem(
            icon: Icon(route.icon),
            label: route.label,
          ))
      .toList();
}

/// Use this intent to change the current index
class BottomBarIndexIntent extends Intent {
  final int index;

  BottomBarIndexIntent(this.index);
}

/// you can change the current index by calling
/// Actions.invoke(context, AppBarBuildIntent(AppBar(title: Text("title text"))));
class BartBottomBarIndexAction extends Action<BottomBarIndexIntent> {
  ValueNotifier<int> indexNotifier;

  BartBottomBarIndexAction(this.indexNotifier);

  @override
  void invoke(covariant BottomBarIndexIntent intent) {
    ambiguate(WidgetsBinding.instance)!.addPostFrameCallback((timeStamp) {
      this.indexNotifier.value = intent.index;
    });
  }
}
