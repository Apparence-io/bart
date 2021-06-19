import 'package:bart/bart/bart_appbar.dart';
import 'package:flutter/material.dart';

class PageFakeCounter extends StatefulWidget {
  final ValueNotifier counter = ValueNotifier(1);
  final bool showAppBar;

  PageFakeCounter({Key? key, this.showAppBar = false}) : super(key: key);

  @override
  _PageFakeCounterState createState() => _PageFakeCounterState();
}

class _PageFakeCounterState extends State<PageFakeCounter> with AppBarNotifier {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.showAppBar) {
      updateAppBar(context, AppBar(title: Text("appbar")));
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
              key: ValueKey("counter"),
            ),
            TextButton(
              key: ValueKey("addCountBtn"),
              onPressed: () {
                setState(() {
                  widget.counter.value++;
                });
              },
              child: Text("Add"),
            ),
            TextButton(
              key: ValueKey("hideAppBar"),
              onPressed: () => hideAppBar(context),
              child: Text("hide app bar"),
            ),
          ],
        ),
      ),
    );
  }
}
