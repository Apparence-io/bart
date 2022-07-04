import 'package:universal_io/io.dart';

import 'package:bart/bart/bottom_bar/styles/bottom_bar_cupertino.dart';
import 'package:bart/bart/bottom_bar/styles/bottom_bar_material.dart';
import 'package:bart/bart/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../bart_model.dart';
import '../router_delegate.dart';

typedef BottomBarTapAction = void Function(int index);

typedef BartRouteBuilder = List<BartMenuRoute> Function();

class BartBottomBar extends StatefulWidget {
  final ValueNotifier<int> currentIndex;
  final double? elevation;
  final double? height;
  final Color? bgColor, selectedItemColor, unselectedItemColor;
  final BottomNavigationBarType? type;
  final IconThemeData? iconThemeData;
  final double iconSize;
  final bool enableHapticFeedback;
  final double selectedFontSize, unselectedFontSize;

  /// use [BartMaterialBottomBar.bottomBarFactory] by default but you can create your own
  final BartBottomBarFactory bottomBarFactory;

  const BartBottomBar._({
    required this.bottomBarFactory,
    this.elevation,
    this.bgColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.type,
    this.height,
    this.enableHapticFeedback = true,
    this.iconThemeData,
    this.selectedFontSize = 14.0,
    this.unselectedFontSize = 12.0,
    this.iconSize = 24,
    required this.currentIndex,
  });

  factory BartBottomBar.material(
          {double? elevation,
          Color? bgColor,
          Color? selectedItemColor,
          Color? unselectedItemColor,
          double? height,
          BottomNavigationBarType? type,
          bool enableHapticFeedback = true,
          IconThemeData? iconThemeData,
          double selectedFontSize = 14.0,
          double unselectedFontSize = 12.0,
          double iconSize = 24,
          int index = 0}) =>
      BartBottomBar._(
        bottomBarFactory: BartMaterialBottomBar.bottomBarFactory,
        elevation: elevation,
        bgColor: bgColor,
        enableHapticFeedback: enableHapticFeedback,
        selectedItemColor: selectedItemColor,
        unselectedItemColor: unselectedItemColor,
        type: type,
        iconThemeData: iconThemeData,
        selectedFontSize: selectedFontSize,
        unselectedFontSize: unselectedFontSize,
        iconSize: iconSize,
        height: height,
        currentIndex: ValueNotifier(index),
      );

  factory BartBottomBar.cupertino(
          {double? elevation,
          Color? bgColor,
          Color? selectedItemColor,
          Color? unselectedItemColor,
          BottomNavigationBarType? type,
          bool enableHapticFeedback = true,
          IconThemeData? iconThemeData,
          double selectedFontSize = 14.0,
          double unselectedFontSize = 12.0,
          double iconSize = 24,
          double? height,
          int index = 0}) =>
      BartBottomBar._(
        bottomBarFactory: BartCupertinoBottomBar.bottomBarFactory,
        elevation: elevation,
        bgColor: bgColor,
        enableHapticFeedback: enableHapticFeedback,
        selectedItemColor: selectedItemColor,
        unselectedItemColor: unselectedItemColor,
        type: type,
        height: height,
        iconThemeData: iconThemeData,
        selectedFontSize: selectedFontSize,
        unselectedFontSize: unselectedFontSize,
        iconSize: iconSize,
        currentIndex: ValueNotifier(index),
      );

  factory BartBottomBar.adaptive(
          {double? elevation,
          Color? bgColor,
          Color? selectedItemColor,
          Color? unselectedItemColor,
          BottomNavigationBarType? type,
          bool enableHapticFeedback = true,
          IconThemeData? iconThemeData,
          double selectedFontSize = 14.0,
          double unselectedFontSize = 12.0,
          double iconSize = 24,
          double? height,
          int index = 0}) =>
      BartBottomBar._(
        bottomBarFactory: Platform.isIOS
            ? BartCupertinoBottomBar.bottomBarFactory
            : BartMaterialBottomBar.bottomBarFactory,
        elevation: elevation,
        bgColor: bgColor,
        height: height,
        enableHapticFeedback: enableHapticFeedback,
        selectedItemColor: selectedItemColor,
        unselectedItemColor: unselectedItemColor,
        type: type,
        iconThemeData: iconThemeData,
        selectedFontSize: selectedFontSize,
        unselectedFontSize: unselectedFontSize,
        iconSize: iconSize,
        currentIndex: ValueNotifier(index),
      );

