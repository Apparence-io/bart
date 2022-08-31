import 'package:bart/bart/bart_model.dart';
import 'package:bart/bart/router_delegate.dart';
import 'package:flutter/material.dart';

final RouteObserver<dynamic> routeObserver = RouteObserver<PageRoute>();

class NestedNavigator extends StatefulWidget {
  final BuildContext parentContext;
  final GlobalKey<NavigatorState> navigationKey;
  final RouteObserver<dynamic> navigatorObserver;
  final String? initialRoute;
  final List<BartMenuRoute> routes;
  final Function()? onWillPop;

  const NestedNavigator({
    Key? key,
    required this.parentContext,
    required this.navigationKey,
    this.initialRoute,
    required this.routes,
    required this.navigatorObserver,
    this.onWillPop,
  }) : super(key: key);

  @override
  State<NestedNavigator> createState() => _NestedNavigatorState();
}

class _NestedNavigatorState extends State<NestedNavigator> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Navigator(
        key: widget.navigationKey,
        initialRoute: widget.initialRoute,
        observers: [routeObserver],
        onGenerateRoute: (RouteSettings routeSettings) {
          final route = widget.routes.firstWhere(
            (element) => element.path == routeSettings.name,
            orElse: () => widget.routes.first,
          );

          return MaterialPageRoute(
            builder: (context) => RouteAwareWidget(
              route: route,
              child: route.pageBuilder(
                widget.parentContext,
                routeSettings,
              ),
            ),
            settings: routeSettings,
          );
        },
      ),
      onWillPop: () {
        if (widget.onWillPop != null) {
          widget.onWillPop!();
        }
        if (widget.navigationKey.currentState!.canPop()) {
          widget.navigationKey.currentState!.pop();
          return Future<bool>.value(false);
        }
        return Future<bool>.value(true);
      },
    );
  }
}
