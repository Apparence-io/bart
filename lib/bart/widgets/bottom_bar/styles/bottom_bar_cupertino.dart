import 'package:bart/bart/bart_model.dart';
import 'package:bart/bart/widgets/bottom_bar/bottom_bar.dart';
import 'package:flutter/cupertino.dart';

class BartCupertinoBottomBar extends StatefulWidget {
  final List<BartMenuRoute> routes;
  final BottomBarTapAction onTap;
  final ValueNotifier<int> currentIndexNotifier;

  final CupertinoBottomBarTheme theme;

  const BartCupertinoBottomBar({
    Key? key,
    required this.routes,
    required this.onTap,
    required this.currentIndexNotifier,
    required this.theme,
  }) : super(key: key);

  @override
  State<BartCupertinoBottomBar> createState() => _BartCupertinoBottomBarState();
}

class _BartCupertinoBottomBarState extends State<BartCupertinoBottomBar> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.currentIndexNotifier,
      builder: ((context, int index, child) {
        return CupertinoTabBar(
          items: buildRouteWidgetList(context),
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

  List<BottomNavigationBarItem> buildRouteWidgetList(BuildContext context) =>
      widget.routes.map(
        (route) {
          if (route.icon != null) {
            return BottomNavigationBarItem(
              icon: Icon(route.icon),
              label: route.label,
            );
          } else if (route.iconBuilder != null) {
            return BottomNavigationBarItem(
              icon: route.iconBuilder!(context),
              label: route.label,
            );
          }
          throw Exception(
            "You must provide an icon or an iconBuilder for each route",
          );
        },
      ).toList();
}
