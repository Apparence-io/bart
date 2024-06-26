import 'package:bart/bart/bart_model.dart';
import 'package:bart/bart/router_delegate.dart';
import 'package:bart/bart/widgets/side_bar/sidebar.dart';
import 'package:flutter/material.dart';

class CustomSideBarContainer extends StatefulWidget {
  final Widget child;
  final List<BartMenuRoute> routes;
  final Gravity gravity;
  final SideBarBuilder sideBarBuilder;

  const CustomSideBarContainer({
    super.key,
    required this.child,
    required this.routes,
    required this.sideBarBuilder,
    this.gravity = Gravity.left,
  });

  @override
  State<CustomSideBarContainer> createState() => _CustomSideBarContainerState();
}

typedef SideBarBuilder = Widget Function(
  List<BartMenuRoute> routes,
  OnTapItem onTapItem,
  ValueNotifier<int> currentItem,
);

typedef OnTapItem = void Function(int index);

class _CustomSideBarContainerState extends State<CustomSideBarContainer> {
  late List<BartMenuRoute> routes = [];

  @override
  void initState() {
    super.initState();
    routes = widget.routes
          .where(
            (element) => element.type == BartMenuRouteType.bottomNavigation,
          )
          .toList();
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
        widget.sideBarBuilder(
          routes,
          onTapItem,
          MenuRouter.of(context).indexNotifier,
        ),
        if (widget.gravity == Gravity.left) Flexible(child: widget.child),
      ],
    );
  }

  void onTapItem(int index) {
    final nestedContext = MenuRouter.of(context) //
        .navigationKey
        .currentContext;
    if (nestedContext != null) {
      Navigator.of(nestedContext).pushReplacementNamed(
        widget.routes[index].path,
      );
    }
  }
}
