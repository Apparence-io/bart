import 'package:flutter/material.dart';

class PageFake extends StatelessWidget {

  final Color bgColor;

  PageFake(this.bgColor);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: bgColor,
    );
  }
}