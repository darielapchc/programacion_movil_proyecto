import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  NotificationService._();

  static final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'registro_channel',
    'Registro de usuarios',
    description: 'Notificaciones relacionadas con el registro de usuarios.',
    importance: Importance.high,
  );

  static Future<void> initialize() async {
    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings = InitializationSettings( android: androidSettings );
    await _notifications.initialize( settings: initializationSettings );

    final androidPlugin = _notifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.createNotificationChannel(_channel);
  }

  static Future<void> requestPermission() async {
    final androidPlugin = _notifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.requestNotificationsPermission();
  }

  static Future<void> showRegistrationNotification({
    required String fullName,
  }) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'registro_channel',
      'Registro de usuarios',
      channelDescription: 'Notificaciones relacionadas con el registro de usuarios.',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails = NotificationDetails(android: androidDetails);

    await _notifications.show(
      id: 1,
      title: '¡Usuario registrado!',
      body: '$fullName fue registrado correctamente.',
      notificationDetails: notificationDetails,
    );
  }
}