import 'package:bart/bart.dart';
import 'package:example/fake_page.dart';
import 'package:example/page_counter.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';
import 'route_observer.dart';

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
      pageBuilder: (context) => HomePage(),
    ),
    BartMenuRoute.bottomBar(
      label: "Library",
      icon: Icons.video_library_rounded,
      path: '/library',
      pageBuilder: (context) => PageFake(Colors.blueGrey),
    ),
    BartMenuRoute.bottomBar(
      label: "Profile",
      icon: Icons.person,
      path: '/profile',
      pageBuilder: (context) => PageFake(Colors.yellow),
    ),
    BartMenuRoute.bottomBar(
      label: "Counter",
      icon: Icons.countertops,
      path: '/counter',
      pageBuilder: (context) => PageFakeCounter(showAppBar: true),
    ),
    BartMenuRoute.innerRoute(
      path: '/subpage',
      pageBuilder: (context) =>
          PageFake(Colors.greenAccent, child: Text("Sub Route page")),
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