  factory BartBottomBar.fromFactory(
          {required BartBottomBarFactory bottomBarFactory,
          double? elevation,
          Color? bgColor,
          Color? selectedItemColor,
          Color? unselectedItemColor,
          double? height,
          bool enableHapticFeedback = true,
          BottomNavigationBarType? type,
          IconThemeData? iconThemeData,
          double selectedFontSize = 14.0,
          double unselectedFontSize = 12.0,
          double iconSize = 24,
          int index = 0}) =>
      BartBottomBar._(
        bottomBarFactory: bottomBarFactory,
        elevation: elevation,
        bgColor: bgColor,
        height: height,
        enableHapticFeedback: enableHapticFeedback,
        selectedItemColor: selectedItemColor,
        unselectedItemColor: unselectedItemColor,
        type: type,
        iconThemeData: iconThemeData,
        selectedFontSize: selectedFontSize,
        unselectedFontSize: unselectedFontSize,
        iconSize: iconSize,
        currentIndex: ValueNotifier(index),
      );

  @override
  BartBottomBarState createState() => BartBottomBarState();
}

@visibleForTesting
class BartBottomBarState extends State<BartBottomBar> {
  List<BartMenuRoute> get routes =>
      MenuRouter.of(context).routerDelegate.routes;

  MenuRouterDelegate get routerDelegate =>
      MenuRouter.of(context).routerDelegate;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: widget.currentIndex,
      builder: (ctx, value, child) => widget.bottomBarFactory.create(
        routes: routes,
        elevation: widget.elevation,
        height: widget.height,
        bgColor: widget.bgColor,
        selectedItemColor: widget.selectedItemColor,
        unselectedItemColor: widget.unselectedItemColor,
        type: widget.type,
        iconThemeData: widget.iconThemeData,
        selectedFontSize: widget.selectedFontSize,
        unselectedFontSize: widget.unselectedFontSize,
        iconSize: widget.iconSize,
        currentIndex: value,
        onTapAction: (index) {
          widget.currentIndex.value = index;
          if (widget.enableHapticFeedback) {
            HapticFeedback.selectionClick();
          }
          routerDelegate.goPage(index);
        },
      ),
    );
  }
}

/// allows to create a bottom bar styled
abstract class BartBottomBarFactory {
  const BartBottomBarFactory();

  // FIXME: remove this factory because some properties are only available
  // for Cupertino or Material
  @factory
  Widget create({
    required List<BartMenuRoute> routes,
    required BottomBarTapAction onTapAction,
    double? elevation,
    Color? bgColor,
    Border? border,
    Color? selectedItemColor,
    Color? unselectedItemColor,
    BottomNavigationBarType? type,
    IconThemeData? iconThemeData,
    double? selectedFontSize,
    double? unselectedFontSize,
    required double iconSize,
    required int currentIndex,
    double? height,
  });
}

/// Use this intent to change the current index
class BottomBarIndexIntent extends Intent {
  final int index;

  const BottomBarIndexIntent(this.index);
}

/// you can change the current index by calling
/// Actions.invoke(context, AppBarBuildIntent(AppBar(title: Text("title text"))));
class BartBottomBarIndexAction extends Action<BottomBarIndexIntent> {
  ValueNotifier<int> indexNotifier;

  BartBottomBarIndexAction(this.indexNotifier);

  @override
  void invoke(covariant BottomBarIndexIntent intent) {
    ambiguate(WidgetsBinding.instance)!.addPostFrameCallback((timeStamp) {
      indexNotifier.value = intent.index;
    });
  }
}
