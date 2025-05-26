import 'dart:async';

import 'package:fakestore/app/core/config/build_config.dart';
import 'package:fakestore/app/core/config/events.dart';
import 'package:fakestore/app/core/extensions/extensions.dart';
import 'package:fakestore/app/core/utils/navigations.dart';
import 'package:fakestore/app/core/utils/navigator_history_observer.dart';
import 'package:fakestore/app/core/widgets/size_transition.dart';
import 'package:fakestore/app/core/widgets/tabbed_navigator.dart';
import 'package:fakestore/app/presentation/bottom_navigation/view/bottom_navigation_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  CustomBottomNavigationBar(this.pages) : super(key: _globalKey);
  final List<Widget> pages;
  static final GlobalKey<CustomBottomNavigationBarState> _globalKey = GlobalKey();

  static final MaterialTabController tabController = MaterialTabController(
    initialIndex: TabItem.main.index,
  );

  static NavigatorState? get currentSelectedTabNavigator {
    final state = _globalKey.currentState;
    if (state == null) {
      return null;
    }

    final tabIndex = tabController.index;
    final navigatorState = state._tabNavigatorKeys[tabIndex].currentState;
    return navigatorState;
  }

  @override
  State<CustomBottomNavigationBar> createState() => CustomBottomNavigationBarState();
}

