<p align="center">
<a href="https://github.com/Apparence-io/bart/actions"><img src="https://img.shields.io/github/workflow/status/Apparence-io/bart/main" alt="build"></a>
<a href="https://codecov.io/gh/Apparence-io/bart"><img src="https://codecov.io/gh/Apparence-io/bart/branch/master/graph/badge.svg?token=W574M0EGAW"/></a>
<a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/license-MIT-purple.svg" alt="License: MIT"></a>
<a href="https://pub.dev/packages/bart"><img src="https://img.shields.io/pub/v/bart" alt="pub dev bart"></a>
</p>

# **Bart** - A scaffold powered by Navigator2 
<a href="https://en.apparence.io"><img src="https://github.com/Apparence-io/bart/raw/master/.github/img/logo.png" alt="Apparence.io logo"></a>
<p><small>Developed with 💙 &nbsp;by Apparence.io</small></p>

## Tldr - features?
* bottom navigation bar using sub router for switching tabs within the body
* easy integration
* show AppBar on demand within your nested routes (automatically animated)
* basic material bottom bar factory
* create your own bottom bar design if you need it
* cache route page if you need to restore state

<p align="center">
<img src="https://github.com/Apparence-io/bart/raw/master/.github/img/bart.gif" width="230" alt="Apparence.io logo">
</p>

## Install 
Add Bart in your pubspec and import it. 
```dart
import 'package:bart/bart.dart';
```

## Get started 

### Create your routes 

```dart
List<BartMenuRoute> subRoutes() {
  return [
    BartMenuRoute.bottomBar(
      label: "Home",
      icon: Icons.home,
      path: '/home',
      pageBuilder: (context) => PageFake(Colors.red),
    ),
    BartMenuRoute.bottomBar(
      label: "Library",
      icon: Icons.video_library_rounded,
      path: '/library',
      pageBuilder: (context) => PageFake(Colors.blueGrey),
    ),
    BartMenuRoute.bottomBar(
      label: "Profile",
      icon: Icons.person,
      path: '/profile',
      pageBuilder: (context) => PageFake(Colors.yellow),
    ),
    BartMenuRoute.innerRoute(
      path: '/subpage',
      pageBuilder: (context) =>
          PageFake(Colors.greenAccent, child: Text("Sub Route page")),
    ),
  ];
}
```

This creates a route with a bottom menu item
```dart
BartMenuRoute.bottomBar(...)
```

This creates a route that you can push within your scaffold body 
```dart
BartMenuRoute.innerRoute(...)
```

### Enable disable route caching

#### Why?
Imagine you got a page with a counter. You increment this counter and change tab. You want this tab to come back with the incremented counter? That's the reason why you need cache. 

#### How
**By default BartMenuRoute bottomBar factory is cached**. But you can override it.
```dart
BartMenuRoute.bottomBar(cache: true)
```

#### How to use it?
1 - let cache as active
2 - your tab pages must use a ```PageStorageKey```

Example 
```dart 
BartMenuRoute.bottomBar(
    label: "Library",
    icon: Icons.video_library_rounded,
    path: '/library',
    cache: true,
    pageBuilder: (context, settings) => PageFake(
        Colors.blueGrey.shade100,
        rebuildAfterDisposed: false,
        key: PageStorageKey<String>("library"),
    ),
```


**By default BartMenuRoute innerRoute factory is NOT cached**. But you can override it.
```dart
BartMenuRoute.bottomBar(cache: false)
```

## Create your page 
```dart
class MainPageMenu extends StatelessWidget {
  final BartRouteBuilder routesBuilder;

  const MainPageMenu({Key? key, required this.routesBuilder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BartScaffold(
      routesBuilder: routesBuilder,
      navigatorObservers: [routeObserver],
      bottomBar: BartBottomBar.fromFactory(
        bottomBarFactory: BartMaterialBottomBar.bottomBarFactory,
      ),
    );
  }
}
```

## Customize your bottom bar
Default behavior is using material standart theme but you can create yours.<br/>
Simply extends BartBottomBarFactory and create your own bottom bar like BartMaterialBottomBar. <br/>
See code in library.

## Show an AppBar 
You can show an AppBar or hide it whenever you want inside BartScaffold subPages. 
> Appbar will automatically shows or hide with a smooth animation

Using mixin method 
```dart
class MyPage extends StatelessWidget with AppBarNotifier {
  const MyPage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // use the update app bar method to dynamically change app bar  
    updateAppBar(context, AppBar(title: Text("test")));
    // now call you can call show method that will start animation
    showAppBar(context);
    return Container();
  }
}
``` 
Also you can hide AppBar with a smooth animation using this method from mixin (for example when user scroll down a list)
```dart 
hideAppBar(context);
``` 

or directly using Actions methods
```dart
Actions.invoke(context, AppBarBuildIntent(AppBar(title: Text("title text"))));
Actions.invoke(context,AppBarAnimationIntent.show());
Actions.invoke(context,AppBarAnimationIntent.hide());
```

## Handle transition
You can use the official animation plugin to create better transition or create your owns. 

Ex using animation package: 
```dart
BartMenuRoute.bottomBar(
  label: "Library",
  icon: Icons.video_library_rounded,
  path: '/library',
  pageBuilder: (context, settings) => PageFake(Colors.blueGrey),
  transitionDuration: Duration(milliseconds: 500),
  transitionsBuilder: (context, anim1, anim2, widget) => FadeThroughTransition(
    animation: anim1,
    secondaryAnimation: anim2,
    child: widget,
  ),
),
```