import 'package:bart/bart.dart';
import 'package:example/tabs/page_counter.dart';
import 'package:example/tabs/fake_list.dart';
import 'package:flutter/material.dart';
import 'tabs/home_page.dart';
import 'route_observer.dart';
import 'package:animations/animations.dart';

import 'tabs/fake_page.dart';

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
      pageBuilder: (context, settings) => const HomePage(),
      transitionDuration: bottomBarTransitionDuration,
      transitionsBuilder: bottomBarTransition,
    ),
    BartMenuRoute.bottomBar(
      label: "Library",
      icon: Icons.video_library_rounded,
      path: '/library',
      pageBuilder: (context, settings) => const FakeListPage(
        key: PageStorageKey<String>("library"),
      ),
      transitionDuration: bottomBarTransitionDuration,
      transitionsBuilder: bottomBarTransition,
    ),
    BartMenuRoute.bottomBar(
      label: "Profile",
      icon: Icons.person,
      path: '/profile',
      pageBuilder: (contextn, settings) => const PageFake(
        Colors.yellow,
        key: PageStorageKey<String>("profile"),
      ),
      transitionDuration: bottomBarTransitionDuration,
      transitionsBuilder: bottomBarTransition,
    ),
    BartMenuRoute.bottomBar(
      label: "Counter",
      icon: Icons.countertops,
      path: '/counter',
      pageBuilder: (context, settings) => PageFakeCounter(showAppBar: true),
      transitionDuration: bottomBarTransitionDuration,
      transitionsBuilder: bottomBarTransition,
    ),
    BartMenuRoute.innerRoute(
      path: '/subpage',
      pageBuilder: (context, settings) => const PageFake(
        Colors.greenAccent,
        showAppbar: true,
        child: Text("Sub Route page"),
      ),
    ),
  ];
}

Widget bottomBarTransition(
  BuildContext c,
  Animation<double> a1,
  Animation<double> a2,
  Widget child,
) =>
    FadeThroughTransition(
      animation: a1,
      secondaryAnimation: a2,
      fillColor: Colors.white,
      child: child,
    );

const bottomBarTransitionDuration = Duration(milliseconds: 500);
