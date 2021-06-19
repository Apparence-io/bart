import 'package:flutter/material.dart';

class CustomNavigatorObserver<T> extends RouteObserver<PageRoute<T>> {
  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
  }
}
