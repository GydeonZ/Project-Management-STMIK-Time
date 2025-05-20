import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import '../../firebase_options.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print('Handling a background message ${message.messageId}');

  // Create an Awesome Notification from the FCM message
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: message.hashCode,
      channelKey: 'high_importance_channel',
      title: message.notification?.title ?? 'New Notification',
      body: message.notification?.body ?? '',
      notificationLayout: NotificationLayout.Default,
      payload:
          message.data.map((key, value) => MapEntry(key, value.toString())),
    ),
  );
}

class NotificationService {
  static late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  static late AndroidNotificationChannel channel;
  static bool isFlutterLocalNotificationsInitialized = false;
  static bool isAwesomeNotificationsInitialized = false;

  initNotifications() async {
    // Initialize Awesome Notifications
    await initializeAwesomeNotifications();

    // Setup Firebase
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen(showNotification);

    // Setup Local Notifications
    if (!kIsWeb) {
      await setupFlutterNotifications();
    }

    // Register for FCM notifications
    await requestNotificationPermissions();
  }

  Future<void> initializeAwesomeNotifications() async {
    if (isAwesomeNotificationsInitialized) return;

    await AwesomeNotifications().initialize(
        'resource://drawable/timelogo',
        [
          NotificationChannel(
            channelKey: 'high_importance_channel',
            channelName: 'High Importance Notifications',
            channelDescription: 'Channel for important notifications',
            defaultColor: const Color(0xFF484F88),
            ledColor: const Color(0xFF484F88),
            importance: NotificationImportance.High,
            vibrationPattern: highVibrationPattern,
            defaultRingtoneType: DefaultRingtoneType.Notification,
            icon: 'resource://drawable/timelogo',
          ),
        ],
        debug: true);

    isAwesomeNotificationsInitialized = true;
  }

  Future<void> requestNotificationPermissions() async {
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    await AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }

  Future<String?> getToken() async {
    String? token = await FirebaseMessaging.instance.getToken(
        vapidKey:
            'BNKkaUWxyP_yC_lki1kYazgca0TNhuzt2drsOrL6WrgGbqnMnr8ZMLzg_rSPDm6HKphABS0KzjPfSqCXHXEd06Y');

    print("FCM Token: $token");
    return token;
  }

  Future<void> setupFlutterNotifications() async {
    if (isFlutterLocalNotificationsInitialized) {
      return;
    }
    channel = const AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
    );
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    isFlutterLocalNotificationsInitialized = true;
  }

  void showNotification(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    // Create notification using Awesome Notifications
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: notification.hashCode,
        channelKey: 'high_importance_channel',
        title: notification?.title ?? 'New Notification',
        body: notification?.body ?? '',
        notificationLayout: NotificationLayout.Default,
        payload:
            message.data.map((key, value) => MapEntry(key, value.toString())),
        icon: 'resource://drawable/timelogo',
      ),
    );

    // Also show with system notification for reliability
    if (notification != null && android != null && !kIsWeb) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            icon: 'timelogo',
          ),
        ),
      );
    }
  }

  // Handle notification tap action
  static Future<void> setupNotificationActionListeners(
      Function(Map<String, dynamic>) onNotificationTap) async {
    // For when app is terminated and opened via notification
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        onNotificationTap(message.data);
      }
    });

    // For when app is in background and opened via notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      onNotificationTap(message.data);
    });

    // For Awesome Notifications tap actions
    await AwesomeNotifications().setListeners(
      onActionReceivedMethod: (ReceivedAction receivedAction) async {
        if (receivedAction.payload != null) {
          // Convert Map<String, String?> to Map<String, dynamic>
          final Map<String, dynamic> dynamicPayload = {};
          receivedAction.payload!.forEach((key, value) {
            dynamicPayload[key] = value;
          });
          onNotificationTap(dynamicPayload);
        }
      },
    );
  }
}
