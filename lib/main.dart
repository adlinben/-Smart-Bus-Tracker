import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'services/notification_service.dart';
import 'screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,);

  FirebaseMessaging.onBackgroundMessage(
    firebaseMessagingBackgroundHandler,);

  await NotificationService.initialize();
  runApp(const SmartBusTracker());
}

class SmartBusTracker extends StatelessWidget {
  const SmartBusTracker({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Smart Bus Tracker",
      home: const SplashScreen(),
    );
  }
}