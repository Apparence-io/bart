import 'package:bart/bart/bart_model.dart';
import 'package:bart/bart/bart_page.dart';
import 'package:flutter/material.dart';
import 'route_observer.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final CustomNavigatorObserver<PageRoute> routeObserver = CustomNavigatorObserver<PageRoute>();

Future appPushNamed(String route, {Object arguments}) => navigatorKey.currentState.pushNamed(route, arguments: arguments);

Route<dynamic> routes(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return MaterialPageRoute(
        settings: settings,
        builder: (context)
          => Bart(
            navigatorObservers: [routeObserver],
            routes: [
              BartMenuRoute(
                label: "Home", icon: Icons.home, path: '/home',
                pageBuilder: (context) => PageFake(Colors.red),
                settings: RouteSettings(name: '/home')),
              BartMenuRoute(
                label: "Library", icon: Icons.video_library_rounded, path: '/library',
                pageBuilder: (context) => PageFake(Colors.blueGrey),
                settings: RouteSettings(name: '/profile')),
              BartMenuRoute(
                label: "Profile", icon: Icons.person, path: '/profile',
                pageBuilder: (context) => PageFake(Colors.blue),
                settings: RouteSettings(name: '/profile')),
            ],
          ),
        maintainState: true,
      );
    default:
      throw 'unexpected Route';
  }
}


class PageFake extends StatelessWidget {

  final Color bgColor;

  PageFake(this.bgColor);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: bgColor,
    );
  }
}