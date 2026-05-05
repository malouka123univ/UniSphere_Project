import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _notificationsPlugin.initialize(initializationSettings);
  }

  static Future<void> showInstantNotification(String title, String body) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'channel_id',
          'Announcements',
          importance: Importance.max,
          priority: Priority.high,
        );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
    );

    // الحل هنا: استخدام الأسماء المحددة (id, title, body, notificationDetails)
    // الحل الصحيح: نضع اسم المتغير قبل قيمته
    await _notificationsPlugin.show(
      id: 0, // أضفنا كلمة id هنا
      title: title, // أضفنا كلمة title هنا
      body: body, // أضفنا كلمة body هنا
      notificationDetails: platformDetails, // أضفنا هذا الاسم الطويل هنا
    );
  }
}
