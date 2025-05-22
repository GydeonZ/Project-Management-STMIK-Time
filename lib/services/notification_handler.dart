import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:projectmanagementstmiktime/main.dart';

class NotificationHandler {
  // Singleton pattern
  static final NotificationHandler _instance = NotificationHandler._internal();
  factory NotificationHandler() => _instance;
  NotificationHandler._internal();

  // Initialize notification action listeners
  Future<void> initialize() async {
    // Setup awesome notifications action listener
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: handleAwesomeNotificationAction,
    );

    // Request permissions
    await AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        showNotificationPermissionDialog();
      }
    });
  }

  // Static method to handle notification actions (required for AwesomeNotifications)
  @pragma('vm:entry-point')
  static Future<void> handleAwesomeNotificationAction(
      ReceivedAction receivedAction) async {
    // Get singleton instance and handle the action
    NotificationHandler()._handleNotificationAction(receivedAction);
  }

  // Internal method to handle notification actions
  void _handleNotificationAction(ReceivedAction receivedAction) {
    if (receivedAction.payload == null) return;

    // Get navigation context
    final context = navigatorKey.currentContext;
    if (context == null) return;

    // Handle payload
    handleNotificationByPayload(receivedAction.payload!);
  }

  // Show dialog requesting notification permissions
  void showNotificationPermissionDialog() {
    final context = navigatorKey.currentContext;
    if (context == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Izin Notifikasi'),
        content: const Text(
          'Aplikasi ini memerlukan izin untuk menampilkan notifikasi agar Anda tidak ketinggalan informasi penting.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tolak'),
          ),
          TextButton(
            onPressed: () {
              AwesomeNotifications()
                  .requestPermissionToSendNotifications()
                  .then((_) {
                navigatorKey.currentState!.pop();
              });
            },
            child: const Text('Izinkan'),
          ),
        ],
      ),
    );
  }

  // Handle notification payload
  void handleNotificationByPayload(Map<String, String?> payload) {
    if (payload.isEmpty) return;

    // Get navigation context
    final context = navigatorKey.currentContext;
    if (context == null) return;

    // Check notification type from payload
    final notificationType = payload['type'] ?? '';
    final boardId = payload['board_id'];
    final taskId = payload['task_id'];

    // Handle different notification types
    switch (notificationType) {
      case 'new_task':
        if (boardId != null) {
          // Navigate to board with this task
        }
        break;
      case 'task_comment':
        if (taskId != null) {
          // Navigate to task comments
        }
        break;
      case 'board_invitation':
        if (boardId != null) {
          // Navigate to board
        }
        break;
      default:
        // Handle generic notification
        break;
    }
  }

  // Create a local notification
  Future<void> createLocalNotification({
    required String title,
    required String body,
    Map<String, String>? payload,
  }) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
        channelKey: 'high_importance_channel',
        title: title,
        body: body,
        notificationLayout: NotificationLayout.Default,
        payload: payload,
      ),
    );
  }
}
