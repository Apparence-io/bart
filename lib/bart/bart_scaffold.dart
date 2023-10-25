import 'package:bart/bart/bart_appbar.dart';
import 'package:bart/bart/bart_bottombar_actions.dart';
import 'package:bart/bart/bart_model.dart';
import 'package:bart/bart/router_delegate.dart';
import 'package:bart/bart/widgets/animated_appbar.dart';
import 'package:bart/bart/widgets/bottom_bar/bottom_bar.dart';
import 'package:bart/bart/widgets/nested_navigator.dart';
import 'package:bart/bart/widgets/side_bar/sidebar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class BartScaffold extends StatefulWidget {
  final BartBottomBar bottomBar;
  final BartRouteBuilder routesBuilder;
  final String? initialRoute;

  /// Called when the current route changes
  final OnRouteChanged? onRouteChanged;
  // appBar
  final ValueNotifier<PreferredSizeWidget?> appBarNotifier;
  final ValueNotifier<bool> showAppBarNotifier;
  final ValueNotifier<bool> showBottomBarNotifier;

  /// See all [Scaffold] options
  final ScaffoldOptions? scaffoldOptions;

  /// one of [CustomSideBarOptions] or [RailSideBarOptions]
  final SideBarOptions? sideBarOptions;

  BartScaffold({
    super.key,
    required this.bottomBar,
    required this.routesBuilder,
    this.sideBarOptions,
    this.initialRoute,
    this.scaffoldOptions,
    this.onRouteChanged,
    bool showBottomBarOnStart = true,
  })  : appBarNotifier = ValueNotifier(null),
        showAppBarNotifier = ValueNotifier(false),
        showBottomBarNotifier = ValueNotifier(showBottomBarOnStart);

  @override
  State<BartScaffold> createState() => _BartScaffoldState();
}

class _BartScaffoldState extends State<BartScaffold>
    with SingleTickerProviderStateMixin {
  final GlobalKey<NavigatorState> navigationKey = GlobalKey<NavigatorState>();
  final indexNotifier = ValueNotifier(0);
  final routingTypeNotifier = ValueNotifier(BartMenuRouteType.bottomNavigation);

  List<BartMenuRoute> get routesBuilder => widget.routesBuilder();
  int get initialIndex {
    final index = routesBuilder
        .indexWhere((element) => element.path == widget.initialRoute);
    return index == -1 ? 0 : index;
  }

  final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

  @override
  Widget build(BuildContext context) {
    return MenuRouter(
      indexNotifier: indexNotifier,
      routesBuilder: widget.routesBuilder,
      navigationKey: navigationKey,
      routingTypeNotifier: routingTypeNotifier,
      onRouteChanged: widget.onRouteChanged,
      child: Actions(
        actions: <Type, Action<Intent>>{
          AppBarBuildIntent: BartAppBarAction(widget.appBarNotifier),
          AppBarAnimationIntent:
              BartAnimatedAppBarAction(widget.showAppBarNotifier),
          BottomBarIntent: BottomBarAction(widget.showBottomBarNotifier),
        },
        child: AnimatedBuilder(
            animation: widget.appBarNotifier,
            builder: (context, child) {
              return Scaffold(
                appBar: AnimatedAppBar(
                  appBar: widget.appBarNotifier.value,
                  showStateNotifier: widget.showAppBarNotifier,
                ),
                backgroundColor: widget.scaffoldOptions?.backgroundColor,
                floatingActionButton:
                    widget.scaffoldOptions?.floatingActionButton,
                floatingActionButtonLocation:
                    widget.scaffoldOptions?.floatingActionButtonLocation,
                floatingActionButtonAnimator:
                    widget.scaffoldOptions?.floatingActionButtonAnimator,
                persistentFooterButtons:
                    widget.scaffoldOptions?.persistentFooterButtons,
                drawer: widget.scaffoldOptions?.drawer,
                onDrawerChanged: widget.scaffoldOptions?.onDrawerChanged,
                endDrawer: widget.scaffoldOptions?.endDrawer,
                onEndDrawerChanged: widget.scaffoldOptions?.onEndDrawerChanged,
                // 👾 bottom bar
                bottomNavigationBar: widget.sideBarOptions == null
                    ? AnimatedBottomBar(
                        bottomBar: widget.bottomBar,
                        showStateNotifier: widget.showBottomBarNotifier,
                      )
                    : null,
                // ----------------
                bottomSheet: widget.scaffoldOptions?.bottomSheet,
                extendBodyBehindAppBar:
                    widget.scaffoldOptions?.extendBodyBehindAppBar ?? true,
                drawerEdgeDragWidth:
                    widget.scaffoldOptions?.drawerEdgeDragWidth,
                drawerScrimColor: widget.scaffoldOptions?.drawerScrimColor,
                drawerDragStartBehavior:
                    widget.scaffoldOptions?.drawerDragStartBehavior ??
                        DragStartBehavior.start,
                primary: widget.scaffoldOptions?.primary ?? true,
                drawerEnableOpenDragGesture:
                    widget.scaffoldOptions?.drawerEnableOpenDragGesture ?? true,
                endDrawerEnableOpenDragGesture:
                    widget.scaffoldOptions?.endDrawerEnableOpenDragGesture ??
                        true,
                extendBody: widget.scaffoldOptions?.extendBody ?? false,
                resizeToAvoidBottomInset:
                    widget.scaffoldOptions?.resizeToAvoidBottomInset,
                restorationId: widget.scaffoldOptions?.restorationId,
                key: widget.scaffoldOptions?.key,
                body: NestedNavigator(
                  navigationKey: navigationKey,
                  routes: routesBuilder,
                  initialRoute: widget.initialRoute,
                  navigatorObserver: routeObserver,
                  appBarNotifier: widget.appBarNotifier,
                  showAppBarNotifier: widget.showAppBarNotifier,
                  parentContext: context,
                  sideBarOptions: widget.sideBarOptions,
                ),
              );
            }),
      ),
    );
  }
}

/// Use this intent to change the current index
class BottomBarIndexIntent extends Intent {
  final int index;

  const BottomBarIndexIntent(this.index);
}
