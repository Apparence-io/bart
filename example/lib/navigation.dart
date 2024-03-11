import 'package:bart/bart.dart';
import 'package:example/routes.dart';
import 'package:example/widgets/simple_bottom_bar.dart';
import 'package:flutter/material.dart';

class MainPageMenu extends StatelessWidget {
  const MainPageMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth;

      /// This is an example on how you can handle sidebar for different screen sizes
      if (width > 750) {
        /// this will use the NavigationRail sidebar from Material
        /// If you want to build your own sidebar, you can use the [CustomSideBarOptions]
        return BartScaffold(
          routesBuilder: subRoutes,
          initialRoute: '/library',
          showBottomBarOnStart: true,
          bottomBar: BartBottomBar.material3(),
          sideBarOptions: RailSideBarOptions(
            extended: width > 1250,
          ),
        );
      } else {
        /// this will create a navigation bar at the bottom of the screen
        /// Using cupertino or material depending on the platform
        return BartScaffold(
          routesBuilder: subRoutes,
          showBottomBarOnStart: true,
          // bottomBar: BartBottomBar.adaptive(),
          // uncomment to use an exemple of custom bottom bar
          bottomBar: BartBottomBar.custom(
            bottomBarFactory: SimpleBottomBar(),
          ),
        );
      }
    });
  }
}
