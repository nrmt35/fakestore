import 'dart:async';

import 'package:flutter/material.dart';

void showSnack(
  BuildContext context, {
  required String text,
  Color color = Colors.red,
}) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 5),
      backgroundColor: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      content: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );
}

/// Scaffold messenger key
final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

const Color _kCupertinoPageTransitionBarrierColor = Color(0x18000000);
const Color _kCupertinoModalBarrierColorLight = Color(0x33000000);
// ignore: unused_element
const Color _kCupertinoModalBarrierColorDark = Color(0x7A000000);

extension NavigatorX on NavigatorState {
  bool isCurrentRouteFirst() {
    return currentRoute()?.isFirst ?? false;
  }

  Route<dynamic>? currentRoute() {
    Route<dynamic>? current;
    popUntil((route) {
      current = route;
      return true;
    });
    return current;
  }
}

class MaterialPageRouteWithBarrier<T> extends MaterialPageRoute<T> {
  MaterialPageRouteWithBarrier({
    required super.builder,
    super.settings,
    super.maintainState = true,
    super.fullscreenDialog,
    super.allowSnapshotting = true,
  });

  @override
  Color? get barrierColor => fullscreenDialog //
      ? _kCupertinoModalBarrierColorLight
      : _kCupertinoPageTransitionBarrierColor;
}

Future<T?> navigateToScreen<T extends Object?>(
  BuildContext context,
  Widget screen, {
  bool fullscreenDialog = false,
  bool rootNavigator = false,
  //
  bool replaceCurrent = false,
  String? routeName,
}) {
  if (replaceCurrent) {
    return Navigator.of(context, rootNavigator: rootNavigator).pushReplacement<T?, dynamic>(
      MaterialPageRouteWithBarrier<T?>(
        builder: (context) => screen,
        fullscreenDialog: fullscreenDialog,
        //
        settings: routeName != null //
            ? RouteSettings(name: routeName)
            : null,
      ),
    );
  } else {
    return Navigator.of(context, rootNavigator: rootNavigator).push<T?>(
      MaterialPageRouteWithBarrier<T?>(
        builder: (context) => screen,
        fullscreenDialog: fullscreenDialog,
        //
        settings: routeName != null //
            ? RouteSettings(name: routeName)
            : null,
      ),
    );
  }
}

Future<T?> replaceRootScreen<T extends Object?>(BuildContext context, Widget screen) {
  return Navigator.of(context, rootNavigator: true).pushAndRemoveUntil<T?>(
    MaterialPageRouteWithBarrier<T?>(
      builder: (context) => screen,
    ),
    (route) => false,
  );
}

Future<T?> navigateToScreenAndRemoveUntil<T extends Object?>(
  BuildContext context,
  Widget screen,
  RoutePredicate predicate, {
  bool fullscreenDialog = false,
  bool rootNavigator = false,
}) {
  return Navigator.of(context, rootNavigator: rootNavigator).pushAndRemoveUntil<T?>(
    MaterialPageRouteWithBarrier<T?>(
      builder: (context) => screen,
      fullscreenDialog: fullscreenDialog,
    ),
    predicate,
  );
}

void showErrorSnackBar(String message, {SnackBarAction? action}) {
  showSnackBar(message, action: action, color: Colors.red);
}

void showSnackBar(String message, {SnackBarAction? action, Color? color}) {
  final scaffoldMessenger = scaffoldMessengerKey.currentState;
  if (scaffoldMessenger == null) {
    assert(false, 'ScaffoldMessenger not initiated');

    return;
  }

  scaffoldMessenger
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: color,
        action: action,
        content: Text(message),
      ),
    );
}
