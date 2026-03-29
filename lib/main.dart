import 'package:cctv_app/core/notifications/push_notification_service.dart';
import 'package:cctv_app/core/session/app_session_manager.dart';
import 'package:cctv_app/feature/session/session_gate.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await PushNotificationService.instance.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, screenType) {
        return MaterialApp(
          navigatorKey: AppSessionManager.instance.navigatorKey,
          debugShowCheckedModeBanner: false,
          title: 'CCTV Mobile App',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          ),
          home: const SessionGate(),
        );
      },
    );
  }
}
