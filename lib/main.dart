import 'package:flutter/material.dart';
import 'package:notifications/services/local_notificarions_services.dart';
import 'package:notifications/views/home_screen.dart';
import 'package:notifications/views/pamidor_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalNotificarionsServices.requestPermission();
  await LocalNotificarionsServices.start();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PageView(
        children: const [
          HomeScreen(),
          PamidorScreen(),
        ],
      ),
    );
  }
}