class CustomBottomNavigationBarState extends State<CustomBottomNavigationBar>
    with SingleTickerProviderStateMixin {
  MaterialTabController get tabController => CustomBottomNavigationBar.tabController;

  StreamSubscription<SwitchTabEvent>? _switchTabSub;
  StreamSubscription<SwitchTabAndResetEvent>? _switchTabAndResetSub;

  StreamSubscription<String?>? _fcmMessageSub;

  final _tabNavigatorKeys = List<GlobalKey<NavigatorState>>.generate(
    TabItem.values.length,
    (index) => GlobalKey<NavigatorState>(),
    growable: false,
  );
  late final List<NavigatorHistoryObserver> _tabNavigatorHistoryObservers;

  final GlobalKey _bottomNavKey = GlobalKey();

  //final ProxyAnimation _bottomNavShowAnimation = ProxyAnimation(kAlwaysCompleteAnimation);
  late final _bottomNavShowController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 220),
  );

  void _onTabSelected(TabItem newSelected) {
    final oldValue = TabItem.values[tabController.index];
    if (newSelected == oldValue) {
      final navigatorState = _tabNavigatorKeys[newSelected.index].currentState;
      if (navigatorState == null) {
        // navigator not yet created, simple ignore
        return;
      }

      if (navigatorState.isCurrentRouteFirst()) {
        _onTabReselectedInFirstRoute(newSelected);
      } else {
        if (BuildConfig.UseOptimizedTabPopMethod) {
          navigatorState.popUntil((route) => route.isFirst);
        } else {
          navigatorState.popUntil((route) => route.isFirst);
        }
      }
    } else {
      tabController.index = newSelected.index;
    }
  }

  void _selectTabAndGoToRoot(TabItem newSelected, {bool scrollToTop = false}) {
    tabController.index = newSelected.index;

    final navigatorState = _tabNavigatorKeys[newSelected.index].currentState;
    // note: use nullsafe call because navigator created lazily (fast clicking twice or more throw NPE)
    if (navigatorState == null) {
      // navigator not yet created, simple ignore
      return;
    }

    // pop to first route
    if (BuildConfig.UseOptimizedTabPopMethod) {
      navigatorState.popUntil((route) => route.isFirst);
    } else {
      navigatorState.popUntil((route) => route.isFirst);
    }

    if (scrollToTop) {}
  }

  void _onTabReselectedInFirstRoute(TabItem tabItem) {
    Event.fire(TabReselectedInFirstRouteEvent(tabItem));
  }

  Future<bool> _onWillPop() async {
    final tabIndex = tabController.index;
    final currentTab = TabItem.values[tabIndex];
    final navigatorState = _tabNavigatorKeys[tabIndex].currentState;

    // note: use nullsafe call because navigator created lazily (fast clicking twice or more throw NPE)
    if (navigatorState == null) {
      // navigator not yet created, let system handle back button
      return true;
    }

    final isFirstRouteInCurrentTab = !(await navigatorState.maybePop());
    if (isFirstRouteInCurrentTab) {
      // if not on the [main] tab
      if (currentTab != TabItem.main) {
        // select [main] tab
        tabController.index = TabItem.main.index;
        // back button handled by app
        return false;
      }
    }
    // let system handle back button if we're on the first route
    return isFirstRouteInCurrentTab;
  }

  Widget _buildTabWidget(BuildContext context, int index) {
    final tab = TabItem.values[index];
    return MaterialTabView(
      navigatorKey: _tabNavigatorKeys[index],
      builder: (context) => widget.pages[index],
      navigatorObservers: [
        _tabNavigatorHistoryObservers[index],
      ],
    );
  }

  void _showBottomNav(Route<dynamic>? topRoute) {
    if (_bottomNavShowController.status == AnimationStatus.completed ||
        _bottomNavShowController.status == AnimationStatus.forward) {
      return;
    }
    _bottomNavShowController.forward();
  }

  void _hideBottomNav(Route<dynamic>? topRoute) {
    if (_bottomNavShowController.status == AnimationStatus.dismissed ||
        _bottomNavShowController.status == AnimationStatus.reverse) {
      return;
    }
    _bottomNavShowController.reverse();
  }

  void _onCurrentTabChanged() {
    final tab = TabItem.values[tabController.index];
    _onTabNavStackChanged(tab);
  }

  bool _needHideNavBarForRoute(Route<dynamic> route) {
    final routeName = route.settings.name ?? 'unnamed';
    return routeName.startsWith('/products/');
  }

  void _onTabNavStackChanged(TabItem tab) {
    final isCurrentTab = tabController.index == tab.index;
    if (!isCurrentTab) {
      //ignore
      return;
    }
    final navStack = _tabNavigatorHistoryObservers[tab.index].navigatorStack;
    final currentRoute = navStack.firstWhereOrNull((r) => r.isCurrent);

    // note: on tab switch rute may be null, because [Navigator] created lazily
    if (currentRoute == null) {
      //ignore
      return;
    }
    if (_needHideNavBarForRoute(currentRoute)) {
      _hideBottomNav(currentRoute);
    } else {
      _showBottomNav(currentRoute);
    }
  }

  void _tabDidStartUserGesture(TabItem tab, Route<dynamic> route, Route<dynamic>? prevRoute) {
    /*no-op*/
  }

  void _tabDidStopUserGesture(TabItem tab) {
    /*no-op*/
  }

  @override
  void initState() {
    super.initState();

    tabController.addListener(_onCurrentTabChanged);

    _tabNavigatorHistoryObservers = List<NavigatorHistoryObserver>.generate(
      TabItem.values.length,
      (index) {
        final tab = TabItem.values[index];
        return NavigatorHistoryObserver(
          didStartUserGesture: (r, prev) => _tabDidStartUserGesture(tab, r, prev),
          didStopUserGesture: () => _tabDidStopUserGesture(tab),
        );
      },
      growable: false,
    );
    for (final (index, observer) in _tabNavigatorHistoryObservers.indexed) {
      final tab = TabItem.values[index];
      observer.addListener(() => _onTabNavStackChanged(tab));
    }

    _switchTabSub = Event.on<SwitchTabEvent>().listen((event) {
      tabController.index = event.tabItem.index;
    });
    _switchTabAndResetSub = Event.on<SwitchTabAndResetEvent>().listen((event) {
      _selectTabAndGoToRoot(
        event.tabItem,
        scrollToTop: event.needScrollToTop,
      );
    });
  }

  @override
  void dispose() {
    tabController.removeListener(_onCurrentTabChanged);

    for (final observer in _tabNavigatorHistoryObservers) {
      observer.dispose();
    }

    _switchTabSub?.cancel();
    _switchTabSub = null;

    _switchTabAndResetSub?.cancel();
    _switchTabAndResetSub = null;

    _fcmMessageSub?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          body: Builder(
            builder: (context) {
              final effectiveViewPadding = MediaQuery.maybeViewPaddingOf(
                _bottomNavKey.currentContext ?? context,
              );
              return MaterialTabNavigator(
                tabCount: TabItem.values.length,
                controller: tabController,
                tabBuilder: _buildTabWidget,
                tabSwitchFadeDuration: const Duration(milliseconds: 100),
              );
            },
          ),
          bottomNavigationBar: AnnotatedRegion<SystemUiOverlayStyle>(
            key: _bottomNavKey,
            value: SystemUiOverlayStyle(
              systemNavigationBarColor: Colors.white,
              systemNavigationBarDividerColor: Colors.transparent,
              systemNavigationBarIconBrightness: Brightness.dark,
            ),
            child: SizeTransitionCustom(
              axisAlignment: -1.0,
              fixedCrossAxisSizeFactor: 1.0,
              sizeFactor: _bottomNavShowController.view,
              needClip: false,
              child: AnimatedBuilder(
                animation: tabController,
                builder: (context, child) => BottomNavigation(
                  currentTab: TabItem.values[tabController.index],
                  onSelectTab: _onTabSelected,
                ),
              ),
            ),
          ),
        ),
      );
}

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({
    required this.currentTab,
    required this.onSelectTab,
    super.key,
  });

  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectTab;

  @override
  Widget build(BuildContext context) {
    const tabs = TabItem.values;
    return Theme(
      data: Theme.of(context).copyWith(
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
      ),
      child: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        backgroundColor: context.themeC.background,
        items: tabs.map(
          (tab) {
            final selectedIcon = SvgPicture.asset(
              tab.icon,
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(context.themeC.menuActive, BlendMode.srcIn),
            );
            final unselectedIcon = SvgPicture.asset(
              tab.icon,
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(context.themeC.menuInactive, BlendMode.srcIn),
            );
            return BottomNavigationBarItem(
              icon: unselectedIcon,
              activeIcon: selectedIcon,
              label: '',
            );
          },
        ).toList(growable: false),
        onTap: (index) => onSelectTab(tabs[index]),
        currentIndex: currentTab.index,
        type: BottomNavigationBarType.fixed,
        useLegacyColorScheme: false,
      ),
    );
  }
}
