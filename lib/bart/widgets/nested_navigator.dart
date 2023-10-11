import 'package:bart/bart/bart_appbar.dart';
import 'package:bart/bart/bart_bottombar_actions.dart';
import 'package:bart/bart/bart_model.dart';
import 'package:bart/bart/router_delegate.dart';
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

  const NestedNavigator({
    Key? key,
    required this.parentContext,
    required this.navigationKey,
    required this.appBarNotifier,
    required this.showAppBarNotifier,
    this.initialRoute,
    required this.routes,
    required this.navigatorObserver,
    this.onWillPop,
  }) : super(key: key);

  @override
  State<NestedNavigator> createState() => _NestedNavigatorState();
}

class _NestedNavigatorState extends State<NestedNavigator>
    with AppBarNotifier, BartNotifier {
  final Map<String, Widget> pageCache = {};
  final PageStorageBucket bucket = PageStorageBucket();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Navigator(
        key: widget.navigationKey,
        initialRoute: widget.initialRoute,
        // observers: [routeObserver],
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
      onWillPop: () {
        showBottomBar(context);
        if (widget.onWillPop != null) {
          widget.onWillPop!();
        }
        if (widget.navigationKey.currentState != null &&
            widget.navigationKey.currentState!.canPop()) {
          widget.navigationKey.currentState!.pop();
        }
        return Future<bool>.value(false);
      },
    );
  }
}
