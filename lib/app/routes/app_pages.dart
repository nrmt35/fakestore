import 'package:fakestore/app/presentation/auth/view/auth_page.dart';
import 'package:fakestore/app/presentation/bottom_navigation/view/bottom_navigation_view.dart';
import 'package:fakestore/app/presentation/splash/view/splash_page.dart';
import 'package:get/get.dart';

part 'app_routes.dart';

const ANIMATION_PAGE_TRANSITION_DURATION = Duration(milliseconds: 300);

class AppPages {
  static const String INITIAL = Routes.LOADING;

  static final routes = <GetPage>[
    GetPage(
      name: Routes.LOADING,
      transition: Transition.fade,
      transitionDuration: ANIMATION_PAGE_TRANSITION_DURATION,
      page: () => const SplashPage(),
    ),
    GetPage(
      name: Routes.AUTH_SCREEN,
      transition: Transition.fade,
      transitionDuration: ANIMATION_PAGE_TRANSITION_DURATION,
      page: () => const AuthPage(),
    ),
    GetPage(
      name: Routes.MAIN_SCREEN,
      transition: Transition.fade,
      transitionDuration: ANIMATION_PAGE_TRANSITION_DURATION,
      page: () => const BottomNavigationPage(),
    ),
  ];

  String getCurrentPage() => Get.currentRoute;
}
