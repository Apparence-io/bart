import 'package:bart/bart/widgets/animated_appbar.dart';
import 'package:bart/bart/bart_appbar.dart';
import 'package:bart/bart/bart_model.dart';
import 'package:bart/bart/widgets/bottom_bar/bottom_bar.dart';
import 'package:bart/bart/widgets/nested_navigator.dart';
import 'package:bart/bart/router_delegate.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class BartScaffold extends StatefulWidget {
  final BartBottomBar bottomBar;
  final BartRouteBuilder routesBuilder;
  final String? initialRoute;
  // appBar
  final ValueNotifier<PreferredSizeWidget?> appBarNotifier;
  final ValueNotifier<bool> showAppBarNotifier;
  final ScaffoldOptions? scaffoldOptions;

  BartScaffold({
    Key? key,
    required this.bottomBar,
    required this.routesBuilder,
    this.initialRoute,
    this.scaffoldOptions,
  })  : appBarNotifier = ValueNotifier(null),
        showAppBarNotifier = ValueNotifier(false),
        super(key: key);

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
      child: Actions(
        actions: <Type, Action<Intent>>{
          AppBarBuildIntent: BartAppBarAction(widget.appBarNotifier),
          AppBarAnimationIntent:
              BartAnimatedAppBarAction(widget.showAppBarNotifier),
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
                bottomNavigationBar: widget.bottomBar,
                bottomSheet: widget.scaffoldOptions?.bottomSheet,
                extendBodyBehindAppBar: true, // TODO: use user preference
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
