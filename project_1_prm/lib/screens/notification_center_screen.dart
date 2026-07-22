import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project_1_prm/viewmodels/notification_view_model.dart';

class NotificationCenterScreen extends StatelessWidget {
  const NotificationCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Center'),
        actions: <Widget>[
          Consumer<NotificationViewModel>(
            builder: (context, viewModel, child) {
              return IconButton(
                onPressed: viewModel.notifications.isEmpty
                    ? null
                    : viewModel.markAllRead,
                icon: const Icon(Icons.done_all_rounded),
                tooltip: 'Mark all read',
              );
            },
          ),
          Consumer<NotificationViewModel>(
            builder: (context, viewModel, child) {
              return IconButton(
                onPressed: viewModel.notifications.isEmpty
                    ? null
                    : viewModel.clearAll,
                icon: const Icon(Icons.delete_sweep_rounded),
                tooltip: 'Clear all',
              );
            },
          ),
        ],
      ),
      body: Consumer<NotificationViewModel>(
        builder: (context, viewModel, child) {
          _handleError(context, viewModel);

          if (viewModel.isLoading && viewModel.notifications.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: <Widget>[
              _NotificationSummaryCard(token: viewModel.fcmToken),
              const SizedBox(height: 16),
              if (viewModel.notifications.isEmpty)
                const _EmptyNotificationState()
              else
                ...viewModel.notifications.map(
                  (notification) => _NotificationCard(
                    title: notification.title,
                    body: notification.body,
                    receivedAt: notification.receivedAt,
                    isRead: notification.isRead,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  void _handleError(BuildContext context, NotificationViewModel viewModel) {
    if (viewModel.errorMessage == null) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!context.mounted || viewModel.errorMessage == null) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(viewModel.errorMessage!),
          behavior: SnackBarBehavior.floating,
        ),
      );
      viewModel.clearError();
    });
  }
}

class _NotificationSummaryCard extends StatelessWidget {
  const _NotificationSummaryCard({required this.token});

  final String? token;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'FCM Token',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              token ?? 'Unavailable until Firebase Messaging is configured.',
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({
    required this.title,
    required this.body,
    required this.receivedAt,
    required this.isRead,
  });

  final String title;
  final String body;
  final DateTime receivedAt;
  final bool isRead;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      color: isRead ? null : const Color(0xFFEFF6FF),
      child: ListTile(
        leading: Icon(
          isRead
              ? Icons.notifications_none_rounded
              : Icons.notifications_active,
        ),
        title: Text(title),
        subtitle: Text('$body\n${_formatTimestamp(receivedAt)}'),
        isThreeLine: true,
      ),
    );
  }

  String _formatTimestamp(DateTime value) {
    final localValue = value.toLocal();
    final date = localValue.toIso8601String().split('T').first;
    final time = localValue.toIso8601String().split('T').last.substring(0, 5);
    return '$date $time';
  }
}

class _EmptyNotificationState extends StatelessWidget {
  const _EmptyNotificationState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 64),
      child: Column(
        children: <Widget>[
          Icon(
            Icons.notifications_off_outlined,
            size: 72,
            color: Theme.of(
              context,
            ).colorScheme.primary.withValues(alpha: 0.35),
          ),
          const SizedBox(height: 16),
          Text(
            'No notifications yet',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          const Text(
            'Foreground and opened push notifications will appear here.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
