import 'package:bart/bart/bart_model.dart';
import 'package:bart/bart/bart_scaffold.dart';
import 'package:bart/bart/bottom_bar.dart';
import 'package:bart/bart/bart_appbar.dart';
import 'package:flutter/material.dart';
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
      pageBuilder: (context) => PageFake(
        Colors.red,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              key: ValueKey("subpageBtn"),
              child: Text(
                "Route to page 2",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () => Navigator.of(context).pushNamed("/subpage"),
            ),
            TextButton(
              key: ValueKey("subpageBtn2"),
              child: Text(
                "add app bar",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () => Actions.invoke(
                  context,
                  AppBarBuildIntent(AppBar(
                    title: Text("title text"),
                  ))),
            ),
          ],
        ),
      ),
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
