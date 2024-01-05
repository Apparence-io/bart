import 'package:animations/animations.dart';
import 'package:bart/bart.dart';
import 'package:example/tabs/fake_list.dart';
import 'package:example/tabs/page_counter.dart';
import 'package:flutter/material.dart';

import 'tabs/home_page.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future appPushNamed(String route, {Object? arguments}) =>
    navigatorKey.currentState!.pushNamed(route, arguments: arguments);

List<BartMenuRoute> subRoutes() {
  return [
    BartMenuRoute.bottomBar(
      label: "Home",
      icon: Icons.home_outlined,
      selectedIcon: Icons.home,
      path: '/home',
      pageBuilder: (parentContext, tabContext, settings) => HomePage(
        key: const PageStorageKey<String>("home"),
        parentContext: parentContext,
      ),
      transitionDuration: bottomBarTransitionDuration,
      transitionsBuilder: bottomBarTransition,
      cache: false,
    ),
    BartMenuRoute.bottomBarBuilder(
      label: "Library",
      builder: (context, isActive) {
        return BottomBarIcon.builder(
          icon: Icon(
            Icons.notifications,
            color: isActive ? Colors.blue : Colors.grey,
          ),
          top: -4.0,
          right: 0.0,
          notificationBuilder: (context) => Container(
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(4),
            child: const Text(
              "1",
              style: TextStyle(color: Colors.white, fontSize: 10),
            ),
          ),
        );
      },
      path: '/library',
      pageBuilder: (parentContext, tabContext, settings) => const FakeListPage(
        key: PageStorageKey<String>("library"),
      ),
      transitionDuration: bottomBarTransitionDuration,
      transitionsBuilder: bottomBarTransition,
    ),
    BartMenuRoute.bottomBar(
      label: "Profile",
      icon: Icons.person_outline,
      selectedIcon: Icons.person,
      path: '/profile',
      pageBuilder: (parentContext, tabContext, settings) => Container(
          key: const PageStorageKey<String>("profile"),
          child: const Center(child: Text('Profile page'))),
      transitionDuration: bottomBarTransitionDuration,
      transitionsBuilder: bottomBarTransition,
    ),
    BartMenuRoute.bottomBar(
      label: "Counter",
      icon: Icons.countertops,
      path: '/counter',
      pageBuilder: (parentContext, tabContext, settings) => PageFakeCounter(
        key: const PageStorageKey<String>("counter"),
        showAppBar: true,
      ),
      transitionDuration: bottomBarTransitionDuration,
      transitionsBuilder: bottomBarTransition,
    ),
    BartMenuRoute.innerRoute(
      path: '/home/inner',
      pageBuilder: (parentContext, tabContext, settings) =>
          const Center(child: Text("Sub Route page")),
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

const bottomBarTransitionDuration = Duration(milliseconds: 300);
