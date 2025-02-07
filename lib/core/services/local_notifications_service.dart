import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';

late AndroidNotificationChannel channel;
late FlutterLocalNotificationsPlugin localNotificationService;

StreamController pushStreamController = StreamController<RemoteMessage>();

class LocalNotificationService {
  LocalNotificationService();

  bool isFlutterLocalNotificationsInitialized = false;

  var localNotificationService = FlutterLocalNotificationsPlugin();

  final BehaviorSubject<String?> onNotificationClick = BehaviorSubject();

  Future<void> initialize() async {
    if (isFlutterLocalNotificationsInitialized) {
      return;
    }

    channel = const AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
    );

    await localNotificationService
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await localNotificationService
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );

    const AndroidInitializationSettings androidInitializationSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    DarwinInitializationSettings iosInitializationSettings = DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
      onDidReceiveLocalNotification: _onDidReceiveLocalNotification,
    );

    final InitializationSettings settings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    await localNotificationService.initialize(
      settings,
    );

    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    isFlutterLocalNotificationsInitialized = true;
  }

  Future<NotificationDetails> _notificationDetails() async {
    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      channel.id,
      channel.name,
      channelDescription: 'description',
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
    );

    const DarwinNotificationDetails iosNotificationDetails = DarwinNotificationDetails(
      presentSound: true,
      presentBadge: true,
      presentAlert: true,
    );

    return NotificationDetails(android: androidNotificationDetails, iOS: iosNotificationDetails);
  }

  Future<void> showNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    String notificationData = json.encode(message.data);
    // AndroidNotification? android = message.notification?.android;
    // AppleNotification? ios = message.notification?.apple;
    final details = await _notificationDetails();

    await localNotificationService.show(
      notification.hashCode,
      notification!.title,
      notification.body,
      details,
      payload: notificationData,
    );
  }

  void _onDidReceiveLocalNotification(int id, String? title, String? body, String? payload) {
    log('Id: $id');
  }

  void onSelectNotification(String? payload) {
    log('Payload: $payload');
    if (payload != null && payload.isNotEmpty) {
      onNotificationClick.add(payload);
    }
  }
}
