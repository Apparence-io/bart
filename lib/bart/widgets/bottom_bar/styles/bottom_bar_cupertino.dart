import 'package:bart/bart/bart_model.dart';
import 'package:bart/bart/widgets/bottom_bar/bottom_bar.dart';
import 'package:flutter/cupertino.dart';

class BartCupertinoBottomBar extends StatefulWidget {
  final List<BartMenuRoute> routes;
  final BottomBarTapAction onTap;
  final ValueNotifier<int> currentIndexNotifier;

  final CupertinoBottomBarTheme theme;

  const BartCupertinoBottomBar({
    super.key,
    required this.routes,
    required this.onTap,
    required this.currentIndexNotifier,
    required this.theme,
  });

  @override
  State<BartCupertinoBottomBar> createState() => _BartCupertinoBottomBarState();
}

class _BartCupertinoBottomBarState extends State<BartCupertinoBottomBar> {
  List<BottomNavigationBarItem>? _items;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.currentIndexNotifier,
      builder: ((context, int index, child) {
        _items = buildRouteWidgetList(context);
        return CupertinoTabBar(
          key: const ValueKey('bottom_bar'),
          items: _items!,
          currentIndex: index,
          iconSize: widget.theme.iconSize,
          border: widget.theme.border,
          backgroundColor: widget.theme.bgColor,
          activeColor: widget.theme.selectedItemColor,
          height: widget.theme.height ?? 50.0,
          inactiveColor:
              widget.theme.unselectedItemColor ?? CupertinoColors.inactiveGray,
          onTap: (index) => widget.onTap(index),
        );
      }),
    );
  }

  List<BottomNavigationBarItem> buildRouteWidgetList(BuildContext context) {
    return widget.routes
        .where((element) => element.type == BartMenuRouteType.bottomNavigation)
        .map(
      (route) {
        final routeIndex = widget.routes.indexOf(route);

        if (route.icon != null) {
          return BottomNavigationBarItem(
            icon: Icon(route.icon),
            label: route.label,
          );
        } else if (route.iconBuilder != null) {
          return BottomNavigationBarItem(
            icon: route.iconBuilder!(
              context,
              routeIndex == widget.currentIndexNotifier.value,
            ),
            label: route.label,
          );
        }
        throw Exception(
          "You must provide an icon or an iconBuilder for each route",
        );
      },
    ).toList();
  }
}
