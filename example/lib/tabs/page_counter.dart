import 'package:bart/bart/bart_appbar.dart';
import 'package:flutter/material.dart';

class PageFakeCounter extends StatefulWidget {
  final bool showAppBar;

  const PageFakeCounter({Key? key, this.showAppBar = false}) : super(key: key);

  @override
  PageFakeCounterState createState() => PageFakeCounterState();
}

@visibleForTesting
class PageFakeCounterState extends State<PageFakeCounter> with AppBarNotifier {
  final ValueNotifier counterNotifier = ValueNotifier(0);

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
      valueListenable: counterNotifier,
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
                  counterNotifier.value++;
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
