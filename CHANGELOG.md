## [2.0.0]

**Breaking** — bart now builds on the `material_ui` / `cupertino_ui` packages
instead of `package:flutter/material.dart` and `package:flutter/cupertino.dart`,
following the Flutter 3.44+ split of Material and Cupertino out of the framework.

### Why this is breaking

The Flutter SDK still ships its own complete Material library, so
`flutter/src/material/material.dart#Material` and
`material_ui/src/material.dart#Material` are two *distinct* Dart types that both
print as `Material`. Material lookups match on the exact runtime type
(`debugCheckHasMaterial` uses `findAncestorWidgetOfExactType<Material>`), so a
`Scaffold` from one library can never satisfy an `InkWell` from the other.

Apps on `material_ui` that mounted a `BartScaffold` therefore hit
`No Material widget found.` on every `InkWell`, `Ink`, `ListTile`, `TextField`,
`IconButton`, `Chip`, `TabBar` (and friends) inside a tab — in debug via the
assertion, and in release too for `Ink`, which resolves `Material.of` during
build. The same applied one layer down to `CupertinoTabBar`, which needs the
`CupertinoLocalizations` of whichever cupertino library declares it.

### Migrating

- Your app must now depend on `material_ui` and import
  `package:material_ui/material_ui.dart` rather than
  `package:flutter/material.dart`. Mixing the two in one widget tree reproduces
  the bug in the opposite direction.
- `enum Theme` is renamed to `enum BartBottomBarStyle`. The old name collided
  with material_ui's `Theme` widget whenever `package:bart/bart.dart` was
  imported without a prefix. The `BartBottomBar.material()` / `.material3()` /
  `.cupertino()` / `.adaptive()` / `.custom()` factories are unchanged, so most
  apps need no edit here.
- Minimum constraints raised to Dart 3.12 / Flutter 3.44.

### Also in this release

- Files that never needed Material now import `package:flutter/widgets.dart`
  directly, so bart no longer leaks a Material dependency into parts of its API
  that do not use one.
- Added `test/material_ancestor_test.dart`, which mounts material_ui `InkWell`,
  `Ink` and `ListTile` inside a bart tab and asserts no Material assertion is
  raised, plus a Cupertino localizations case. These fail on 1.x and pass on 2.0.0.

## [1.4.0]

- add BartMenuRoute.bottomBarBuilder isActive property to builder

## [1.3.0]

- NavigationRail sidebar or custom sidebar is now available

## [1.2.1]

- Fix prevent rebuilding bottom items when route change

## [1.2.0]

- Add BartMenuRoute.bottomBarBuilder to build a single item bottom bar (so you
  can show notification badge on it)
- Add onRouteChanged callback to BartScaffold to get notified when route change

## [1.1.0]

- Material 3 bottom bar theme
- Hide / show bottom bar from action

## [1.0.0]

- enable hot reload
- parent context is now available
- will pop scope is now supported
- nested route can be canceled by tapping on parent tab item
- rework how Bart work to improve stability & performance

## [0.3.1]

- upgrade android example project

## [0.3.0]

- preserve state and scroll within navigation if cache activated

## [0.2.0]

- remove unnecessary null check

## [0.1.1] - Transitions

- handle transition for routes (optionnal) default is none
- handle transition duration for routes (optionnal) default is 300ms

## [0.1.0] - Add settings to page build

- add args setting to sub navigation

## [0.0.3] - Cache and Appbar animation

- show or hide appbar with animation
- preserve page in cache (see readme)

## [0.0.1] - First release

- first release
