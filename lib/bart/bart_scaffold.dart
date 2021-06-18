import 'package:bart/bart/bart_appbar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'animated_appbar.dart';
import 'bottom_bar.dart';
import 'router_delegate.dart';

class BartScaffold extends StatelessWidget {
  final BartBottomBar bottomBar;
  final BartRouteBuilder routesBuilder;
  final String? initialRoute;
  final List<NavigatorObserver>? navigatorObservers;
  // appBar
  final ValueNotifier<PreferredSizeWidget?> appBarNotifier;
  final ValueNotifier<bool> showAppBarNotifier;
  // scaffold items
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final FloatingActionButtonAnimator? floatingActionButtonAnimator;
  final List<Widget>? persistentFooterButtons;
  final Widget? drawer;
  final DrawerCallback? onDrawerChanged;
  final Widget? endDrawer;
  final DrawerCallback? onEndDrawerChanged;
  final Widget? bottomSheet;
  final Color? backgroundColor;
  final bool? resizeToAvoidBottomInset;
  final bool? primary;
  final DragStartBehavior? drawerDragStartBehavior;
  final bool? extendBody;
  final Color? drawerScrimColor;
  final double? drawerEdgeDragWidth;
  final bool? drawerEnableOpenDragGesture;
  final bool? endDrawerEnableOpenDragGesture;
  final String? restorationId;

  BartScaffold({
    Key? key,
    required this.bottomBar,
    required this.routesBuilder,
    this.initialRoute,
    this.navigatorObservers,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.floatingActionButtonAnimator,
    this.persistentFooterButtons,
    this.drawer,
    this.onDrawerChanged,
    this.endDrawer,
    this.onEndDrawerChanged,
    this.bottomSheet,
    this.backgroundColor,
    this.resizeToAvoidBottomInset,
    this.primary,
    this.drawerDragStartBehavior,
    this.extendBody,
    this.drawerScrimColor,
    this.drawerEdgeDragWidth,
    this.drawerEnableOpenDragGesture,
    this.endDrawerEnableOpenDragGesture,
    this.restorationId,
  })  : appBarNotifier = ValueNotifier(null),
        showAppBarNotifier = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return MenuRouter(
      routesBuilder: routesBuilder,
      initialRoute: initialRoute,
      navigatorObservers: navigatorObservers,
      child: Actions(
        actions: <Type, Action<Intent>>{
          AppBarBuildIntent: BartAppbarAction(appBarNotifier),
          AppBarAnimationIntent: BartAnimatedAppbarAction(showAppBarNotifier)
        },
        child: AnimatedBuilder(
          animation: appBarNotifier,
          builder: (ctx, child) => Scaffold(
            key: key,
            appBar: AnimatedAppBar(
              appBar: appBarNotifier.value,
              showStateNotifier: showAppBarNotifier,
            ),
            floatingActionButton: floatingActionButton,
            floatingActionButtonLocation: floatingActionButtonLocation,
            floatingActionButtonAnimator: floatingActionButtonAnimator,
            persistentFooterButtons: persistentFooterButtons,
            drawer: drawer,
            onDrawerChanged: onDrawerChanged,
            endDrawer: endDrawer,
            onEndDrawerChanged: onEndDrawerChanged,
            bottomSheet: bottomSheet,
            backgroundColor: backgroundColor,
            resizeToAvoidBottomInset: resizeToAvoidBottomInset,
            primary: primary ?? true,
            drawerDragStartBehavior:
                drawerDragStartBehavior ?? DragStartBehavior.start,
            extendBody: extendBody ?? false,
            extendBodyBehindAppBar: true,
            drawerScrimColor: drawerScrimColor,
            drawerEdgeDragWidth: drawerEdgeDragWidth,
            drawerEnableOpenDragGesture: drawerEnableOpenDragGesture ?? true,
            endDrawerEnableOpenDragGesture:
                endDrawerEnableOpenDragGesture ?? true,
            restorationId: restorationId,
            body: Router(
              routerDelegate: MenuRouter.of(ctx).routerDelegate,
            ),
            bottomNavigationBar: bottomBar,
          ),
          // ),
        ),
      ),
    );
  }
}
