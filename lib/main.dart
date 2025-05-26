import 'dart:async';
import 'dart:developer' as dev;

import 'package:fakestore/app/core/config/api_config.dart';
import 'package:fakestore/app/core/themes/app_theme.dart';
import 'package:fakestore/app/core/themes/app_theme_mode.dart';
import 'package:fakestore/app/core/usecases/usecase.dart';
import 'package:fakestore/app/domain/usecases/initialize_localization.dart';
import 'package:fakestore/app/routes/app_pages.dart';
import 'package:fakestore/di/injector.dart';
import 'package:fakestore/gen/strings.g.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

const String APP_INIT = '[APP INIT]';
const String APP_NAME = 'Fakestore';
const String API_TAG = '[API]';
const String CLASS_TAG = '[MAIN]';

Future<void> main() async {
  await runZonedGuarded(
    () async {
      if (kDebugMode) {
        Logger().i(
          '-->START INIT-->$APP_INIT $API_TAG: ${ApiConfig.BASE_API_URL}',
        );
      }

      WidgetsFlutterBinding.ensureInitialized();

      await Injector.setup();

      await Injector.resolve<InitializeLocalizations>().call(const NoParams());
      final savedThemeMode = await AppTheme.getThemeMode();

      if (kDebugMode) {
        Logger().i('$APP_INIT $API_TAG: ${ApiConfig.BASE_API_URL}');
      }

      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);

      /// Handle general permissions
      // await PermissionHandler.handleStoragePermission();
      // await PermissionHandler.handleLocationPermission();
      // await PermissionHandler.handleCameraPermission();
      // await PermissionHandler.handleMicrophonePermission();

      if (kDebugMode) {
        Logger().i(
          '-->RUN APP-->$APP_INIT $API_TAG: ${ApiConfig.BASE_API_URL}',
        );
      }
      runApp(
        TranslationProvider(
          child: FakestoreApp(themeMode: savedThemeMode),
        ),
      );
    },
    (Object object, StackTrace stackTrace) => dev.log(
      object.toString(),
      error: object,
      stackTrace: stackTrace,
    ),
  );
}

class FakestoreApp extends StatelessWidget {
  const FakestoreApp({
    this.themeMode = AppThemeMode.system,
    super.key,
  });

  final AppThemeMode themeMode;

  @override
  Widget build(BuildContext context) => AppTheme(
        initial: themeMode,
        builder: (context) => GetMaterialApp(
          debugShowCheckedModeBanner: false,
          defaultTransition: Transition.topLevel,
          title: APP_NAME,
          initialRoute: AppPages.INITIAL,
          getPages: AppPages.routes,

          /// Define only one theme
          theme: ThemeData.light(useMaterial3: false),

          /// Localization initialization
          locale: TranslationProvider.of(context).flutterLocale,
          localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
            GlobalWidgetsLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocaleUtils.supportedLocales,
          builder: (context, child) => ScrollConfiguration(
            behavior: const ScrollBehavior().copyWith(
              physics: const BouncingScrollPhysics(),
            ),
            child: MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.noScaling,
              ),
              child: child ?? const SizedBox.shrink(),
            ),
          ),
        ),
      );
}
