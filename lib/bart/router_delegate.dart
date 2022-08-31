import 'package:flutter/material.dart';

import 'package:bart/bart/bart_appbar.dart';
import 'package:bart/bart/widgets/bottom_bar/bottom_bar.dart';
import 'package:bart/bart/widgets/nested_navigator.dart';

import 'bart_model.dart';

class MenuRouter extends InheritedWidget {
  final BartRouteBuilder routesBuilder;
  GlobalKey<NavigatorState> navigationKey;
  final ValueNotifier<int> indexNotifier;

  MenuRouter({
    Key? key,
    String? initialRoute,
    required this.routesBuilder,
    required this.navigationKey,
    required this.indexNotifier,
    required Widget child,
  }) : super(key: key, child: child);

  static MenuRouter of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<MenuRouter>()!;

  @override
  bool updateShouldNotify(MenuRouter oldWidget) {
    return true;
  }
}

class RouteAwareWidget extends StatefulWidget {
  final BartMenuRoute route;
  final Widget child;
  const RouteAwareWidget({
    Key? key,
    required this.route,
    required this.child,
  }) : super(key: key);

  @override
  State<RouteAwareWidget> createState() => _RouteAwareWidgetState();
}

class _RouteAwareWidgetState extends State<RouteAwareWidget> with RouteAware {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPush() {
    print('didPush ${widget.route.path}');
  }

  @override
  void didPopNext() {
    print('didPopNext ${widget.route.path}');
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
