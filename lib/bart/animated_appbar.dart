import 'package:bart/bart/bart_appbar.dart';
import 'package:flutter/material.dart';

/// Use this intent when using animated appBar to show/hide using animation
class AppBarAnimationIntent extends Intent {
  final bool state;

  const AppBarAnimationIntent(this.state);

  factory AppBarAnimationIntent.show() => const AppBarAnimationIntent(true);

  factory AppBarAnimationIntent.hide() => const AppBarAnimationIntent(false);
}

/// se this action when using animated appBar to show/hide using [AppBarBuildIntent]
class BartAnimatedAppbarAction extends Action<AppBarAnimationIntent> {
  ValueNotifier<bool> show;

  BartAnimatedAppbarAction(this.show);

  @override
  void invoke(covariant AppBarAnimationIntent intent) {
    show.value = intent.state;
  }
}

class AnimatedAppBar extends StatelessWidget implements PreferredSizeWidget {
  final PreferredSizeWidget? appBar;
  final ValueNotifier<bool> showStateNotifier;

  const AnimatedAppBar({
    Key? key,
    required this.appBar,
    required this.showStateNotifier,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: showStateNotifier,
      builder: (context, show, child) => Stack(
        children: [
          AnimatedPositioned(
            curve: Curves.decelerate,
            duration: const Duration(milliseconds: 300),
            top: show ? 0 : -150,
            left: 0,
            right: 0,
            child: appBar ?? Container(),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize =>
      appBar == null ? const Size(0, 0) : appBar!.preferredSize;
}
