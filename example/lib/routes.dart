import 'package:bart/bart.dart';
import 'package:example/fake_page.dart';
import 'package:example/page_counter.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';
import 'route_observer.dart';
import 'package:animations/animations.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final CustomNavigatorObserver<PageRoute> routeObserver =
    CustomNavigatorObserver<PageRoute>();

Future appPushNamed(String route, {Object? arguments}) =>
    navigatorKey.currentState!.pushNamed(route, arguments: arguments);

List<BartMenuRoute> subRoutes() {
  return [
    BartMenuRoute.bottomBar(
      label: "Home",
      icon: Icons.home,
      path: '/home',
      pageBuilder: (context, settings) => HomePage(),
    ),
    BartMenuRoute.bottomBar(
      label: "Library",
      icon: Icons.video_library_rounded,
      path: '/library',
      pageBuilder: (context, settings) => PageFake(
        Colors.blueGrey,
        key: PageStorageKey<String>("library"),
      ),
      transitionDuration: Duration(milliseconds: 500),
      transitionsBuilder: (context, anim1, anim2, widget) =>
          FadeThroughTransition(
        animation: anim1,
        secondaryAnimation: anim2,
        child: widget,
        // fillColor: Colors.white,
      ),
    ),
    BartMenuRoute.bottomBar(
      label: "Profile",
      icon: Icons.person,
      path: '/profile',
      pageBuilder: (contextn, settings) => PageFake(
        Colors.yellow,
        key: PageStorageKey<String>("profile"),
      ),
    ),
    BartMenuRoute.bottomBar(
      label: "Counter",
      icon: Icons.countertops,
      path: '/counter',
      pageBuilder: (context, settings) => PageFakeCounter(showAppBar: true),
    ),
    BartMenuRoute.innerRoute(
      path: '/subpage',
      pageBuilder: (context, settings) => PageFake(
        Colors.greenAccent,
        child: Text("Sub Route page"),
      ),
    ),
  ];
}

Route<dynamic> routes(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return MaterialPageRoute(
          builder: (_) => MainPageMenu(routesBuilder: subRoutes));
    default:
      throw 'unexpected Route';
  }
}

class MainPageMenu extends StatelessWidget {
  final BartRouteBuilder routesBuilder;

  const MainPageMenu({Key? key, required this.routesBuilder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BartScaffold(
      routesBuilder: routesBuilder,
      navigatorObservers: [routeObserver],
      bottomBar: BartBottomBar.fromFactory(
        bottomBarFactory: BartMaterialBottomBar.bottomBarFactory,
      ),
    );
  }
}
