import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:project_1_prm/models/app_notification.dart';
import 'package:project_1_prm/services/notification_service.dart';

class NotificationViewModel extends ChangeNotifier {
  NotificationViewModel({NotificationService? notificationService})
    : _notificationService = notificationService ?? NotificationService() {
    _initialize();
  }

  final NotificationService _notificationService;
  final List<AppNotification> _notifications = <AppNotification>[];
  final List<StreamSubscription<AppNotification>> _subscriptions =
      <StreamSubscription<AppNotification>>[];

  bool _isLoading = false;
  String? _fcmToken;
  String? _errorMessage;

  List<AppNotification> get notifications => List.unmodifiable(_notifications);
  bool get isLoading => _isLoading;
  String? get fcmToken => _fcmToken;
  String? get errorMessage => _errorMessage;
  int get unreadCount =>
      _notifications.where((notification) => !notification.isRead).length;

  Future<void> refreshToken() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _fcmToken = await _notificationService.getToken();
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void markAllRead() {
    for (var index = 0; index < _notifications.length; index++) {
      _notifications[index] = _notifications[index].markRead();
    }
    notifyListeners();
  }

  void clearAll() {
    _notifications.clear();
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> _initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _notificationService.initialize();
      _fcmToken = await _notificationService.getToken();

      final initialNotification = await _notificationService
          .getInitialNotification();
      if (initialNotification != null) {
        _addNotification(initialNotification);
      }

      _subscriptions.addAll(<StreamSubscription<AppNotification>>[
        _notificationService.foregroundNotifications.listen(_addNotification),
        _notificationService.openedNotifications.listen(_addNotification),
      ]);
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _addNotification(AppNotification notification) {
    final existingIndex = _notifications.indexWhere(
      (existing) => existing.id == notification.id,
    );
    if (existingIndex >= 0) {
      _notifications[existingIndex] = notification;
    } else {
      _notifications.insert(0, notification);
    }
    notifyListeners();
  }

  @override
  void dispose() {
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
    super.dispose();
  }
}
