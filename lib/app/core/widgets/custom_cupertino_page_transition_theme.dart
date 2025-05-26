import 'package:flutter/material.dart' show PageTransitionsBuilder, CupertinoPageTransitionsBuilder;
import 'package:flutter/widgets.dart';

import 'custom_cupertino_page_route.dart';

/// Calculates width of area where back swipe gesture is accepted
/// in logical pixels
/// (optionally) based on the screen size
typedef BackGestureWidthGetter = double Function(ValueGetter<Size>);

/// [BackGestureWidthGetter] builders
class BackGestureWidth {
  const BackGestureWidth._();

  /// Always returns same value equals to [width]
  static BackGestureWidthGetter fixed(double width) => (_) => width;

  /// Always returns a value equals to [fraction] of screen width
  static BackGestureWidthGetter fraction(double fraction) =>
      (sizeGetter) => sizeGetter().width * fraction;
}

/// Applies a [backGestureWidth] to descendant widgets.
class BackGestureWidthTheme extends InheritedWidget {
  const BackGestureWidthTheme({
    super.key,
    required this.backGestureWidth,
    required super.child,
  });

  final BackGestureWidthGetter backGestureWidth;

  static BackGestureWidthTheme? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<BackGestureWidthTheme>();
  }

  @override
  bool updateShouldNotify(BackGestureWidthTheme oldWidget) =>
      backGestureWidth != oldWidget.backGestureWidth;
}

/// This is a copy of Flutter's material [CupertinoPageTransitionsBuilder]
/// with modified version of [CupertinoPageRoute]
class CupertinoPageTransitionsBuilderCustomBackGestureWidth extends PageTransitionsBuilder {
  /// Constructs a page transition animation that matches the iOS transition.
  const CupertinoPageTransitionsBuilderCustomBackGestureWidth();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return CupertinoRouteTransitionMixin.buildPageTransitions<T>(
      route,
      context,
      animation,
      secondaryAnimation,
      child,
    );
  }
}
