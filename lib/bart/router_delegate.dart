import 'package:bart/bart/bart_appbar.dart';
import 'package:flutter/material.dart';

import 'bart_model.dart';
import 'bottom_bar/bottom_bar.dart';

class MenuRouter extends InheritedWidget {
  final MenuRouterDelegate routerDelegate;

  MenuRouter({
    Key? key,
    String? initialRoute,
    required BartRouteBuilder routesBuilder,
    List<NavigatorObserver>? navigatorObservers,
    required Widget child,
  })  : routerDelegate = MenuRouterDelegate(
          routesBuilder.call(),
          initialRoute,
          navigatorObservers,
        ),
        super(key: key, child: child);

  static MenuRouter of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<MenuRouter>()!;

  @override
  bool updateShouldNotify(MenuRouter oldWidget) {
    routerDelegate.initialRoute ??=
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

  @override
  final GlobalKey<NavigatorState> navigatorKey;

  final Map<String, Widget> pageCache = {};

  final PageStorageBucket bucket = PageStorageBucket();

  BartMenuRoute? _currentRoute;

  MenuRouterDelegate(
    this.routes,
    this.initialRoute,
    this.navigatorObservers,
  ) : navigatorKey = GlobalKey<NavigatorState>();

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
                  return PageStorage(
                    bucket: bucket,
                    child: pageCache[searchedRoute.path]!,
                  );
                }
                return searchedRoute.pageBuilder(context, settings);
              },
              transitionDuration: searchedRoute.transitionDuration ??
                  const Duration(milliseconds: 300),
              transitionsBuilder: searchedRoute.transitionsBuilder ??
                  (_, a, b, child) => child);
          if (navigatorObservers != null) {
            for (var element in navigatorObservers!) {
              element.didPush(pageRoute, null);
            }
          }
          if (_currentRoute!.routingType ==
              BartMenuRouteType.bottomNavigation) {
            var bottomBarList = routes
                .where((element) =>
                    element.routingType == BartMenuRouteType.bottomNavigation)
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
