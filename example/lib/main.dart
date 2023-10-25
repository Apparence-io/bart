import 'package:flutter/material.dart';

import 'navigation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      onGenerateRoute: routes,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}

Route<dynamic> routes(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return MaterialPageRoute(
        builder: (_) => const MainPageMenu(),
      );
    case '/parent':
      return MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(),
          body: const Center(
            child: Text('Parent'),
          ),
        ),
      );
    default:
      throw 'unexpected Route';
  }
}
