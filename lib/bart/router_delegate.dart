import 'package:bart/bart/bart_appbar.dart';
import 'package:bart/bart/widgets/bottom_bar/bottom_bar.dart';
import 'package:flutter/material.dart';

import 'bart_model.dart';

class MenuRouter extends InheritedWidget {
  final BartRouteBuilder routesBuilder;
  final GlobalKey<NavigatorState> navigationKey;
  final ValueNotifier<int> indexNotifier;

  MenuRouter({
    Key? key,
    String? initialRoute,
    required BartRouteBuilder routesBuilder,
    required GlobalKey<NavigatorState> navigationKey,
    required ValueNotifier<int> indexNotifier,
    List<NavigatorObserver>? navigatorObservers,
    required Widget child,
  })  : routesBuilder = routesBuilder,
        navigationKey = navigationKey,
        indexNotifier = indexNotifier,
        super(key: key, child: child);

  static MenuRouter of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<MenuRouter>()!;

  @override
  bool updateShouldNotify(MenuRouter oldWidget) {
    return true;
  }
}
