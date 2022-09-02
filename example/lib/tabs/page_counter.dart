import 'package:bart/bart/bart_appbar.dart';
import 'package:flutter/material.dart';

class PageFakeCounter extends StatefulWidget {
  final bool showAppBar;
  final ValueNotifier counterNotifier = ValueNotifier(0);

  PageFakeCounter({Key? key, this.showAppBar = false}) : super(key: key);

  @override
  PageFakeCounterState createState() => PageFakeCounterState();
}

@visibleForTesting
class PageFakeCounterState extends State<PageFakeCounter> with AppBarNotifier {
  @override
  void initState() {
    super.initState();

    if (widget.showAppBar) {
      updateAppBar(context, AppBar(title: const Text("Counter Tab Page")));
      showAppBar(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.counterNotifier,
      builder: (context, counter, child) => Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "$counter",
              style: const TextStyle(fontSize: 30.0),
              key: const ValueKey("counter"),
            ),
            const SizedBox(
              height: 10,
            ),
            TextButton(
              key: const ValueKey("addCountBtn"),
              onPressed: () {
                widget.counterNotifier.value++;
              },
              child: const Text("Increment"),
            )
          ],
        ),
      ),
    );
  }
}
