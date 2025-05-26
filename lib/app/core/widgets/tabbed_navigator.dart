import 'package:flutter/material.dart';

import 'tab_switching_view.dart';

/// Implements a tabbed application's root layout and behavior structure.
///
/// A [tabCount], [tabBuilder] and a [controller] are required.
///
/// A [controller] can be used to provide an initially selected tab index and manage
/// subsequent tab changes. If a controller is not specified, the scaffold will
/// create its own [MaterialTabController] and manage it internally. Otherwise
/// it's up to the owner of [controller] to call `dispose` on it after finish
/// using it.
///
/// Tabs' contents are built with the provided [tabBuilder] at the active
/// tab index. The [tabBuilder] must be able to build the same number of
/// pages as [tabCount]. Inactive tabs will be moved [Offstage]
/// and their animations disabled.
///
/// Adding/removing tabs, or changing the order of tabs is supported but not
/// recommended. Doing so is against the Material human interface guidelines, and
/// [MaterialTabNavigator] may lose some tabs' state in the process.
///
/// Use [MaterialTabView] as the root widget of each tab to support tabs with
/// parallel navigation state and history. Since each [MaterialTabView] contains
/// a [Navigator], rebuilding the [MaterialTabView] with a different
/// [WidgetBuilder] instance in [MaterialTabView.builder] will not recreate
/// the [MaterialTabView]'s navigation stack or update its UI. To update the
/// contents of the [MaterialTabView] after it's built, trigger a rebuild
/// (via [State.setState], for instance) from its descendant rather than from
/// its ancestor.
///
/// {@tool dartpad}
/// A sample code implementing a typical architecture with tabs.
///
/// ** See code in examples/api/lib/cupertino/tab_scaffold/cupertino_tab_scaffold.0.dart **
/// {@end-tool}
///
/// To push a route above all tabs instead of inside the currently selected one
/// (such as when showing a dialog on top of this scaffold), use
/// `Navigator.of(rootNavigator: true)` from inside the [BuildContext] of a
/// [MaterialTabView].
///
/// See also:
///
///  * [BottomNavigationBar], the bottom tab bar inserted in the scaffold.
///  * [MaterialTabController], the selection state of this widget.
///  * [MaterialTabView], the typical root content of each tab that holds its own
///    [Navigator] stack.
///  * [MaterialPageRoute], a route hosting modal pages.
///  * [Scaffold], typical contents of an modal page.
class MaterialTabNavigator extends StatefulWidget {
  /// Creates a layout for applications with a tab bar at the bottom.
  MaterialTabNavigator({
    super.key,
    required this.tabBuilder,
    required this.controller,
    required this.tabCount,
    this.tabSwitchFadeDuration = const Duration(milliseconds: 150),
    this.resizeToAvoidBottomInset = true,
    this.restorationId,
  }) : assert(
          controller == null || controller.index < tabCount,
          "The MaterialTabController's current index ${controller.index} is "
          'out of bounds for the tab bar with $tabCount tabs',
        );

  //TODO: doc
  final Duration tabSwitchFadeDuration;

  //TODO: doc
  final int tabCount;

  /// Controls the currently active tab index of the [tabBuilder].
  /// Providing a different [controller] will also update current active
  /// index to the new controller's index value.
  final MaterialTabController controller;

  /// An [IndexedWidgetBuilder] that's called when tabs become active.
  ///
  /// The widgets built by [IndexedWidgetBuilder] are typically a
  /// [MaterialTabView] in order to achieve the parallel hierarchical
  /// information architecture with tab bars.
  ///
  /// When the tab becomes inactive, its content is cached in the widget tree
  /// [Offstage] and its animations disabled.
  final IndexedWidgetBuilder tabBuilder;

  /// Whether the body should size itself to avoid the window's bottom inset.
  ///
  /// For example, if there is an onscreen keyboard displayed above the
  /// scaffold, the body can be resized to avoid overlapping the keyboard, which
  /// prevents widgets inside the body from being obscured by the keyboard.
  ///
  /// Defaults to true.
  final bool resizeToAvoidBottomInset;

  /// Restoration ID to save and restore the state of the [MaterialTabNavigator].
  ///
  /// This property only has an effect when no [controller] has been provided:
  /// If it is non-null (and no [controller] has been provided), the scaffold
  /// will persist and restore the currently selected tab index. If a
  /// [controller] has been provided, it is the responsibility of the owner of
  /// that controller to persist and restore it, e.g. by using a
  /// [RestorableMaterialTabController].
  ///
  /// The state of this widget is persisted in a [RestorationBucket] claimed
  /// from the surrounding [RestorationScope] using the provided restoration ID.
  ///
  /// See also:
  ///
  ///  * [RestorationManager], which explains how state restoration works in
  ///    Flutter.
  final String? restorationId;

