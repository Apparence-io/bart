import 'package:flutter/material.dart';

class AppBarBuildIntent extends Intent {
  final PreferredSizeWidget? appbar;

  AppBarBuildIntent(this.appbar);

  factory AppBarBuildIntent.empty() => AppBarBuildIntent(null);
}

// you can change app bar within your page by calling once
// Actions.invoke(context, AppBarBuildIntent(AppBar(title: Text("title text"))));
class BartAppbarAction extends Action<AppBarBuildIntent> {
  ValueNotifier<PreferredSizeWidget?> appbar;

  BartAppbarAction(this.appbar);

  @override
  void invoke(covariant AppBarBuildIntent intent) {
    this.appbar.value = intent.appbar;
  }
}
