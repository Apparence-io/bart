import 'package:bart/bart/bart_appbar.dart';
import 'package:bart/bart/bart_model.dart';
import 'package:bart/bart/bart_scaffold.dart';
import 'package:bart/bart/widgets/animated_appbar.dart';
import 'package:bart/bart/widgets/bottom_bar/bottom_bar.dart';
import 'package:bart/bart/widgets/bottom_bar/styles/bottom_bar_material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'components/custom_bottom_bar.dart';
import 'components/page_counter.dart';
import 'components/page_fake.dart';

void main() {
  group('Bart navigation with 3 items + subroutes', () {
    List<BartMenuRoute> homeSubRoutes() {
      return [
        BartMenuRoute.bottomBar(
          label: "Home",
          icon: Icons.home,
          path: '/home',
          pageBuilder: (context, tabContext, settings) => PageFake(
            Colors.red,
            key: const ValueKey("page1"),
            child: Column(
              children: [
                TextButton(
                  key: const ValueKey("subpageBtn"),
                  child: const Text(
                    "Route to page 2",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () =>
                      Navigator.of(tabContext).pushNamed("/subpage"),
                ),
                TextButton(
                  key: const ValueKey("goToLibraryButton"),
                  child: const Text(
                    "Go to library",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () =>
                      Navigator.of(tabContext).pushNamed("/library"),
                ),
              ],
            ),
          ),
        ),
        BartMenuRoute.bottomBar(
          label: "Library",
          icon: Icons.video_library_rounded,
          path: '/library',
          pageBuilder: (context, tabContext, settings) => PageFake(
            Colors.blueGrey,
            child: TextButton(
              key: const ValueKey("addAppBarBtn"),
              child: const Text(
                "add app bar",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Actions.invoke(
                    tabContext,
                    AppBarBuildIntent(AppBar(
                      title: const Text("title text"),
                    )));
                Actions.invoke(tabContext, AppBarAnimationIntent.show());
              },
            ),
          ),
        ),
        BartMenuRoute.bottomBar(
          label: "Profile",
          icon: Icons.person,
          path: '/profile',
          pageBuilder: (context, tabContext, settings) =>
              const PageFake(Colors.yellow),
        ),
        BartMenuRoute.innerRoute(
          path: '/subpage',
          pageBuilder: (context, tabContext, settings) =>
              const PageFake(Colors.greenAccent, child: Text("Sub Route page")),
        ),
      ];
    }

    createM3App({String? initialRoute}) {
      Route<dynamic> routes(RouteSettings settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(
              settings: settings,
              builder: (context) => BartScaffold(
                routesBuilder: homeSubRoutes,
                initialRoute: initialRoute,
                bottomBar: BartBottomBar.material3(),
              ),
              maintainState: true,
            );
          default:
            throw 'unexpected Route';
        }
      }

      return MaterialApp(
        title: 'Flutter Demo',
        onGenerateRoute: routes,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
      );
    }

    createMaterialApp({String? initialRoute}) {
      Route<dynamic> routes(RouteSettings settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(
              settings: settings,
              builder: (context) => BartScaffold(
                routesBuilder: homeSubRoutes,
                initialRoute: initialRoute,
                bottomBar: BartBottomBar.material(),
              ),
              maintainState: true,
            );
          default:
            throw 'unexpected Route';
        }
      }

      return MaterialApp(
        title: 'Flutter Demo',
        onGenerateRoute: routes,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
      );
    }

    createAppCupertino({String? initialRoute}) {
      Route<dynamic> routes(RouteSettings settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(
              settings: settings,
              builder: (context) => BartScaffold(
                routesBuilder: homeSubRoutes,
                initialRoute: initialRoute,
                bottomBar: BartBottomBar.cupertino(),
              ),
              maintainState: true,
            );
          default:
            throw 'unexpected Route';
        }
      }

      return MaterialApp(
        title: 'Flutter Demo',
        onGenerateRoute: routes,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
      );
    }

    createAppCustom({String? initialRoute}) {
      Route<dynamic> routes(RouteSettings settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(
              settings: settings,
              builder: (context) => BartScaffold(
                routesBuilder: homeSubRoutes,
                initialRoute: initialRoute,
                bottomBar: BartBottomBar.custom(
                  bottomBarCustom: CustomBottomBar(),
                ),
              ),
              maintainState: true,
            );
          default:
            throw 'unexpected Route';
        }
      }

      return MaterialApp(
        title: 'Flutter Demo',
        onGenerateRoute: routes,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
      );
    }

    testWidgets('create app with bart bottom bar containing 3 tabs',
        (WidgetTester tester) async {
      await tester.pumpWidget(createMaterialApp(initialRoute: "/home"));
      await tester.pump();
      expect(find.byType(BartScaffold), findsOneWidget);
      expect(find.byType(BottomNavigationBar), findsOneWidget);
      expect(find.byType(InkResponse), findsNWidgets(3));
    });
    testWidgets('page has no app bar, click on add appbar => an appbar exists',
        (WidgetTester tester) async {
      await tester.pumpWidget(createMaterialApp(initialRoute: "/library"));
      await tester.pump();
      expect(find.byType(AppBar), findsNothing);
      var btnFinder = find.byKey(const ValueKey("addAppBarBtn"));
      expect(btnFinder, findsOneWidget);
      await tester.tap(btnFinder);
      // an app bar is visible
      await tester.pump(const Duration(seconds: 1));
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('click on add appbar, route to next page => appBar is reset',
        (WidgetTester tester) async {
      await tester.pumpWidget(createMaterialApp(initialRoute: "/library"));
      await tester.pump();
      var appBar =
          find.byType(AnimatedAppBar).evaluate().first.widget as AnimatedAppBar;
      var btnFinder = find.byKey(const ValueKey("addAppBarBtn"));
      expect(btnFinder, findsOneWidget);
      await tester.tap(btnFinder);
      // an app bar is visible
      await tester.pump(const Duration(seconds: 1));
      expect(find.byType(AppBar), findsOneWidget);
      expect(appBar.showStateNotifier.value, isTrue);
      // route to second page, appbar is reset by defaultIcon
      var item2 =
          find.byType(InkResponse).at(2).evaluate().first.widget as InkResponse;
      item2.onTap!();
      await tester.pump(const Duration(seconds: 1));
      expect(appBar.showStateNotifier.value, isFalse);
    });

    testWidgets('default tab is the first one', (WidgetTester tester) async {
      await tester.pumpWidget(createMaterialApp());
      var currentPage =
          find.byType(PageFake).evaluate().first.widget as PageFake;
      expect(currentPage.bgColor, Colors.red);
    });

    testWidgets('should create cupertino bottom bar',
        (WidgetTester tester) async {
      await tester.pumpWidget(createAppCupertino(initialRoute: "/library"));
      var currentPage =
          find.byType(PageFake).evaluate().first.widget as PageFake;
      expect(currentPage.bgColor, Colors.blueGrey);
    });

    testWidgets('Create custom bottom bar with 3 tabs',
        (WidgetTester tester) async {
      await tester.pumpWidget(createAppCustom(initialRoute: "/home"));
      expect(find.byType(BartScaffold), findsOneWidget);
      expect(find.byKey(const ValueKey('CustomBottomBar')), findsOneWidget);
      expect(find.byKey(const ValueKey('BottomBarItem1')), findsOneWidget);
      expect(find.byKey(const ValueKey('BottomBarItem2')), findsOneWidget);
      expect(find.byKey(const ValueKey('BottomBarItem3')), findsOneWidget);
      expect(find.byKey(const ValueKey('BottomBarItem4')), findsNothing);
      // default tab should be the first one
      var currentPage =
          find.byType(PageFake).evaluate().first.widget as PageFake;
      expect(currentPage.bgColor, Colors.red);
    });
    testWidgets('create app with material 3 bart bottom bar containing 3 tabs',
        (WidgetTester tester) async {
      await tester.pumpWidget(createM3App(initialRoute: "/home"));
      await tester.pump();
      expect(find.byType(BartScaffold), findsOneWidget);
      expect(find.byType(NavigationBar), findsOneWidget);
      expect(find.byType(Icon), findsNWidgets(3));
    });

    testWidgets('bar is on tab 1, click on tab 2 => tab 2 page is visible',
        (WidgetTester tester) async {
      await tester.pumpWidget(createMaterialApp(initialRoute: "/home"));
      await tester.pump();
      expect(find.byType(PageFake), findsNWidgets(1));
      await tester.tap(find.byType(Icon).at(1));
      await tester.pump(const Duration(seconds: 1));
      var page1 = find.byType(PageFake).evaluate().last.widget as PageFake;
      expect(find.byType(PageFake), findsNWidgets(2));
      expect(page1.bgColor, Colors.blueGrey);
    });

    testWidgets(
        'bar is on tab 1 (home), click on library page button 2 => tab 2 page is visible and tab 2 icon is selected',
        (WidgetTester tester) async {
      await tester.pumpWidget(createMaterialApp(initialRoute: "/home"));
      await tester.pump();

      BartBottomBar bottomBar =
          tester.firstWidget(find.byType(BartBottomBar)) as BartBottomBar;
      expect(bottomBar.currentIndex, equals(0));

      var libraryButton = find.byKey(const ValueKey('goToLibraryButton'));
      await tester.tap(libraryButton);
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('add app bar'), findsOneWidget);
      await tester.pumpAndSettle();

      expect(find.byType(BartBottomBar), findsOneWidget);
      final materialBottomBar =
          tester.firstWidget(find.byType(BartMaterialBottomBar))
              as BartMaterialBottomBar;
      expect(materialBottomBar.currentIndex, equals(1));
    });

    testWidgets(
        'push a page => page is visible on top of tab, bottom navigation is still visible',
        (WidgetTester tester) async {
      await tester.pumpWidget(createMaterialApp(initialRoute: "/home"));
      await tester.pump();
      var btnFinder = find.byKey(const ValueKey("subpageBtn"));
      expect(btnFinder, findsOneWidget);
      await tester.tap(btnFinder);
      // new page is visible
      await tester.pump(const Duration(seconds: 1));
      expect(find.text("Sub Route page"), findsOneWidget);
      expect(find.byType(BartScaffold), findsOneWidget);
      expect(find.byType(BartMaterialBottomBar), findsOneWidget);
      expect(find.byType(Icon), findsNWidgets(3));
    });
  });

  group('4 tabs, tab 1,3 are counters', () {
    List<BartMenuRoute> homeSubRoutes() {
      return [
        BartMenuRoute.bottomBar(
          label: "home",
          icon: Icons.person,
          path: '/home',
          pageBuilder: (context, tabContext, settings) =>
              PageFakeCounter(showAppBar: true),
        ),
        BartMenuRoute.bottomBar(
          label: "lib",
          icon: Icons.person,
          path: '/lib',
          pageBuilder: (context, tabContext, settings) =>
              const PageFake(Colors.yellow),
        ),
        BartMenuRoute.bottomBar(
          label: "Profile",
          icon: Icons.person,
          path: '/profile',
          cache: false,
          pageBuilder: (context, tabContext, settings) => PageFakeCounter(),
        ),
        BartMenuRoute.innerRoute(
          path: '/subpage',
          pageBuilder: (context, tabContext, settings) =>
              const PageFake(Colors.greenAccent, child: Text("Sub Route page")),
        ),
      ];
    }

    createApp({String? initialRoute}) {
      Route<dynamic> routes(RouteSettings settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(
              settings: settings,
              builder: (context) => BartScaffold(
                routesBuilder: homeSubRoutes,
                initialRoute: initialRoute,
                bottomBar: BartBottomBar.material(),
              ),
              maintainState: true,
            );
          default:
            throw 'unexpected Route';
        }
      }

      return MaterialApp(
        title: 'Flutter Demo',
        onGenerateRoute: routes,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
      );
    }

    testWidgets('''bar is on tab 1, shows appBar using mixin''',
        (WidgetTester tester) async {
      await tester.pumpWidget(createApp(initialRoute: "/home"));
      await tester.pump();

      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets(
        '''bar is on tab 1 with cache=true, click on button increment counter (counter 1 => 2), go tab 2 then tab 1
        => tab 1 is back with restored state (counter = 2)''',
        (WidgetTester tester) async {
      await tester.pumpWidget(createApp(initialRoute: "/home"));
      await tester.pump();
      // tap button to change counter
      expect(find.text("1"), findsOneWidget);
      await tester.tap(find.byKey(const ValueKey("addCountBtn")));
      await tester.pump();
      expect(find.text("2"), findsOneWidget);
      // go page 2
      var item1 =
          find.byType(InkResponse).at(1).evaluate().first.widget as InkResponse;
      item1.onTap!();
      await tester.pump(const Duration(seconds: 1));

      var page = find.byType(PageFake).evaluate().last.widget as PageFake;
      expect(page.bgColor, Colors.yellow);
      expect(find.byKey(const ValueKey("counter")), findsOneWidget);
      // go page 1
      var item0 =
          find.byType(InkResponse).at(0).evaluate().first.widget as InkResponse;
      item0.onTap!();
      await tester.pump(const Duration(seconds: 1));

      expect(find.byType(PageFakeCounter), findsOneWidget);
      expect(find.byKey(const ValueKey("counter")), findsOneWidget);
      var counter =
          find.byKey(const ValueKey("counter")).evaluate().first.widget as Text;
      expect(counter.data, "2");
    });

    testWidgets(
        '''bar is on tab 3 with cache=false, click on button increment counter (counter 1 => 2), go tab 2 then tab 3
        => tab 3 is back with initial state (counter = 1)''',
        (WidgetTester tester) async {
      await tester.pumpWidget(createApp(initialRoute: "/profile"));
      await tester.pump();
      // tap button to change counter
      expect(find.text("1"), findsOneWidget);
      await tester.tap(find.byKey(const ValueKey("addCountBtn")));
      await tester.pump();
      expect(find.text("2"), findsOneWidget);
      // go page 2
      var item1 =
          find.byType(InkResponse).at(1).evaluate().first.widget as InkResponse;
      item1.onTap!();
      await tester.pump(const Duration(seconds: 1));

      var page = find.byType(PageFake).evaluate().last.widget as PageFake;
      expect(page.bgColor, Colors.yellow);
      expect(find.byKey(const ValueKey("counter")), findsOneWidget);
      // go page 1
      var item0 =
          find.byType(InkResponse).at(0).evaluate().first.widget as InkResponse;
      item0.onTap!();
      await tester.pump(const Duration(seconds: 1));

      expect(find.byType(PageFakeCounter), findsOneWidget);
      expect(find.byKey(const ValueKey("counter")), findsOneWidget);
      var counter =
          find.byKey(const ValueKey("counter")).evaluate().first.widget as Text;
      expect(counter.data, "1");
    });
  });
}
