import 'package:flutter/material.dart';

import 'package:bart/bart/widgets/bottom_bar/bottom_bar.dart';
import 'package:bart/bart/widgets/nested_navigator.dart';

import 'bart_model.dart';

class MenuRouter extends InheritedWidget {
  final BartRouteBuilder routesBuilder;
  final GlobalKey<NavigatorState> navigationKey;
  final ValueNotifier<int> indexNotifier;
  final ValueNotifier<BartMenuRouteType> routingTypeNotifier;

  const MenuRouter({
    Key? key,
    String? initialRoute,
    required this.routesBuilder,
    required this.navigationKey,
    required this.indexNotifier,
    required this.routingTypeNotifier,
    required Widget child,
  }) : super(key: key, child: child);

  currentIndex(String path) {
    final extractedPath = path.split('/')
      ..removeWhere((element) => element.isEmpty);

    String domain;
    if (extractedPath.length > 1) {
      domain = extractedPath.first;
    } else {
      domain = path;
    }

    return routesBuilder().indexWhere(
      (element) => removePath(element.path) == removePath(domain),
    );
  }

  removePath(String path) => path.replaceAll('/', '');

  static MenuRouter of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<MenuRouter>()!;

  @override
  bool updateShouldNotify(MenuRouter oldWidget) {
    return true;
  }

  BartMenuRoute currentRoute(String path) {
    return routesBuilder().firstWhere(
      (element) => element.path == path,
      orElse: () => routesBuilder().first,
    );
  }
}

class RouteAwareWidget extends StatefulWidget {
  final BartMenuRoute route;
  final Widget child;
  final ValueNotifier<PreferredSizeWidget?> appBarNotifier;
  final ValueNotifier<bool> showAppBarNotifier;
  const RouteAwareWidget({
    Key? key,
    required this.route,
    required this.child,
    required this.appBarNotifier,
    required this.showAppBarNotifier,
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

  void refreshIndex() {
    final index = MenuRouter.of(context).currentIndex(widget.route.path);
    final route = MenuRouter.of(context).currentRoute(widget.route.path);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      MenuRouter.of(context).indexNotifier.value = index;
      MenuRouter.of(context).routingTypeNotifier.value = route.routingType;
    });
  }

  @override
  void didPush() {
    refreshIndex();
  }

  @override
  void didPopNext() {
    refreshIndex();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
