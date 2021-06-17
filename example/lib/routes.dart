import 'package:bart/bart/bart_model.dart';
import 'package:bart/bart/bart_scaffold.dart';
import 'package:bart/bart/bottom_bar.dart';
import 'package:flutter/material.dart';
import 'route_observer.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final CustomNavigatorObserver<PageRoute> routeObserver = CustomNavigatorObserver<PageRoute>();

Future appPushNamed(String route, {Object? arguments}) => navigatorKey.currentState!.pushNamed(route, arguments: arguments);

var homeSubRoutes = [
  BartMenuRoute.bottomBar(
    label: "Home",
    icon: Icons.home,
    path: '/home',
    pageBuilder: (context) => PageFake(Colors.red),
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
  BartMenuRoute.innerRoute(
    path: '/home/test',
    pageBuilder: (context) => PageFake(Colors.greenAccent, child: Text("Sub Route page")),
  ),
];

Route<dynamic> routes(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return MaterialPageRoute(builder: (_) => MainPageMenu(routes: homeSubRoutes));
    default:
      throw 'unexpected Route';
  }
}

class MainPageMenu extends StatelessWidget {
  final List<BartMenuRoute> routes;

  const MainPageMenu({Key? key, required this.routes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BartScaffold(
      bottomBar: BartBottomBar.fromFactory(
        bottomBarFactory: BartMaterialBottomBar.bottomBarFactory,
        navigatorObservers: [routeObserver],
        routes: homeSubRoutes,
      ),
    );
  }
}

class PageFake extends StatelessWidget {
  final Color bgColor;
  final Widget? child;

  PageFake(this.bgColor, {this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: bgColor,
      child: Center(child: child),
    );
  }
}
