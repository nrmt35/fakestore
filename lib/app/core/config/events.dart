import 'package:event_bus/event_bus.dart';
import 'package:fakestore/app/presentation/bottom_navigation/view/bottom_navigation_view.dart';

final _syncEventBus = EventBus(sync: true);

sealed class Event {
  const Event();

  static void fire(Event event) {
    _syncEventBus.fire(event);
  }

  static Stream<T> on<T extends Event>() => _syncEventBus.on<T>();
}

final class TabReselectedInFirstRouteEvent extends Event {
  const TabReselectedInFirstRouteEvent(this.tabItem);

  final TabItem tabItem;
}

final class SwitchTabEvent extends Event {
  const SwitchTabEvent(this.tabItem);

  final TabItem tabItem;
}

final class SwitchTabAndResetEvent extends Event {
  const SwitchTabAndResetEvent(
    this.tabItem, {
    this.needScrollToTop = false,
  });

  final TabItem tabItem;
  final bool needScrollToTop;
}
