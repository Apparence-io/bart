import 'package:bart/bart/bart_model.dart';
import 'package:bart/bart/bart_scaffold.dart';
import 'package:bart/bart/widgets/bottom_bar/bottom_bar.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

/// Regression tests for the material_ui migration (2.0.0).
///
/// Before 2.0.0, bart built the Flutter SDK's `Scaffold`, which provides the
/// SDK's `Material`. `debugCheckHasMaterial` resolves its ancestor with
/// `findAncestorWidgetOfExactType<Material>`, an exact-type match, so a
/// material_ui `InkWell` mounted inside a bart tab could not see it and threw
/// "No Material widget found." — even though a `Material` was plainly present.
///
/// Same story one layer down for `CupertinoTabBar`, which needs the
/// `CupertinoLocalizations` of whichever cupertino library declares it.
void main() {
  Widget tabApp({required Widget tabBody, required BartBottomBar bottomBar}) {
    return MaterialApp(
      home: BartScaffold(
        routesBuilder: () => [
          BartMenuRoute.bottomBar(
            label: 'Home',
            icon: Icons.home,
            path: '/home',
            pageBuilder: (context, tabContext, settings) => tabBody,
          ),
          BartMenuRoute.bottomBar(
            label: 'Library',
            icon: Icons.video_library_rounded,
            path: '/library',
            pageBuilder: (context, tabContext, settings) =>
                const SizedBox.shrink(),
          ),
        ],
        bottomBar: bottomBar,
      ),
    );
  }

  testWidgets(
    'material_ui InkWell inside a bart tab => finds a material_ui Material ancestor',
    (tester) async {
      await tester.pumpWidget(
        tabApp(
          tabBody: InkWell(
            key: const ValueKey('ink'),
            onTap: () {},
            child: const SizedBox(width: 80, height: 80),
          ),
          bottomBar: BartBottomBar.material3(),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.byKey(const ValueKey('ink')), findsOneWidget);
    },
  );

  testWidgets(
    'material_ui Ink inside a bart tab => resolves Material.of during build',
    (tester) async {
      await tester.pumpWidget(
        tabApp(
          tabBody: Ink(
            key: const ValueKey('inkDecoration'),
            decoration: const BoxDecoration(color: Color(0xFF112233)),
            width: 80,
            height: 80,
          ),
          bottomBar: BartBottomBar.material3(),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.byKey(const ValueKey('inkDecoration')), findsOneWidget);
    },
  );

  testWidgets(
    'material_ui ListTile inside a bart tab => no Material assertion',
    (tester) async {
      await tester.pumpWidget(
        tabApp(
          tabBody: const ListTile(
            key: ValueKey('tile'),
            title: Text('tile'),
          ),
          bottomBar: BartBottomBar.material3(),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.byKey(const ValueKey('tile')), findsOneWidget);
    },
  );

  testWidgets(
    'cupertino bottom bar under a material_ui root => finds CupertinoLocalizations',
    (tester) async {
      await tester.pumpWidget(
        tabApp(
          tabBody: const SizedBox.shrink(),
          bottomBar: BartBottomBar.cupertino(),
        ),
      );

      expect(tester.takeException(), isNull);
    },
  );
}
