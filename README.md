<p align="center">
  <img src="https://github.com/Apparence-io/bart/raw/master/.github/img/logo.jpg" alt="bart logo" width="473" height="220" />
</p>
<br><br>

<p align="center">
  <a href="https://github.com/Apparence-io/bart/actions"><img src="https://img.shields.io/github/workflow/status/Apparence-io/bart/main" alt="build"></a>
  <a href="https://codecov.io/gh/Apparence-io/bart"><img src="https://codecov.io/gh/Apparence-io/bart/branch/master/graph/badge.svg?token=W574M0EGAW"/></a>
  <a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/license-MIT-purple.svg" alt="License: MIT"></a>
  <a href="https://pub.dev/packages/bart"><img src="https://img.shields.io/pub/v/bart" alt="pub dev bart"></a>
</p>
<br>
<hr>
<br>

## 🚀&nbsp; Overview

**Bart** is very simple solution to implement tabulation system layout with Navigator into your application.

- 📱 **Material** & **Cupertino** themes available.
- 🤝 Automatic theme **switching** between material & cupertino.
- 🛣 **Inner** routing inside tab.
- 🥷 **Parent** routing (over tabbar content).
- 😌 **Very easy** to implement.
- 🪄 Show **AppBar** on demand (automatically **animated**).
- 🚀 Create your **own bottom bar design** if you need it.
- 🗃 **Cache** route page if you need to **restore state**.

## 🧐&nbsp; Live example
<p align="center">
  <img src="https://github.com/Apparence-io/bart/raw/master/.github/img/bart_new.gif" width="889"  height="500" alt="Bart example">
</p>

## 📖&nbsp; Installation

### Install the package
```sh
flutter pub add bart
```

### Import the package
```dart
import 'package:bart/bart.dart';
```

## 🚀&nbsp; Get started

- Define in your page the routing tab
```dart
List<BartMenuRoute> subRoutes() {
  return [
    BartMenuRoute.bottomBar(
      label: "Home",
      icon: Icons.home,
      path: '/home',
      pageBuilder: (context) => PageFake(
        key: PageStorageKey<String>("home"), // this is required to enable state caching
        Colors.red,
      ),
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
    BartMenuRoute.innerRoute( // add an inner route, no item will be added in bottom bar
      path: '/subpage',
      pageBuilder: (context) =>
          PageFake(Colors.greenAccent, child: Text("Sub Route page")),
    ),
  ];
}
```

<details>
  <summary>What are the differences between innerRoute & bottomBar ?</summary>
  <p>
  This creates a route with a bottom menu item:

  ```dart
  BartMenuRoute.bottomBar(...)
  ```

  This creates a route that you can push within your scaffold body (no extra item will be added in bottom bar) 
  ```dart
  BartMenuRoute.innerRoute(...)
  ```
  </p>
</details>

- Create your main page which include the Bart tabbar Scaffold
```dart
class MainPageMenu extends StatelessWidget {
  const MainPageMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BartScaffold(
      routesBuilder: subRoutes, // add a reference to the subRoutes list you created before
      bottomBar: BartBottomBar.adaptive(), // add the bottom bar (see below for other options)
    );
  }
}
```

## 🏞&nbsp; Bottom bar themes
Bart include 4 ways to display a bottom bar:

```dart
BartBottomBar.cupertino() // iOS look.
BartBottomBar.material() // Android look.
BartBottomBar.adaptive() // automatically select between cupertino & material depending on the device.
BartBottomBar.custom() // your how design
```

To custom the bottom bar, simply extends ```BartBottomBarFactory``` and create your own bottom bar like ```BartMaterialBottomBar```. <br/>

## 🗃&nbsp; State caching

### How it works 🤔 ?

Imagine you got a page with a **counter**. You **increment** this counter and **change tab**. You want this tab to come back with the **incremented counter**?.

Bart include a **caching system** to implement this feature.

By **default** state caching is enabled. But you can override it:
```dart
BartMenuRoute.bottomBar(cache: false)
```

### How to use it 🤓 ?

Your tab pages you want to be cached must use a ```PageStorageKey``` property:

```dart 
BartMenuRoute.bottomBar(
  label: "Library",
  icon: Icons.video_library_rounded,
  path: '/library',
  pageBuilder: (context, settings) => PageFake(
    key: PageStorageKey<String>("library"), // add this property
    child: Text('Cached page !'),
  ),
```

## 🗃&nbsp; Show/Hide animated AppBar
You can show an animated AppBar or hide it whenever you want inside all your **Bart** sub pages. 
> AppBar will automatically shows or hide with a smooth animation

Simply add the **AppBarNotifier** mixin like this:
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

To hide app bar, just execute this code inside your widget with **AppBarNotifier**
```dart
hideAppBar(context);
``` 

> You can also use **Actions** to performs AppBar related actions
```dart
Actions.invoke(context, AppBarBuildIntent(AppBar(title: Text("title text"))));
Actions.invoke(context,AppBarAnimationIntent.show());
Actions.invoke(context,AppBarAnimationIntent.hide());
```

## 💫&nbsp; Transitions between items
You can use the official [**animation plugin**](https://pub.dev/packages/animations) to create better transition or create your owns. 

Example: 
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

## 📣&nbsp; Sponsor
<img src="https://github.com/Apparence-io/bart/raw/master/.github/img/apparence_logo.png" alt="logo apparence io" height="58" width="400" />
<br />
<br />

[Initiated and sponsored by Apparence.io.](https://apparence.io)

## 👥&nbsp; Contribution

Contributions are welcome.
Contribute by creating a PR or create an issue 🎉.
