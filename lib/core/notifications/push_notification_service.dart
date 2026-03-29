import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

const String _channelId = 'high_importance_channel';
const String _channelName = 'App notifications';
const String _channelDescription = 'Notifications for case updates and alerts.';

final FlutterLocalNotificationsPlugin _localNotifications =
    FlutterLocalNotificationsPlugin();
final AndroidNotificationChannel _androidChannel = AndroidNotificationChannel(
  _channelId,
  _channelName,
  description: _channelDescription,
  importance: Importance.high,
);

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  await PushNotificationService.instance._showLocalNotification(message);
}

class PushNotificationService {
  PushNotificationService._();

  static final PushNotificationService instance = PushNotificationService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> initialize() async {
    await _ensureLocalNotificationsInitialized();
    await _requestPermissions();

    FirebaseMessaging.onMessage.listen(_showLocalNotification);
  }

  Future<String?> getToken() => _messaging.getToken();

  Stream<String> onTokenRefresh() => _messaging.onTokenRefresh;

  Future<void> _requestPermissions() async {
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> _ensureLocalNotificationsInitialized() async {
    const settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );

    await _localNotifications.initialize(settings);

    final androidPlugin = _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    await androidPlugin?.createNotificationChannel(_androidChannel);
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    await _ensureLocalNotificationsInitialized();

    final notification = message.notification;
    final title = notification?.title ?? message.data['title'] as String?;
    final body = notification?.body ?? message.data['body'] as String?;

    if (title == null && body == null) return;

    final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    await _localNotifications.show(
      id,
      title ?? 'Notification',
      body ?? '',
      NotificationDetails(
        android: AndroidNotificationDetails(
          _androidChannel.id,
          _androidChannel.name,
          channelDescription: _androidChannel.description,
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      payload: message.data.isEmpty ? null : message.data.toString(),
    );
  }
}
