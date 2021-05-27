import 'package:flutter/material.dart';

class CustomNavigatorObserver<T> extends RouteObserver<PageRoute<T>>  {

  @override
  void didPush(Route<dynamic> route, Route<dynamic> previousRoute) {
    super.didPush(route, previousRoute);
    print("${route.settings.name} pushed");
  }

}