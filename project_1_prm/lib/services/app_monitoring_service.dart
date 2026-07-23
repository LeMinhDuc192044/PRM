import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:project_1_prm/services/firebase_bootstrap_service.dart';

class AppMonitoringService {
  const AppMonitoringService._();

  static FirebaseAnalytics? _analytics;
  static FirebaseCrashlytics? _crashlytics;

  static bool get isEnabled => FirebaseBootstrapService.isInitialized;
  static bool get _isAnalyticsSupported =>
      kIsWeb ||
      defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.macOS;
  static bool get _isCrashlyticsSupported =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.macOS);

  static FirebaseAnalyticsObserver? get navigatorObserver {
    final analytics = _analytics;
    if (analytics == null) return null;
    return FirebaseAnalyticsObserver(analytics: analytics);
  }

  static Future<void> initialize() async {
    if (!isEnabled) return;

    if (_isAnalyticsSupported) {
      _analytics = FirebaseAnalytics.instance;
      await _analytics?.logAppOpen();
    }

    if (!_isCrashlyticsSupported) return;

    _crashlytics = FirebaseCrashlytics.instance;

    FlutterError.onError = (details) {
      FlutterError.presentError(details);
      final crashlytics = _crashlytics;
      if (crashlytics != null) {
        unawaited(crashlytics.recordFlutterFatalError(details));
      }
    };

    PlatformDispatcher.instance.onError = (error, stackTrace) {
      final crashlytics = _crashlytics;
      if (crashlytics != null) {
        unawaited(crashlytics.recordError(error, stackTrace, fatal: true));
      }
      return true;
    };
  }

  static Future<void> logLogin({required String method}) async {
    if (!isEnabled) return;
    await _analytics?.logLogin(loginMethod: method);
  }

  static Future<void> logSignOut() async {
    if (!isEnabled) return;
    await _analytics?.logEvent(name: 'sign_out');
  }

  static Future<void> recordError(
    Object error,
    StackTrace stackTrace, {
    bool fatal = false,
  }) async {
    if (!isEnabled || !_isCrashlyticsSupported) return;
    await _crashlytics?.recordError(error, stackTrace, fatal: fatal);
  }
}
