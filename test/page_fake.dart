import 'package:flutter/material.dart';

class PageFake extends StatelessWidget {
  final Color bgColor;
  final Widget? child;

  PageFake(this.bgColor, {this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: bgColor,
      child: Center(child: child),
    );
  }
}
