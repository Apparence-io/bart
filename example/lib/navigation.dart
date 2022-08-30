import 'package:bart/bart.dart';
import 'package:example/routes.dart';
import 'package:flutter/material.dart';

class MainPageMenu extends StatelessWidget {
  final BartRouteBuilder routesBuilder;

  const MainPageMenu({Key? key, required this.routesBuilder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BartScaffold(
      routesBuilder: routesBuilder,
      navigatorObservers: [routeObserver],
      bottomBar: BartBottomBar.adaptive(
          // bottomBarFactory: BartCupertinoBottomBar.bottomBarFactory,
          ),
    );
  }
}