  @override
  State<MaterialTabNavigator> createState() => _MaterialTabNavigatorState();
}

class _MaterialTabNavigatorState extends State<MaterialTabNavigator> with RestorationMixin {
  RestorableMaterialTabController? _internalController;

  MaterialTabController get _controller => widget.controller ?? _internalController!.value;

  @override
  String? get restorationId => widget.restorationId;

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    _restoreInternalController();
  }

  void _restoreInternalController() {
    if (_internalController != null) {
      registerForRestoration(_internalController!, 'controller');
      _internalController!.value.addListener(_onCurrentIndexChange);
    }
  }

  @override
  void initState() {
    super.initState();
    _updateTabController();
  }

  void _updateTabController([MaterialTabController? oldWidgetController]) {
    if (widget.controller == null && _internalController == null) {
      // No widget-provided controller: create an internal controller.
      _internalController =
          RestorableMaterialTabController(initialIndex: 0 /*TODO widget.tabBar.currentIndex*/);
      if (!restorePending) {
        _restoreInternalController(); // Also adds the listener to the controller.
      }
    }
    if (widget.controller != null && _internalController != null) {
      // Use the widget-provided controller.
      unregisterFromRestoration(_internalController!);
      _internalController!.dispose();
      _internalController = null;
    }
    if (oldWidgetController != widget.controller) {
      // The widget-provided controller has changed: move listeners.
      if (oldWidgetController?._isDisposed == false) {
        oldWidgetController!.removeListener(_onCurrentIndexChange);
      }
      widget.controller?.addListener(_onCurrentIndexChange);
    }
  }

  void _onCurrentIndexChange() {
    assert(
      _controller.index >= 0 && _controller.index < widget.tabCount,
      "The $runtimeType's current index ${_controller.index} is "
      'out of bounds for the tab bar with ${widget.tabCount} tabs',
    );

    // The value of `_controller.index` has already been updated at this point.
    // Calling `setState` to rebuild using `_controller.index`.
    setState(() {
      //no-op
    });
  }

  @override
  void didUpdateWidget(MaterialTabNavigator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      _updateTabController(oldWidget.controller);
    } else if (_controller.index >= widget.tabCount) {
      // If a new [tabCount] with less than (_controller.index + 1) items is provided,
      // clamp the current index.
      _controller.index = widget.tabCount - 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TabSwitchingView(
      currentTabIndex: _controller.index,
      tabCount: widget.tabCount,
      tabBuilder: widget.tabBuilder,
      fadeDuration: widget.tabSwitchFadeDuration,
    );
  }

  @override
  void dispose() {
    if (widget.controller?._isDisposed == false) {
      _controller.removeListener(_onCurrentIndexChange);
    }
    _internalController?.dispose();
    super.dispose();
  }
}

/// Coordinates tab selection for a [MaterialTabNavigator].
///
/// The [index] property is the index of the selected tab. Changing its value
/// updates the actively displayed tab of the [MaterialTabNavigator] the
/// [MaterialTabController] controls.
///
/// {@tool snippet}
/// This samples shows how [MaterialTabController] can be used to switch tabs in
/// [MaterialTabNavigator].
///
/// ** See code in examples/api/lib/cupertino/tab_scaffold/cupertino_tab_controller.0.dart **
/// {@end-tool}
///
/// See also:
///
///  * [MaterialTabNavigator], a tabbed application root layout that can be
///    controlled by a [MaterialTabController].
///  * [RestorableMaterialTabController], which is a restorable version
///    of this controller.
class MaterialTabController extends ChangeNotifier {
  /// Creates a [MaterialTabController] to control the tab index of [MaterialTabNavigator].
  ///
  /// The [initialIndex] defaults to 0. The value must be greater than or equal
  /// to 0, and less than the total number of tabs.
  MaterialTabController({int initialIndex = 0})
      : _index = initialIndex,
        assert(initialIndex >= 0);

  bool _isDisposed = false;

  /// The index of the currently selected tab.
  ///
  /// Changing the value of [index] updates the actively displayed tab of the
  /// [MaterialTabNavigator] controlled by this [MaterialTabController].
  ///
  /// The value must be greater than or equal to 0, and less than the total
  /// number of tabs.
  int get index => _index;
  int _index;

  set index(int value) {
    assert(value >= 0);
    if (_index == value) {
      return;
    }
    _index = value;
    notifyListeners();
  }

  @mustCallSuper
  @override
  void dispose() {
    super.dispose();
    _isDisposed = true;
  }
}

