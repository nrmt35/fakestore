import 'dart:collection';

import 'package:flutter/widgets.dart';

typedef DidStartUserGestureCallback = void Function(
  Route<dynamic> route,
  Route<dynamic>? previousRoute,
);

class NavigatorHistoryObserver extends NavigatorObserver with ChangeNotifier {
  final List<Route<dynamic>> _routeStack = [];
  late final List<Route<dynamic>> _unmodifiableView;

  final DidStartUserGestureCallback? __didStartUserGesture;
  final VoidCallback? __didStopUserGesture;

  NavigatorHistoryObserver({
    DidStartUserGestureCallback? didStartUserGesture,
    VoidCallback? didStopUserGesture,
  })  : __didStartUserGesture = didStartUserGesture,
        __didStopUserGesture = didStopUserGesture {
    _unmodifiableView = UnmodifiableListView(_routeStack);
  }

  List<Route<dynamic>> get navigatorStack => _unmodifiableView;

  void _removeRouteFromStack(Route<dynamic> route) {
    //route can't be present twice on stack, thus search only first match
    /*final foundIdx = _routeStack.indexWhere((r) => identical(r, route));*/
    final foundIdx = _routeStack.indexOf(route);
    assert(foundIdx != -1);
    if (foundIdx == -1) {
      //WTF??
      return;
    }
    _routeStack.removeAt(foundIdx);
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _routeStack.add(route);
    notifyListeners();
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _removeRouteFromStack(route);
    notifyListeners();
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _removeRouteFromStack(route);
    notifyListeners();
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (oldRoute == null) {
      if (newRoute != null) {
        // Add the route to the top?
        _routeStack.add(newRoute);
      }
      return;
    }

    // Probably never happens, but anyway..
    if (newRoute == null) {
      _removeRouteFromStack(oldRoute);
      return;
    }

    //route can't be present twice on stack, thus search only first match
    /*final foundIdx = _routeStack.indexWhere((r) => identical(r, oldRoute));*/
    final foundIdx = _routeStack.indexOf(oldRoute);
    if (foundIdx == -1) {
      // Add the route to the top?
      _routeStack.add(newRoute);
    } else {
      _routeStack[foundIdx] = newRoute;
    }
    notifyListeners();
  }

  @override
  void didStartUserGesture(Route<dynamic> route, Route<dynamic>? previousRoute) {
    __didStartUserGesture?.call(route, previousRoute);
  }

  @override
  void didStopUserGesture() {
    __didStopUserGesture?.call();
  }
}
