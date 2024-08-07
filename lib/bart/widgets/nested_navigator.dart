import 'package:bart/bart/bart_appbar.dart';
import 'package:bart/bart/bart_bottombar_actions.dart';
import 'package:bart/bart/bart_model.dart';
import 'package:bart/bart/router_delegate.dart';
import 'package:bart/bart/widgets/side_bar/custom_sidebar.dart';
import 'package:bart/bart/widgets/side_bar/rail_sidebar.dart';
import 'package:bart/bart/widgets/side_bar/sidebar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

final RouteObserver<dynamic> routeObserver = RouteObserver<PageRoute>();

class NestedNavigator extends StatefulWidget {
  final BuildContext parentContext;
  final GlobalKey<NavigatorState> navigationKey;
  final RouteObserver<dynamic> navigatorObserver;
  final ValueNotifier<PreferredSizeWidget?> appBarNotifier;
  final ValueNotifier<bool> showAppBarNotifier;
  final String? initialRoute;
  final List<BartMenuRoute> routes;
  final Function()? onWillPop;
  final SideBarOptions? sideBarOptions;

  const NestedNavigator({
    super.key,
    required this.parentContext,
    required this.navigationKey,
    required this.appBarNotifier,
    required this.showAppBarNotifier,
    this.initialRoute,
    required this.routes,
    required this.navigatorObserver,
    this.sideBarOptions,
    this.onWillPop,
  });

  @override
  State<NestedNavigator> createState() => _NestedNavigatorState();
}

class _NestedNavigatorState extends State<NestedNavigator>
    with AppBarNotifier, BartNotifier {
  final Map<String, Widget> pageCache = {};
  final PageStorageBucket bucket = PageStorageBucket();

  @override
  Widget build(BuildContext context) {
    final content = PopScope(
      child: Navigator(
        key: widget.navigationKey,
        initialRoute: widget.initialRoute,
        // observers: [routeObserver()],
        onGenerateRoute: (RouteSettings routeSettings) {
          Actions.invoke(context, AppBarBuildIntent.empty());
          hideAppBar(context);

          final route = widget.routes.firstWhere(
            (element) => element.path == routeSettings.name,
            orElse: () => widget.routes.first,
          );

          if (route.showBottomBar) {
            showBottomBar(context);
          } else {
            hideBottomBar(context);
          }

          return PageRouteBuilder(
            maintainState: route.maintainState ?? true,
            transitionDuration:
                route.transitionDuration ?? const Duration(milliseconds: 300),
            transitionsBuilder:
                route.transitionsBuilder ?? (_, a, b, child) => child,
            pageBuilder: (context, __, ___) {
              if (route.cache) {
                if (!pageCache.containsKey(route.path)) {
                  pageCache[route.path] = RouteAwareWidget(
                    appBarNotifier: widget.appBarNotifier,
                    showAppBarNotifier: widget.showAppBarNotifier,
                    route: route,
                    child: route.pageBuilder(
                      widget.parentContext,
                      context,
                      routeSettings,
                    ),
                  );
                }

                return PageStorage(
                  bucket: bucket,
                  child: pageCache[route.path]!,
                );
              }

              return RouteAwareWidget(
                appBarNotifier: widget.appBarNotifier,
                showAppBarNotifier: widget.showAppBarNotifier,
                route: route,
                child: route.pageBuilder(
                  widget.parentContext,
                  context,
                  routeSettings,
                ),
              );
            },
          );
        },
      ),
      onPopInvoked: (willPop) {
        if (!willPop) {
          return;
        }
        showBottomBar(context);
        if (widget.onWillPop != null) {
          widget.onWillPop!();
        }
        if (widget.navigationKey.currentState != null &&
            widget.navigationKey.currentState!.canPop()) {
          widget.navigationKey.currentState!.pop();
        }
      },
    );
    return switch ((kIsWeb, widget.sideBarOptions)) {
      (_, CustomSideBarOptions option) => CustomSideBarContainer(
          gravity: option.gravity,
          routes: widget.routes,
          sideBarBuilder: option.sideBarBuilder,
          child: content,
        ),
      (_, RailSideBarOptions option) => WebRailSideBarContainer(
          gravity: option.gravity,
          extended: option.extended,
          routes: widget.routes,
          child: content,
        ),
      (_, _) => content,
    };
  }
}
