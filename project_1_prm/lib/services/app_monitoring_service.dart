import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:project_1_prm/services/firebase_bootstrap_service.dart';

class AppMonitoringService {
  const AppMonitoringService._();

  static FirebaseAnalytics? _analytics;
  static FirebaseCrashlytics? _crashlytics;

  static bool get isEnabled => FirebaseBootstrapService.isInitialized;

  static FirebaseAnalyticsObserver? get navigatorObserver {
    final analytics = _analytics;
    if (analytics == null) return null;
    return FirebaseAnalyticsObserver(analytics: analytics);
  }

  static Future<void> initialize() async {
    if (!isEnabled) return;

    _analytics = FirebaseAnalytics.instance;
    _crashlytics = FirebaseCrashlytics.instance;

    FlutterError.onError = (details) {
      FlutterError.presentError(details);
      _crashlytics?.recordFlutterFatalError(details);
    };

    PlatformDispatcher.instance.onError = (error, stackTrace) {
      _crashlytics?.recordError(error, stackTrace, fatal: true);
      return true;
    };

    await _analytics?.logAppOpen();
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
    if (!isEnabled) return;
    await _crashlytics?.recordError(error, stackTrace, fatal: fatal);
  }
}
