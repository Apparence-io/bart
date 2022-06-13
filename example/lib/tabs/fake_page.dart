import 'package:flutter/material.dart';

class PageFake extends StatelessWidget {
  final Color bgColor;
  final Widget? child;
  final bool showAppbar;

  const PageFake(
    this.bgColor, {
    this.child,
    Key? key,
    this.showAppbar = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: bgColor,
      child: Center(child: child),
    );
  }
}
