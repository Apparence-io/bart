import 'package:bart/bart/bart_model.dart';
import 'package:bart/bart/router_delegate.dart';
import 'package:bart/bart/widgets/side_bar/sidebar.dart';
import 'package:flutter/material.dart';

class WebRailSideBarContainer extends StatefulWidget {
  final Widget child;
  final List<BartMenuRoute> routes;
  final Gravity gravity;
  final bool extended;

  const WebRailSideBarContainer({
    super.key,
    required this.child,
    required this.routes,
    this.gravity = Gravity.left,
    this.extended = false,
  });

  @override
  State<WebRailSideBarContainer> createState() =>
      _WebRailSideBarContainerState();
}

class _WebRailSideBarContainerState extends State<WebRailSideBarContainer> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      selectedIndex = MenuRouter.of(context).indexNotifier.value;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (widget.gravity == Gravity.right) Flexible(child: widget.child),
        ValueListenableBuilder(
          valueListenable: MenuRouter.of(context).indexNotifier,
          builder: (context, int index, child) => NavigationRail(
            selectedIndex: index,
            extended: widget.extended,
            onDestinationSelected: (index) {
              final nestedContext = MenuRouter.of(context) //
                  .navigationKey
                  .currentContext;
              if (nestedContext != null) {
                Navigator.of(nestedContext).pushReplacementNamed(
                  widget.routes[index].path,
                );
              }
            },
            destinations: widget.routes
                .where((element) =>
                    element.type == BartMenuRouteType.bottomNavigation)
                .map(
              (route) {
                if (route.icon != null) {
                  return NavigationRailDestination(
                    icon: Icon(route.icon),
                    selectedIcon: route.selectedIcon != null
                        ? Icon(route.selectedIcon)
                        : Icon(route.icon),
                    label: Text(route.label ?? ''),
                  );
                } else if (route.iconBuilder != null) {
                  return NavigationRailDestination(
                    icon: route.iconBuilder!(context),
                    label: Text(route.label ?? ''),
                  );
                } else {
                  throw Exception(
                    "You must provide an icon or an iconBuilder for each route (route: ${route.path}))",
                  );
                }
              },
            ).toList(),
          ),
        ),
        if (widget.gravity == Gravity.left) Flexible(child: widget.child),
      ],
    );
  }
}
