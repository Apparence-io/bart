import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'bart_model.dart';

class Bart extends StatelessWidget {

  final ValueNotifier<int> currentIndex;
  final MenuRouterDelegate menuRouterDelegate;

  // bart attributes
  final List<BartMenuRoute> routes;
  final String initialRoute;
  final List<NavigatorObserver> navigatorObservers;

  // BottomNavigationBar attributes
  final double elevation;
  final Color bgColor, selectedItemColor, unselectedItemColor;
  final BottomNavigationBarType type;
  final IconThemeData iconThemeData;
  final double iconSize;
  final double selectedFontSize, unselectedFontSize;

  Bart({
    @required this.routes,
    this.navigatorObservers,
    this.initialRoute,
    this.elevation,
    this.bgColor, this.selectedItemColor, this.unselectedItemColor,
    this.type,
    this.iconThemeData,
    this.selectedFontSize = 14.0,
    this.unselectedFontSize = 12.0,
    this.iconSize = 24,
  }) : this.menuRouterDelegate = MenuRouterDelegate(routes, initialRoute, navigatorObservers),
       this.currentIndex = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Router(
        routerDelegate: menuRouterDelegate,
      ),
      bottomNavigationBar: _buildBottomBar(context),
    );
  }

  _buildBottomBar(BuildContext context)
    => ValueListenableBuilder(
      valueListenable: currentIndex,
      builder: (ctx, value, child ) {
        return BottomNavigationBar(
          items: routes.map((route) => BottomNavigationBarItem(
            icon: Icon(route.icon),
            label: route.label,
          )).toList(),
          currentIndex: value,
          elevation: elevation,
          iconSize: iconSize,
          backgroundColor: bgColor,
          type: type ?? BottomNavigationBarType.fixed,
          selectedIconTheme: iconThemeData,
          selectedItemColor: selectedItemColor,
          unselectedItemColor: unselectedItemColor,
          onTap: (index) {
            currentIndex.value = index;
            menuRouterDelegate.goPage(index);
          },
          // onTap: _onItemTapped,
        );
      },
    );
}

class MenuRouterDelegate extends RouterDelegate<MenuRoutePath> with ChangeNotifier, PopNavigatorRouterDelegateMixin<MenuRoutePath> {

  final List<BartMenuRoute> routes;
  final String initialRoute;
  final List<NavigatorObserver> navigatorObservers;

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  MaterialPageRoute _currentRoute, _oldRoute;

  MenuRouterDelegate(this.routes, this.initialRoute, this.navigatorObservers);

  void goPage(int n) {
    if(routes[n].path == _currentRoute.settings.name)
      return;
    navigatorKey.currentState.pushNamed(routes[n].path);
    notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      initialRoute: initialRoute ?? routes.first.path,
      onGenerateRoute: (RouteSettings settings) {
        var searchedRoute = routes
          .firstWhere((element) => element.path == settings.name, orElse: () => routes.first);
        _oldRoute = _currentRoute;
        _currentRoute = MaterialPageRoute(
          builder: searchedRoute.pageBuilder,
          settings: searchedRoute.settings,
          maintainState: searchedRoute.maintainState ?? true
        );
        navigatorObservers.forEach((element) {
          element.didPush(_currentRoute, _oldRoute);
          // element.didReplace(newRoute: _currentRoute, oldRoute: _oldRoute);
        });
        return _currentRoute;
      }
    );
  }

  @override
  Future<void> setNewRoutePath(MenuRoutePath configuration) async {
    print("setNewRoutePath ${configuration.toString()}");
  }

}