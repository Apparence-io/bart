import 'package:bart/bart/bart_appbar.dart';
import 'package:bart/bart/bart_model.dart';
import 'package:bart/bart/nested_navigator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'animated_appbar.dart';
import 'bottom_bar/bottom_bar.dart';
import 'router_delegate.dart';

class BartScaffold extends StatefulWidget {
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
        showAppBarNotifier = ValueNotifier(false),
        super(key: key);

  @override
  State<BartScaffold> createState() => _BartScaffoldState();
}

class _BartScaffoldState extends State<BartScaffold>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final GlobalKey<NavigatorState> navigationKey = GlobalKey<NavigatorState>();

  List<BartMenuRoute> get routesBuilder => widget.routesBuilder();
  int get initialIndex {
    final index = routesBuilder
        .indexWhere((element) => element.path == widget.initialRoute);
    return index == -1 ? 0 : index;
  }

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      length: routesBuilder.length,
      initialIndex: initialIndex,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: NestedNavigator(
              navigationKey: navigationKey,
              initialRoute: '/library',
              routes: routesBuilder,
              // onGenerateRoute: widget.routesBuilder,
            ),
            // child: TabBarView(
            //   controller: _tabController,
            //   physics: NeverScrollableScrollPhysics(),
            //   children: routesBuilder.map((e) => e.pageBuilder()),
            // ),
          ),
          TabBar(
            controller: _tabController,
            onTap: (value) {
              Navigator.of(navigationKey.currentContext!).pushNamed(routesBuilder[value].path);
            },
            tabs: [
              Tab(icon: Icon(Icons.directions_car)),
              Tab(icon: Icon(Icons.directions_car)),
              Tab(icon: Icon(Icons.directions_car)),
              Tab(icon: Icon(Icons.directions_car)),
              Tab(icon: Icon(Icons.directions_car)),
            ],
          ),
        ],
      ),
    );
    // return MenuRouter(
    //   routesBuilder: widget.routesBuilder,
    //   initialRoute: widget.initialRoute,
    //   navigatorObservers: widget.navigatorObservers,
    //   child: Actions(
    //     actions: <Type, Action<Intent>>{
    //       AppBarBuildIntent: BartAppbarAction(widget.appBarNotifier),
    //       AppBarAnimationIntent: BartAnimatedAppbarAction(widget.showAppBarNotifier),
    //       BottomBarIndexIntent: BartBottomBarIndexAction(widget.bottomBar.currentIndex)
    //     },
    //     child: AnimatedBuilder(
    //       animation: widget.appBarNotifier,
    //       builder: (ctx, child) => Scaffold(
    //         key: widget.key,
    //         appBar: AnimatedAppBar(
    //           appBar: widget.appBarNotifier.value,
    //           showStateNotifier: widget.showAppBarNotifier,
    //         ),
    //         floatingActionButton: widget.floatingActionButton,
    //         floatingActionButtonLocation: widget.floatingActionButtonLocation,
    //         floatingActionButtonAnimator: widget.floatingActionButtonAnimator,
    //         persistentFooterButtons: widget.persistentFooterButtons,
    //         drawer: widget.drawer,
    //         onDrawerChanged: widget.onDrawerChanged,
    //         endDrawer: widget.endDrawer,
    //         onEndDrawerChanged: widget.onEndDrawerChanged,
    //         bottomSheet: widget.bottomSheet,
    //         backgroundColor: widget.backgroundColor,
    //         resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
    //         primary: widget.primary ?? true,
    //         drawerDragStartBehavior:
    //             widget.drawerDragStartBehavior ?? DragStartBehavior.start,
    //         extendBody: widget.extendBody ?? false,
    //         extendBodyBehindAppBar: true,
    //         drawerScrimColor: widget.drawerScrimColor,
    //         drawerEdgeDragWidth: widget.drawerEdgeDragWidth,
    //         drawerEnableOpenDragGesture: widget.drawerEnableOpenDragGesture ?? true,
    //         endDrawerEnableOpenDragGesture:
    //             widget.endDrawerEnableOpenDragGesture ?? true,
    //         restorationId: widget.restorationId,
    //         body: Router(
    //           routerDelegate: MenuRouter.of(ctx).routerDelegate,
    //         ),
    //         bottomNavigationBar: widget.bottomBar,
    //       ),
    //       // ),
    //     ),
    //   ),
    // );
  }
}
