import 'package:bart/bart/bart_model.dart';
import 'package:bart/bart/bart_page.dart';
import 'package:bart/bart/bart_scaffold.dart';
import 'package:bart/bart/bottom_bar.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bart/bart.dart';
import 'package:flutter/material.dart';

import 'page_fake.dart';

void main() {
  group('Bart testing', () {
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
    ];

    _createApp({String? initialRoute}) {
      Route<dynamic> routes(RouteSettings settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(
              settings: settings,
              builder: (context) => BartScaffold(
                bottomBar: BartBottomBar.fromFactory(
                  initialRoute: initialRoute,
                  bottomBarFactory: BartMaterialBottomBar.bottomBarFactory,
                  routes: homeSubRoutes,
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

    testWidgets('create app with bart bottom bar containing 3 tabs', (WidgetTester tester) async {
      await tester.pumpWidget(_createApp(initialRoute: "/home"));
      await tester.pump();
      expect(find.byType(BartScaffold), findsOneWidget);
      expect(find.byType(BottomNavigationBar), findsOneWidget);
      expect(find.byType(InkResponse), findsNWidgets(3));
    });

    testWidgets('default tab is the first one', (WidgetTester tester) async {
      await tester.pumpWidget(_createApp());
      var currentPage = find.byType(PageFake).evaluate().first.widget as PageFake;
      expect(currentPage.bgColor, Colors.red);
    });

    testWidgets('default tab is the second one', (WidgetTester tester) async {
      await tester.pumpWidget(_createApp(initialRoute: "/library"));
      var currentPage = find.byType(PageFake).evaluate().first.widget as PageFake;
      expect(currentPage.bgColor, Colors.blueGrey);
    });

    testWidgets('bar is on tab 1, click on tab 2 => tab 2 page is visible', (WidgetTester tester) async {
      await tester.pumpWidget(_createApp(initialRoute: "/home"));
      await tester.pump();
      expect(find.byType(PageFake), findsNWidgets(1));
      var item2 = find.byType(InkResponse).at(1).evaluate().first.widget as InkResponse;
      item2.onTap!();
      await tester.pump(Duration(seconds: 1));
      var page = find.byType(PageFake).evaluate().last.widget as PageFake;
      expect(find.byType(PageFake), findsNWidgets(2));
      expect(page.bgColor, Colors.blueGrey);
    });
  });
}
