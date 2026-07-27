import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const SmartBusTracker());
}
class SmartBusTracker extends StatelessWidget {
  const SmartBusTracker({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Bus Tracker',
      home: const SplashScreen(),
    );
  }
}
