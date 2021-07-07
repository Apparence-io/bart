import 'package:bart/bart/bart_appbar.dart';
import 'package:flutter/material.dart';

import 'bart_model.dart';
import 'bottom_bar.dart';

class MenuRouter extends InheritedWidget {
  final Widget child;
  final MenuRouterDelegate routerDelegate;

  MenuRouter({
    Key? key,
    String? initialRoute,
    required BartRouteBuilder routesBuilder,
    List<NavigatorObserver>? navigatorObservers,
    required this.child,
  })  : routerDelegate = MenuRouterDelegate(
            routesBuilder.call(), initialRoute, navigatorObservers),
        super(key: key, child: child);

  static MenuRouter of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<MenuRouter>()!;

  @override
  bool updateShouldNotify(MenuRouter oldWidget) {
    this.routerDelegate.initialRoute =
        oldWidget.routerDelegate._currentRoute?.path;
    return true;
  }
}

class MenuRouterDelegate extends RouterDelegate<MenuRoutePath>
    with
        ChangeNotifier,
        PopNavigatorRouterDelegateMixin<MenuRoutePath>,
        AppBarNotifier {
  final List<BartMenuRoute> routes;
  String? initialRoute;
  final List<NavigatorObserver>? navigatorObservers;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final Map<String, Widget> pageCache = Map();
  BartMenuRoute? _currentRoute;

  MenuRouterDelegate(this.routes, this.initialRoute, this.navigatorObservers);

  void goPage(int n) {
    if (routes[n].path == _currentRoute!.path) return;
    navigatorKey.currentState!.pushReplacementNamed(routes[n].path);
    notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
        key: navigatorKey,
        initialRoute: initialRoute ?? routes.first.path,
        onGenerateRoute: (RouteSettings settings) {
          Actions.invoke(context, AppBarBuildIntent.empty());
          hideAppBar(context);
          var searchedRoute = routes.firstWhere(
            (element) => element.path == settings.name,
            orElse: () => routes.first,
          );
          _currentRoute = searchedRoute;
          var pageRoute = PageRouteBuilder(
              maintainState: searchedRoute.maintainState ?? true,
              settings: settings,
              pageBuilder: (context, __, ___) {
                if (searchedRoute.cache) {
                  if (!pageCache.containsKey(searchedRoute.path)) {
                    pageCache[searchedRoute.path] =
                        searchedRoute.pageBuilder(context, settings);
                  }
                  return pageCache[searchedRoute.path]!;
                }
                return searchedRoute.pageBuilder(context, settings);
              },
              transitionsBuilder: (_, a, __, c) =>
                  FadeTransition(opacity: a, child: c));
          if (navigatorObservers != null) {
            navigatorObservers!.forEach((element) {
              element.didPush(pageRoute, null);
              // element.didReplace(newRoute: _currentRoute, oldRoute: _oldRoute);
            });
          }
          if (_currentRoute!.routingType == BartMenuRouteType.BOTTOM_NAV) {
            var bottomBarList = this
                .routes
                .where((element) =>
                    element.routingType == BartMenuRouteType.BOTTOM_NAV)
                .toList();
            var indexOfItem = bottomBarList.indexOf(_currentRoute!);
            Actions.invoke(context, BottomBarIndexIntent(indexOfItem));
          }
          return pageRoute;
        });
  }

  @override
  Future<void> setNewRoutePath(MenuRoutePath configuration) async {}
}
