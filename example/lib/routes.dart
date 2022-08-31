import 'package:bart/bart.dart';
import 'package:example/tabs/page_counter.dart';
import 'package:example/tabs/fake_list.dart';
import 'package:flutter/material.dart';
import 'tabs/home_page.dart';
import 'package:animations/animations.dart';

import 'tabs/fake_page.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future appPushNamed(String route, {Object? arguments}) =>
    navigatorKey.currentState!.pushNamed(route, arguments: arguments);

List<BartMenuRoute> subRoutes() {
  return [
    BartMenuRoute.bottomBar(
      label: "Home",
      icon: Icons.home,
      path: '/home',
      pageBuilder: (parentContext, settings) => HomePage(
        parentContext: parentContext,
      ),
      transitionDuration: bottomBarTransitionDuration,
      transitionsBuilder: bottomBarTransition,
    ),
    BartMenuRoute.bottomBar(
      label: "Library",
      icon: Icons.video_library_rounded,
      path: '/library',
      pageBuilder: (parentContext, settings) => const FakeListPage(),
      transitionDuration: bottomBarTransitionDuration,
      transitionsBuilder: bottomBarTransition,
    ),
    BartMenuRoute.bottomBar(
      label: "Profile",
      icon: Icons.person,
      path: '/profile',
      pageBuilder: (parentContext, settings) => const PageFake(
        Colors.yellow,
      ),
      transitionDuration: bottomBarTransitionDuration,
      transitionsBuilder: bottomBarTransition,
    ),
    BartMenuRoute.bottomBar(
      label: "Counter",
      icon: Icons.countertops,
      path: '/counter',
      pageBuilder: (parentContext, settings) =>
          PageFakeCounter(showAppBar: true),
      transitionDuration: bottomBarTransitionDuration,
      transitionsBuilder: bottomBarTransition,
    ),
    BartMenuRoute.innerRoute(
      path: '/home/inner',
      pageBuilder: (parentContext, settings) => const PageFake(
        Colors.greenAccent,
        showAppBar: true,
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