/// A [RestorableProperty] that knows how to store and restore a
/// [MaterialTabController].
///
/// The [MaterialTabController] is accessible via the [value] getter. During
/// state restoration, the property will restore [MaterialTabController.index]
/// to the value it had when the restoration data it is getting restored from
/// was collected.
class RestorableMaterialTabController extends RestorableChangeNotifier<MaterialTabController> {
  /// Creates a [RestorableMaterialTabController] to control the tab index of
  /// [MaterialTabNavigator].
  ///
  /// The `initialIndex` defaults to zero. The value must be greater than or
  /// equal to zero, and less than the total number of tabs.
  RestorableMaterialTabController({int initialIndex = 0})
      : assert(initialIndex >= 0),
        _initialIndex = initialIndex;

  final int _initialIndex;

  @override
  MaterialTabController createDefaultValue() {
    return MaterialTabController(initialIndex: _initialIndex);
  }

  @override
  MaterialTabController fromPrimitives(Object? data) {
    assert(data != null);
    return MaterialTabController(initialIndex: data! as int);
  }

  @override
  Object? toPrimitives() {
    return value.index;
  }
}

/// A single tab view with its own [Navigator] state and history.
///
/// A typical tab view is used as the content of each tab in a
/// [MaterialTabNavigator] where multiple tabs with parallel navigation states
/// and history can co-exist.
///
/// [MaterialTabView] configures the top-level [Navigator] to search for routes
/// in the following order:
///
///  1. For the `/` route, the [builder] property, if non-null, is used.
///
///  2. Otherwise, the [routes] table is used, if it has an entry for the route,
///     including `/` if [builder] is not specified.
///
///  3. Otherwise, [onGenerateRoute] is called, if provided. It should return a
///     non-null value for any _valid_ route not handled by [builder] and [routes].
///
///  4. Finally if all else fails [onUnknownRoute] is called.
///
/// These navigation properties are not shared with any sibling [MaterialTabView]
/// nor any ancestor or descendant [Navigator] instances.
///
/// To push a route above this [MaterialTabView] instead of inside it (such
/// as when showing a dialog on top of all tabs), use
/// `Navigator.of(rootNavigator: true)`.
///
/// See also:
///
///  * [MaterialTabNavigator], a typical host that supports switching between tabs.
///  * [MaterialPageRoute], a typical modal page route pushed onto the
///    [MaterialTabView]'s [Navigator].
class MaterialTabView extends StatefulWidget {
  /// Creates the content area for a tab in a [MaterialTabNavigator].
  const MaterialTabView({
    super.key,
    this.builder,
    this.navigatorKey,
    this.routes,
    this.onGenerateRoute,
    this.onUnknownRoute,
    this.navigatorObservers = const <NavigatorObserver>[],
    this.restorationScopeId,
  });

  /// The widget builder for the default route of the tab view
  /// ([Navigator.defaultRouteName], which is `/`).
  ///
  /// If a [builder] is specified, then [routes] must not include an entry for `/`,
  /// as [builder] takes its place.
  ///
  /// Rebuilding a [MaterialTabView] with a different [builder] will not clear
  /// its current navigation stack or update its descendant. Instead, trigger a
  /// rebuild from a descendant in its subtree. This can be done via methods such
  /// as:
  ///
  ///  * Calling [State.setState] on a descendant [StatefulWidget]'s [State]
  ///  * Modifying an [InheritedWidget] that a descendant registered itself
  ///    as a dependent to.
  final WidgetBuilder? builder;

  /// A key to use when building this widget's [Navigator].
  ///
  /// If a [navigatorKey] is specified, the [Navigator] can be directly
  /// manipulated without first obtaining it from a [BuildContext] via
  /// [Navigator.of]: from the [navigatorKey], use the [GlobalKey.currentState]
  /// getter.
  ///
  /// If this is changed, a new [Navigator] will be created, losing all the
  /// tab's state in the process; in that case, the [navigatorObservers]
  /// must also be changed, since the previous observers will be attached to the
  /// previous navigator.
  final GlobalKey<NavigatorState>? navigatorKey;

  /// This tab view's routing table.
  ///
  /// When a named route is pushed with [Navigator.pushNamed] inside this tab view,
  /// the route name is looked up in this map. If the name is present,
  /// the associated [WidgetBuilder] is used to construct a [MaterialPageRoute]
  /// that performs an appropriate transition to the new route.
  ///
  /// If the tab view only has one page, then you can specify it using [builder] instead.
  ///
  /// If [builder] is specified, then it implies an entry in this table for the
  /// [Navigator.defaultRouteName] route (`/`), and it is an error to
  /// redundantly provide such a route in the [routes] table.
  ///
  /// If a route is requested that is not specified in this table (or by
  /// [builder]), then the [onGenerateRoute] callback is called to build the page
  /// instead.
  ///
  /// This routing table is not shared with any routing tables of ancestor or
  /// descendant [Navigator]s.
  final Map<String, WidgetBuilder>? routes;

