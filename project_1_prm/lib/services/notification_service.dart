import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:project_1_prm/models/app_notification.dart';
import 'package:project_1_prm/services/firebase_bootstrap_service.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp();
  } catch (_) {
    return;
  }
}

class NotificationService {
  NotificationService({FirebaseMessaging? messaging}) : _messaging = messaging;

  final FirebaseMessaging? _messaging;

  bool get isAvailable => FirebaseBootstrapService.isInitialized;

  FirebaseMessaging get _instance {
    if (!isAvailable) {
      throw StateError('Firebase Messaging is not configured yet.');
    }
    return _messaging ?? FirebaseMessaging.instance;
  }

  Stream<AppNotification> get foregroundNotifications {
    if (!isAvailable) return const Stream<AppNotification>.empty();
    return FirebaseMessaging.onMessage.map(AppNotification.fromRemoteMessage);
  }

  Stream<AppNotification> get openedNotifications {
    if (!isAvailable) return const Stream<AppNotification>.empty();
    return FirebaseMessaging.onMessageOpenedApp.map(
      AppNotification.fromRemoteMessage,
    );
  }

  Future<void> initialize() async {
    if (!isAvailable) return;

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    await _instance.requestPermission();
    await _instance.setAutoInitEnabled(true);
  }

  Future<String?> getToken() async {
    if (!isAvailable) return null;
    return _instance.getToken();
  }

  Future<AppNotification?> getInitialNotification() async {
    if (!isAvailable) return null;

    final message = await _instance.getInitialMessage();
    if (message == null) return null;
    return AppNotification.fromRemoteMessage(message);
  }
}
