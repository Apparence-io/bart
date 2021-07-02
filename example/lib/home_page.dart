import 'package:bart/bart.dart';
import 'package:flutter/material.dart';
import 'fake_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageFake(
      Colors.red,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            key: ValueKey("subpageBtn"),
            child: Text(
              "Route to page 2",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () => Navigator.of(context).pushNamed("/subpage"),
          ),
          TextButton(
            child: Text(
              "add app bar",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Actions.invoke(
                context,
                AppBarBuildIntent(AppBar(
                  title: Text("title text"),
                )),
              );
              Actions.invoke(
                context,
                AppBarAnimationIntent.show(),
              );
            },
          ),
          TextButton(
            child: Text(
              "hide app bar",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Actions.invoke(
                context,
                AppBarAnimationIntent.hide(),
              );
            },
          ),
          TextButton(
            child: Text(
              "Go to library",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Navigator.of(context).pushNamed("/library");
            },
          ),
          TextButton(
            child: Text(
              "Go to profile",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Navigator.of(context).pushNamed("/profile");
            },
          ),
          TextButton(
            child: Text(
              "Go to counter",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Navigator.of(context).pushNamed("/counter");
            },
          ),
        ],
      ),
    );
  }
}
