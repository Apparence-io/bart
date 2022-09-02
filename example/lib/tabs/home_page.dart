import 'package:flutter/material.dart';

import 'package:bart/bart.dart';

class HomePage extends StatelessWidget with AppBarNotifier {
  final BuildContext parentContext;
  const HomePage({
    Key? key,
    required this.parentContext,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              child: const Text(
                "Add AppBar",
              ),
              onPressed: () {
                updateAppBar(
                  context,
                  AppBar(
                    title: const Text("title text"),
                  ),
                );
                showAppBar(context);
              },
            ),
            TextButton(
              child: const Text(
                "Hide AppBar",
              ),
              onPressed: () => hideAppBar(context),
            ),
            const Divider(),
            TextButton(
              child: const Text(
                "Open page over tabbar",
              ),
              onPressed: () => Navigator.of(parentContext).pushNamed("/parent"),
            ),
            const Divider(),
            TextButton(
              key: const ValueKey("subpageBtn"),
              child: const Text(
                "Go to inner page",
              ),
              onPressed: () => Navigator.of(context).pushNamed("/home/inner"),
            ),
            const Divider(),
            TextButton(
              child: const Text(
                "Go to library tab",
              ),
              onPressed: () => Navigator.of(context).pushNamed("/library"),
            ),
            TextButton(
              child: const Text(
                "Go to profile tab",
              ),
              onPressed: () => Navigator.of(context).pushNamed("/profile"),
            ),
            TextButton(
              child: const Text(
                "Go to counter tab",
              ),
              onPressed: () => Navigator.of(context).pushNamed("/counter"),
            ),
          ],
        ),
      ),
    );
  }
}
