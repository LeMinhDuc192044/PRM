import 'package:firebase_messaging/firebase_messaging.dart';

class AppNotification {
  const AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.receivedAt,
    this.data = const <String, dynamic>{},
    this.isRead = false,
  });

  final String id;
  final String title;
  final String body;
  final DateTime receivedAt;
  final Map<String, dynamic> data;
  final bool isRead;

  factory AppNotification.fromRemoteMessage(RemoteMessage message) {
    return AppNotification(
      id: message.messageId ?? DateTime.now().microsecondsSinceEpoch.toString(),
      title: message.notification?.title ?? 'Notification',
      body: message.notification?.body ?? 'You have a new update.',
      receivedAt: message.sentTime ?? DateTime.now(),
      data: message.data,
    );
  }

  AppNotification markRead() {
    return AppNotification(
      id: id,
      title: title,
      body: body,
      receivedAt: receivedAt,
      data: data,
      isRead: true,
    );
  }
}
