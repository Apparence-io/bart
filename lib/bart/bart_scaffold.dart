import 'package:bart/bart/bart_appbar.dart';
import 'package:bart/bart/bart_model.dart';
import 'package:bart/bart/bottom_bar/styles/bottom_bar_material.dart';
import 'package:bart/bart/nested_navigator.dart';
import 'package:bart/bart/router_delegate.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'animated_appbar.dart';
import 'bottom_bar/bottom_bar.dart';

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
    with SingleTickerProviderStateMixin, RouteAware {
  final GlobalKey<NavigatorState> navigationKey = GlobalKey<NavigatorState>();
  // final RouteObserver<ModalRoute> routeObserver = RouteObserver<ModalRoute>();
  final indexNotifier = ValueNotifier(0);

  List<BartMenuRoute> get routesBuilder => widget.routesBuilder();
  int get initialIndex {
    final index = routesBuilder
        .indexWhere((element) => element.path == widget.initialRoute);
    return index == -1 ? 0 : index;
  }

  @override
  void initState() {
    super.initState();
    indexNotifier.addListener(() {
      print('dtes');
      print(indexNotifier.value);
    });
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   routeObserver.subscribe(this, ModalRoute.of(navigationKey.currentContext!)!);
    // });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: put this in a model
    return MenuRouter(
      indexNotifier: indexNotifier,
      routesBuilder: widget.routesBuilder,
      navigationKey: navigationKey,
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: NestedNavigator(
                navigationKey: navigationKey,
                routes: routesBuilder,
                // navigatorObserver: routeObserver,
                // onGenerateRoute: widget.routesBuilder,
              ),
            ),
            widget.bottomBar
          ],
        ),
      ),
    );
  }
}
