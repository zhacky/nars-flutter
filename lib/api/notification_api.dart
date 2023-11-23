import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';

class NotificationApi{
  static final _notifications = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String?>();

  static Future _notificationDetails() async {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        'channel id',
        'channel name',
        importance: Importance.max,
      ),
      iOS: DarwinNotificationDetails()
    );
  }

    static Future init() async{
      final iOS = DarwinInitializationSettings();
      final android = AndroidInitializationSettings('@mipmap/ic_launcher');
      final settings = InitializationSettings(android: android, iOS: iOS);
      await _notifications.initialize(
        settings,
        onDidReceiveNotificationResponse: (payload) async{

        },
      );
    }

  static Future showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload
  })async{
    await _notifications.show(id, title, body, await _notificationDetails(), payload: payload);
  }
}
