import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'registration_page.dart';

// Обработчик push-уведомлений в фоновом режиме
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Получено фоновое уведомление: ${message.notification?.title}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Инициализация Firebase
  await Firebase.initializeApp();

  // Настройка Push-уведомлений (FCM)
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // Запрос прав на показ уведомлений
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );
  print('Статус разрешения уведомлений: ${settings.authorizationStatus}');

  // Получение FCM-токена для тестирования пушей
  String? token = await messaging.getToken();
  print('================ FCM TOKEN ================');
  print(token);
  print('===========================================');

  // Слушатель уведомлений, когда приложение открыто
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Получено уведомление: ${message.notification?.title}');
  });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lab 7 Firebase',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const RegistrationPage(),
    );
  }
}