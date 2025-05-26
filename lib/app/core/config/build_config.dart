import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

abstract final class BuildConfig {
  static const bool isDebugBuild = kDebugMode;

  static const bool NeedLockPortraitOrientation = true;
  static const bool EdgeToEdgeModeEnabled = true;

  static const bool UseOptimizedTabPopMethod = true;

  static const int PasswordMinSymbolCount = 5;
  static const int NameMinSymbolCount = 4;
  static const int SurnameMinSymbolCount = 4;
  static const int OtpSymbolCount = 5;

  static bool _appVersionIsInited = false;
  static String AppVersionName = '1.0.0';

  //note: should be called from [main.dart]
  static FutureOr<void> initVersion() {
    if (_appVersionIsInited) {
      return null;
    }

    return PackageInfo.fromPlatform().then((info) {
      BuildConfig.AppVersionName = info.version;
      _appVersionIsInited = true;
    });
  }
}

abstract final class DebugConfig {
  static const bool kDebugLogHttp = true;

  static const bool showCheckedModeBanner = false;
  static const bool showMaterialGrid = false;
  static const bool showPerformanceOverlay = false;
  static const bool checkerboardRasterCacheImages = false;
  static const bool checkerboardOffscreenLayers = false;
  static const bool showSemanticsDebugger = false;
}

/// Feature toggles
abstract final class FeatureToggles {}
