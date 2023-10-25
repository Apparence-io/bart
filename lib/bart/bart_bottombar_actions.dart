import 'package:bart/bart/widgets/bottom_bar/bottom_bar.dart';
import 'package:flutter/material.dart';

class BottomBarIntent extends Intent {
  final bool state;

  const BottomBarIntent(this.state);

  factory BottomBarIntent.show() => const BottomBarIntent(true);

  factory BottomBarIntent.hide() => const BottomBarIntent(false);
}

class BottomBarAction extends Action<BottomBarIntent> {
  ValueNotifier<bool> show;

  BottomBarAction(this.show);

  @override
  void invoke(covariant BottomBarIntent intent) {
    show.value = intent.state;
  }
}

class AnimatedBottomBar extends StatelessWidget {
  final ValueNotifier<bool> showStateNotifier;
  final BartBottomBar bottomBar;

  const AnimatedBottomBar({
    super.key,
    required this.showStateNotifier,
    required this.bottomBar,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: showStateNotifier,
      child: bottomBar,
      builder: (context, show, child) {
        if (!show) {
          return const SizedBox(height: 0, width: 0);
        }
        return child!;
      },
    );
  }
}

mixin BartNotifier {
  void showBottomBar(BuildContext context) {
    _runWhenReady(
      context,
      () => Actions.invoke(context, BottomBarIntent.show()),
    );
  }

  void hideBottomBar(BuildContext context) {
    _runWhenReady(
      context,
      () => Actions.invoke(context, BottomBarIntent.hide()),
    );
  }

  _runWhenReady(BuildContext context, Function onReady) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      onReady();
    });
  }
}
