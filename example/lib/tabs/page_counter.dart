import 'package:bart/bart/bart_appbar.dart';
import 'package:flutter/material.dart';

class PageFakeCounter extends StatefulWidget {
  final ValueNotifier counter = ValueNotifier(0);
  final bool showAppBar;

  PageFakeCounter({Key? key, this.showAppBar = false}) : super(key: key);

  @override
  PageFakeCounterState createState() => PageFakeCounterState();
}

@visibleForTesting
class PageFakeCounterState extends State<PageFakeCounter> with AppBarNotifier {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.showAppBar) {
      updateAppBar(context, AppBar(title: const Text("appbar")));
      showAppBar(context);
    }
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
            )
          ],
        ),
      ),
    );
  }
}
