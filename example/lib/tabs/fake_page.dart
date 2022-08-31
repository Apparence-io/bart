import 'package:flutter/material.dart';

class PageFake extends StatelessWidget {
  final Color bgColor;
  final Widget? child;
  final bool showAppBar;

  const PageFake(
    this.bgColor, {
    this.child,
    Key? key,
    this.showAppBar = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: bgColor,
      child: Center(child: child),
    );
  }
}
