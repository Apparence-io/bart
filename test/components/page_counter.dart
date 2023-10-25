import 'package:bart/bart/bart_appbar.dart';
import 'package:flutter/material.dart';

class PageFakeCounter extends StatefulWidget {
  final ValueNotifier counter = ValueNotifier(1);
  final bool showAppBar;

  PageFakeCounter({super.key, this.showAppBar = false});

  @override
  PageFakeCounterState createState() => PageFakeCounterState();
}

class PageFakeCounterState extends State<PageFakeCounter> with AppBarNotifier {
  @override
  void initState() {
    super.initState();

    if (widget.showAppBar) {
      updateAppBar(context, AppBar(title: const Text("appbar")));
      showAppBar(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.counter,
      builder: (context, counter, child) => Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "$counter",
              key: const ValueKey("counter"),
            ),
            TextButton(
              key: const ValueKey("addCountBtn"),
              onPressed: () {
                setState(() {
                  widget.counter.value++;
                });
              },
              child: const Text("Add"),
            ),
            TextButton(
              key: const ValueKey("hideAppBar"),
              onPressed: () => hideAppBar(context),
              child: const Text("hide app bar"),
            ),
          ],
        ),
      ),
    );
  }
}
