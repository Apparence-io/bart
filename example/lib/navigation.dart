import 'package:bart/bart.dart';
import 'package:flutter/material.dart';

class MainPageMenu extends StatefulWidget {
  final BartRouteBuilder routesBuilder;

  const MainPageMenu({Key? key, required this.routesBuilder}) : super(key: key);

  @override
  State<MainPageMenu> createState() => _MainPageMenuState();
}

class _MainPageMenuState extends State<MainPageMenu> {
  @override
  Widget build(BuildContext context) {
    return BartScaffold(
      routesBuilder: widget.routesBuilder,
      showBottomBarOnStart: true,
      bottomBar: BartBottomBar.material3(),
      // uncomment to use an exemple of custom bottom bar
      // bottomBar: BartBottomBar.custom(
      //   bottomBarFactory: SimpleBottomBar(),
      // ),
    );
  }
}
