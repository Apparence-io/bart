import 'package:bart/bart/widgets/side_bar/custom_sidebar.dart';

enum Gravity {
  /// shows the sidebar on the left side of the screen
  left,

  /// shows the sidebar on the right side of the screen
  right,
}

sealed class SideBarOptions {
  final Gravity gravity;

  SideBarOptions({
    this.gravity = Gravity.left,
  });
}

class CustomSideBarOptions extends SideBarOptions {
  final SideBarBuilder sideBarBuilder;

  CustomSideBarOptions({
    required this.sideBarBuilder,
    Gravity gravity = Gravity.left,
  }) : super(gravity: gravity);
}

class RailSideBarOptions extends SideBarOptions {
  final bool extended;

  RailSideBarOptions({
    this.extended = false,
    Gravity gravity = Gravity.left,
  }) : super(gravity: gravity);
}
