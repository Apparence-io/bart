import 'package:bart/bart/utils.dart';
import 'package:flutter/material.dart';

import 'animated_appbar.dart';

/// Use this intent to provide a custom appBar within a child widget to the scaffold
class AppBarBuildIntent extends Intent {
  final PreferredSizeWidget? appbar;

  AppBarBuildIntent(this.appbar);

  factory AppBarBuildIntent.empty() => AppBarBuildIntent(null);
}

/// you can change app bar within your page by calling once
/// Actions.invoke(context, AppBarBuildIntent(AppBar(title: Text("title text"))));
class BartAppbarAction extends Action<AppBarBuildIntent> {
  ValueNotifier<PreferredSizeWidget?> appbar;

  BartAppbarAction(this.appbar);

  @override
  void invoke(covariant AppBarBuildIntent intent) {
    this.appbar.value = intent.appbar;
  }
}

mixin AppBarNotifier {
  void updateAppBar(BuildContext context, PreferredSizeWidget? appBar) {
    _runWhenReady(
        context, () => Actions.invoke(context, AppBarBuildIntent(appBar)));
  }

  void showAppBar(BuildContext context) {
    _runWhenReady(
        context, () => Actions.invoke(context, AppBarAnimationIntent.show()));
  }

  void hideAppBar(BuildContext context) {
    _runWhenReady(
        context, () => Actions.invoke(context, AppBarAnimationIntent.hide()));
  }

  _runWhenReady(BuildContext context, Function onReady) {
    if (context.debugDoingBuild) {
      ambiguate(WidgetsBinding.instance)!.addPostFrameCallback((_) {
        onReady();
      });
    } else {
      onReady();
    }
  }
}
