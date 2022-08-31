import 'package:bart/bart/bart_model.dart';
import 'package:flutter/material.dart';

class NestedNavigator extends StatelessWidget {
  final GlobalKey<NavigatorState> navigationKey;
  final NavigatorObserver? navigatorObserver;
  final String? initialRoute;
  final List<BartMenuRoute> routes;
  final Function()? onWillPop;

  NestedNavigator({
    required this.navigationKey,
    this.initialRoute,
    required this.routes,
    this.navigatorObserver,
    this.onWillPop,
  });

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Navigator(
        key: navigationKey,
        initialRoute: initialRoute,
        observers: navigatorObserver != null ? [navigatorObserver!] : [],
        onGenerateRoute: (RouteSettings routeSettings) {
          final route = routes.firstWhere(
            (element) => element.path == routeSettings.name,
            orElse: () => routes.first,
          );
          // TODO: routeSettings unused ???
          if (routeSettings.name == initialRoute) {
            return PageRouteBuilder(
              pageBuilder: (context, __, ___) =>
                  route.pageBuilder(context, routeSettings),
              settings: routeSettings,
            );
          } else {
            return MaterialPageRoute(
              builder: (context) => route.pageBuilder(context, routeSettings),
              settings: routeSettings,
            );
          }
        },
      ),
      onWillPop: () {
        if (this.onWillPop != null) {
          this.onWillPop!();
        }
        if (navigationKey.currentState!.canPop()) {
          navigationKey.currentState!.pop();
          return Future<bool>.value(false);
        }
        return Future<bool>.value(true);
      },
    );
  }
}
