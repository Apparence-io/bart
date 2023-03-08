import 'package:bart/bart/bart_model.dart';
import 'package:bart/bart/router_delegate.dart';
import 'package:bart/bart/widgets/bottom_bar/styles/bottom_bar_cupertino.dart';
import 'package:bart/bart/widgets/bottom_bar/styles/bottom_bar_material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:universal_io/io.dart';

typedef BottomBarTapAction = void Function(int index);

typedef BartRouteBuilder = List<BartMenuRoute> Function();

enum Theme { material, cupertino, custom }

class BartBottomBar extends StatefulWidget {
  final int currentIndex;
  final Theme theme;
  final BartBottomBarTheme? bottomBarTheme;
  final bool enableHapticFeedback;

  const BartBottomBar._({
    this.enableHapticFeedback = true,
    this.bottomBarTheme,
    required this.theme,
    required this.currentIndex,
  });

  @Deprecated('Use BartBottomBar.material3() instead')
  factory BartBottomBar.material({
    BartBottomBarTheme? bottomBarTheme,
    bool enableHapticFeedback = true,
    int index = 0,
  }) =>
      BartBottomBar._(
        enableHapticFeedback: enableHapticFeedback,
        bottomBarTheme: bottomBarTheme ?? BartBottomBarTheme.material2(),
        theme: Theme.material,
        currentIndex: index,
      );

  factory BartBottomBar.cupertino({
    BartBottomBarTheme? bottomBarTheme,
    bool enableHapticFeedback = true,
    int index = 0,
  }) =>
      BartBottomBar._(
        bottomBarTheme: bottomBarTheme ?? BartBottomBarTheme.cupertino(),
        enableHapticFeedback: enableHapticFeedback,
        theme: Theme.cupertino,
        currentIndex: index,
      );

  factory BartBottomBar.adaptive({
    BartBottomBarTheme? materialBottomBarTheme,
    BartBottomBarTheme? cupertinoBottomBarTheme,
    bool enableHapticFeedback = true,
    int index = 0,
  }) =>
      BartBottomBar._(
        bottomBarTheme: Platform.isIOS
            ? cupertinoBottomBarTheme ?? BartBottomBarTheme.cupertino()
            : materialBottomBarTheme ?? BartBottomBarTheme.material2(),
        enableHapticFeedback: enableHapticFeedback,
        theme: Platform.isIOS ? Theme.cupertino : Theme.material,
        currentIndex: index,
      );

  @override
  BartBottomBarState createState() => BartBottomBarState();
}

@visibleForTesting
class BartBottomBarState extends State<BartBottomBar> {
  List<BartMenuRoute> get routes => MenuRouter.of(context).routesBuilder();
  ValueNotifier<int> get currentIndexNotifier =>
      MenuRouter.of(context).indexNotifier;
  ValueNotifier<BartMenuRouteType> get currentRoutingTypeNotifier =>
      MenuRouter.of(context).routingTypeNotifier;

  void onTap(int index) {
    if (currentIndexNotifier.value == index &&
        currentRoutingTypeNotifier.value ==
            BartMenuRouteType.bottomNavigation) {
      return;
    }

    if (widget.enableHapticFeedback) {
      HapticFeedback.selectionClick();
    }
    final nestedContext = MenuRouter.of(context).navigationKey.currentContext;
    if (nestedContext != null) {
      Navigator.of(nestedContext).pushReplacementNamed(routes[index].path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: currentIndexNotifier,
      builder: ((context, int index, child) {
        Widget bottomBar;
        switch (widget.theme) {
          case Theme.cupertino:
            bottomBar = BartCupertinoBottomBar(
              routes: routes,
              theme: widget.bottomBarTheme!,
              currentIndex: index,
              onTap: onTap,
            );
            break;
          case Theme.material:
            bottomBar = BartMaterialBottomBar(
              routes: routes,
              theme: widget.bottomBarTheme!,
              currentIndex: index,
              onTap: onTap,
            );
            break;
          default:
            // TODO: create a custom bottom bar
            bottomBar = BartMaterialBottomBar(
              routes: routes,
              theme: widget.bottomBarTheme!,
              currentIndex: index,
              onTap: onTap,
            );
        }
        return bottomBar;
      }),
    );
  }
}
