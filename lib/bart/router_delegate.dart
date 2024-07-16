import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:bart/bart/widgets/bottom_bar/bottom_bar.dart';
import 'package:bart/bart/widgets/nested_navigator.dart';
import 'package:universal_html/html.dart';

import 'bart_model.dart';

typedef OnRouteChanged = void Function(BartMenuRoute route);

class MenuRouter extends InheritedWidget {
  final BartRouteBuilder routesBuilder;
  final GlobalKey<NavigatorState> navigationKey;
  final ValueNotifier<int> indexNotifier;
  final ValueNotifier<BartMenuRouteType> routingTypeNotifier;
  final OnRouteChanged? onRouteChanged;
  
  MenuRouter({
    super.key,
    String? initialRoute,
    required this.routesBuilder,
    required this.navigationKey,
    required this.indexNotifier,
    required this.routingTypeNotifier,
    this.onRouteChanged,
    required super.child,
  }) {
    if (initialRoute != null) {
      final index = _currentIndex(initialRoute);
      indexNotifier.value = index;
    }
  }

  void updateRoute(String path) {
    final route = _currentRoute(path);
    final index = _currentIndex(path);
    if(indexNotifier.value == index) {
      return;
    }

    handleWebUrl(route);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      indexNotifier.value = index;
      routingTypeNotifier.value = route.type;
      onRouteChanged?.call(route);
    });
  }

  void handleWebUrl(BartMenuRoute route) {
    if (!kIsWeb) {
      return;
    }
    final uri = Uri(path: route.path);
    window.history.pushState(null, '', uri.toString());
  }

  int _currentIndex(String path) {
    
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

  String removePath(String path) => path.replaceAll('/', '');

  static MenuRouter of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<MenuRouter>()!;

  @override
  bool updateShouldNotify(MenuRouter oldWidget) {
    return true;
  }

  BartMenuRoute _currentRoute(String path) {
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
    super.key,
    required this.route,
    required this.child,
    required this.appBarNotifier,
    required this.showAppBarNotifier,
  });

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
    MenuRouter.of(context).updateRoute(widget.route.path);
  }

  @override
  void didPopNext() {
    MenuRouter.of(context).updateRoute(widget.route.path);
  }

  // @override
  // void didPop() {

  // }

  @override
  Widget build(BuildContext context) => widget.child;
}