  /// The route generator callback used when the tab view is navigated to a named route.
  ///
  /// This is used if [routes] does not contain the requested route.
  final RouteFactory? onGenerateRoute;

  /// Called when [onGenerateRoute] also fails to generate a route.
  ///
  /// This callback is typically used for error handling. For example, this
  /// callback might always generate a "not found" page that describes the route
  /// that wasn't found.
  ///
  /// The default implementation pushes a route that displays an ugly error
  /// message.
  final RouteFactory? onUnknownRoute;

  /// The list of observers for the [Navigator] created in this tab view.
  ///
  /// This list of observers is not shared with ancestor or descendant [Navigator]s.
  final List<NavigatorObserver> navigatorObservers;

  /// Restoration ID to save and restore the state of the [Navigator] built by
  /// this [MaterialTabView].
  ///
  /// {@macro flutter.widgets.navigator.restorationScopeId}
  final String? restorationScopeId;

  @override
  State<MaterialTabView> createState() => _MaterialTabViewState();
}

class _MaterialTabViewState extends State<MaterialTabView> {
  late HeroController _heroController;
  late List<NavigatorObserver> _navigatorObservers;

  @override
  void initState() {
    super.initState();
    _heroController = MaterialApp.createMaterialHeroController();
    _updateObservers();
  }

  @override
  void didUpdateWidget(MaterialTabView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.navigatorKey != oldWidget.navigatorKey ||
        widget.navigatorObservers != oldWidget.navigatorObservers) {
      _updateObservers();
    }
  }

  @override
  void dispose() {
    _heroController.dispose();
    super.dispose();
  }

  void _updateObservers() {
    _navigatorObservers = List<NavigatorObserver>.of(widget.navigatorObservers)
      ..add(_heroController);
  }

  GlobalKey<NavigatorState>? _ownedNavigatorKey;

  GlobalKey<NavigatorState> get _navigatorKey {
    if (widget.navigatorKey != null) {
      return widget.navigatorKey!;
    }
    _ownedNavigatorKey ??= GlobalKey<NavigatorState>();
    return _ownedNavigatorKey!;
  }

  // Whether this tab is currently the active tab.
  bool get _isActive => TickerMode.of(context);

  @override
  Widget build(BuildContext context) {
    final Widget child = Navigator(
      key: _navigatorKey,
      onGenerateRoute: _onGenerateRoute,
      onUnknownRoute: _onUnknownRoute,
      observers: _navigatorObservers,
      restorationScopeId: widget.restorationScopeId,
    );

    // Handle system back gestures only if the tab is currently active.
    return NavigatorPopHandler(
      enabled: _isActive,
      onPop: () {
        if (!_isActive) {
          return;
        }
        _navigatorKey.currentState!.maybePop();
      },
      child: child,
    );
  }

  Route<dynamic>? _onGenerateRoute(RouteSettings settings) {
    final String? name = settings.name;
    final WidgetBuilder? routeBuilder;
    if (name == Navigator.defaultRouteName && widget.builder != null) {
      routeBuilder = widget.builder;
    } else {
      routeBuilder = widget.routes?[name];
    }
    if (routeBuilder != null) {
      return MaterialPageRoute<dynamic>(
        builder: routeBuilder,
        settings: settings,
      );
    }
    return widget.onGenerateRoute?.call(settings);
  }

  Route<dynamic>? _onUnknownRoute(RouteSettings settings) {
    assert(() {
      if (widget.onUnknownRoute == null) {
        throw FlutterError(
          'Could not find a generator for route $settings in the $runtimeType.\n'
          'Generators for routes are searched for in the following order:\n'
          ' 1. For the "/" route, the "builder" property, if non-null, is used.\n'
          ' 2. Otherwise, the "routes" table is used, if it has an entry for '
          'the route.\n'
          ' 3. Otherwise, onGenerateRoute is called. It should return a '
          'non-null value for any valid route not handled by "builder" and "routes".\n'
          ' 4. Finally if all else fails onUnknownRoute is called.\n'
          'Unfortunately, onUnknownRoute was not set.',
        );
      }
      return true;
    }());
    final Route<dynamic>? result = widget.onUnknownRoute!(settings);
    assert(() {
      if (result == null) {
        throw FlutterError(
          'The onUnknownRoute callback returned null.\n'
          'When the $runtimeType requested the route $settings from its '
          'onUnknownRoute callback, the callback returned null. Such callbacks '
          'must never return null.',
        );
      }
      return true;
    }());
    return result;
  }
}
