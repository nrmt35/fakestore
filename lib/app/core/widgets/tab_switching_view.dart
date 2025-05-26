import 'package:flutter/material.dart';

/// A widget laying out multiple tabs with only one active tab being built
/// at a time and on stage. Off stage tabs' animations are stopped.
class TabSwitchingView extends StatefulWidget {
  const TabSwitchingView({
    super.key,
    required this.currentTabIndex,
    this.fadeDuration = const Duration(milliseconds: 150),
    required this.tabCount,
    required this.tabBuilder,
  }) : assert(tabCount > 0);

  final int currentTabIndex;
  final int tabCount;
  final Duration fadeDuration;
  final IndexedWidgetBuilder tabBuilder;

  @override
  State<TabSwitchingView> createState() => _TabSwitchingViewState();
}

class _TabSwitchingViewState extends State<TabSwitchingView> with SingleTickerProviderStateMixin {
  late final AnimationController controller = AnimationController(
    vsync: this,
    duration: widget.fadeDuration,
  );
  int currentTabIndex = 0;

  final List<bool> shouldBuildTab = <bool>[];
  final List<FocusScopeNode> tabFocusNodes = <FocusScopeNode>[];

  // When focus nodes are no longer needed, we need to dispose of them, but we
  // can't be sure that nothing else is listening to them until this widget is
  // disposed of, so when they are no longer needed, we move them to this list,
  // and dispose of them when we dispose of this widget.
  final List<FocusScopeNode> discardedNodes = <FocusScopeNode>[];

  @override
  void initState() {
    super.initState();

    controller.value = 1.0;
    currentTabIndex = widget.currentTabIndex;

    shouldBuildTab.addAll(List<bool>.filled(widget.tabCount, false));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _focusActiveTab();
  }

  @override
  void didUpdateWidget(TabSwitchingView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.fadeDuration != oldWidget.fadeDuration) {
      controller.duration = widget.fadeDuration;
    }
    if (widget.currentTabIndex != oldWidget.currentTabIndex) {
      controller.reverse().then((_) {
        setState(() => currentTabIndex = widget.currentTabIndex);
        //TODO: focus handling
        //_focusActiveTab();
        controller.forward();
      });
    }

    // Only partially invalidate the tabs cache to avoid breaking the current
    // behavior. We assume that the only possible change is either:
    // - new tabs are appended to the tab list, or
    // - some trailing tabs are removed.
    // If the above assumption is not true, some tabs may lose their state.
    final int lengthDiff = widget.tabCount - shouldBuildTab.length;
    if (lengthDiff > 0) {
      shouldBuildTab.addAll(List<bool>.filled(lengthDiff, false));
    } else if (lengthDiff < 0) {
      shouldBuildTab.removeRange(widget.tabCount, shouldBuildTab.length);
    }
    _focusActiveTab();
  }

  // Will focus the active tab if the FocusScope above it has focus already. If
  // not, then it will just mark it as the preferred focus for that scope.
  void _focusActiveTab() {
    if (tabFocusNodes.length != widget.tabCount) {
      if (tabFocusNodes.length > widget.tabCount) {
        discardedNodes.addAll(tabFocusNodes.sublist(widget.tabCount));
        tabFocusNodes.removeRange(widget.tabCount, tabFocusNodes.length);
      } else {
        tabFocusNodes.addAll(
          List<FocusScopeNode>.generate(
            widget.tabCount - tabFocusNodes.length,
            (index) => FocusScopeNode(
              debugLabel: '$TabSwitchingView Tab ${index + tabFocusNodes.length}',
            ),
          ),
        );
      }
    }
    //TODO: focus handling
    //FocusScope.of(context).setFirstFocus(tabFocusNodes[currentTabIndex]);
    FocusScope.of(context).setFirstFocus(tabFocusNodes[widget.currentTabIndex]);
  }

  @override
  void dispose() {
    controller.dispose();

    for (final FocusScopeNode focusScopeNode in tabFocusNodes) {
      focusScopeNode.dispose();
    }
    for (final FocusScopeNode focusScopeNode in discardedNodes) {
      focusScopeNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: controller,
      child: Stack(
        fit: StackFit.expand,
        children: List<Widget>.generate(
          growable: false,
          widget.tabCount,
          (index) {
            final bool active = index == currentTabIndex;
            shouldBuildTab[index] = active || shouldBuildTab[index];

            return HeroMode(
              enabled: active,
              child: Offstage(
                offstage: !active,
                child: TickerMode(
                  enabled: active,
                  child: FocusScope(
                    node: tabFocusNodes[index],
                    child: Builder(
                      builder: (context) {
                        return shouldBuildTab[index] //
                            ? widget.tabBuilder(context, index)
                            : const SizedBox.shrink();
                      },
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
